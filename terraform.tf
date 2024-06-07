terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "<= 5.51.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "<= 4.33.0"
    }
  }
}

# Define aws provider
provider "aws" {
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
  region     = var.region
}

# Define cloudflare provider
provider "cloudflare" {
  email   = var.cloudflare_mail
  api_key = var.cloudflare_api_key
}

# Define global variables
locals {
  tags = {
    Name          = var.prefix
    Maintained_By = "Terraform"
  }
  private_key_path = replace(var.public_key_path, ".pub", "")
}

# Create VPC
resource "aws_vpc" "pw_ssl_updater_vpc" {
  cidr_block = var.vpc_cidr_block
  tags       = local.tags
}

# Create Subnet
resource "aws_subnet" "pw_ssl_updater_subnet" {
  vpc_id                  = aws_vpc.pw_ssl_updater_vpc.id
  cidr_block              = var.subnet_cidr_block
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true
  tags                    = local.tags
}

# Create Internet Gateway
resource "aws_internet_gateway" "pw_ssl_updater_igw" {
  vpc_id = aws_vpc.pw_ssl_updater_vpc.id
  tags   = local.tags
}

# Create Route Table
resource "aws_route_table" "pw_ssl_updater_route_table" {
  vpc_id = aws_vpc.pw_ssl_updater_vpc.id

  route {
    cidr_block = var.route_table_cidr_block
    gateway_id = aws_internet_gateway.pw_ssl_updater_igw.id
  }

  tags = local.tags
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "pw_ssl_updater_subnet_association" {
  subnet_id      = aws_subnet.pw_ssl_updater_subnet.id
  route_table_id = aws_route_table.pw_ssl_updater_route_table.id
}

# Create Security Group
resource "aws_security_group" "pw_ssl_updater_security_group" {
  vpc_id = aws_vpc.pw_ssl_updater_vpc.id

  # Allow inbound traffic
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = [var.route_table_cidr_block]
    }
  }

  # Allow outbound traffic
  dynamic "egress" {
    for_each = var.egress_ports
    content {
      from_port   = egress.value
      to_port     = egress.value
      protocol    = "-1"
      cidr_blocks = [var.route_table_cidr_block]
    }
  }

  tags = local.tags
}

# Allocate Elastic IP
resource "aws_eip" "pw_ssl_updater_eip" {
  domain = "vpc"
  tags   = local.tags
}

# Create SSH Key Pair
resource "aws_key_pair" "pw_ssl_updater_key_pair" {
  key_name   = "${var.prefix}-key"
  public_key = file(var.public_key_path)
  tags       = local.tags
}

# Associate Elastic IP with EC2 instance
resource "aws_eip_association" "pw_ssl_updater_eip_association" {
  instance_id   = aws_instance.pw_ssl_updater_instance.id
  allocation_id = aws_eip.pw_ssl_updater_eip.id
}

# Create EC2 instance
resource "aws_instance" "pw_ssl_updater_instance" {
  ami               = var.ami
  instance_type     = var.instance_type
  subnet_id         = aws_subnet.pw_ssl_updater_subnet.id
  security_groups   = [aws_security_group.pw_ssl_updater_security_group.id]
  availability_zone = "${var.region}a"
  key_name          = aws_key_pair.pw_ssl_updater_key_pair.id
  tags              = local.tags
}

locals {
  dns_records = [
    {
      name  = var.pw_ssl_updater_domain_name
      value = aws_eip_association.pw_ssl_updater_eip_association.public_ip
      type  = "A"
    },
    {
      name  = "www.${var.pw_ssl_updater_domain_name}"
      value = var.pw_ssl_updater_domain_name
      type  = "CNAME"
    }
  ]
}

# Set Cloudflare DNS records
resource "cloudflare_record" "pw_ssl_updater_dns_records" {
  for_each = { for record in local.dns_records : record.name => record }

  zone_id = var.cloudflare_zone_id
  name    = each.value.name
  value   = each.value.value
  type    = each.value.type

  depends_on = [aws_instance.pw_ssl_updater_instance]
}

# Create inventory file
resource "local_file" "pw_ssl_updater_inventory_file" {
  content  = <<EOF
[aws]
${aws_eip_association.pw_ssl_updater_eip_association.public_ip} ansible_user=${var.instance_username} ansible_ssh_private_key_file=${local.private_key_path} ansible_ssh_common_args='-o StrictHostKeyChecking=no'
  EOF
  filename = var.inventory_path
}

# Run ansible playbook to generate SSL
resource "null_resource" "pw_ssl_updater_ansible_playbook" {
  triggers = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = <<EOT
    sleep 20
    ansible-playbook -i ${var.inventory_path} playbook.yaml \
      --extra-vars "mail_address=${var.mail_address} domain=${var.pw_ssl_updater_domain_name} cert_path=${var.cert_path} expiry_days=${var.expiry_dates}d"
    EOT
  }

  depends_on = [
    aws_instance.pw_ssl_updater_instance,
    local_file.pw_ssl_updater_inventory_file
  ]
}