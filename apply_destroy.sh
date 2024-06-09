#!/bin/bash

: "${TF_VAR_prefix?not set}"
: "${TF_VAR_aws_access_key_id?not set}"
: "${TF_VAR_aws_secret_access_key?not set}"
: "${TF_VAR_region?not set}"
: "${TF_VAR_cloudflare_mail?not set}"
: "${TF_VAR_cloudflare_api_key?not set}"
: "${TF_VAR_vpc_cidr_block?not set}"
: "${TF_VAR_subnet_cidr_block?not set}"
: "${TF_VAR_route_table_cidr_block?not set}"
: "${TF_VAR_public_key_path?not set}"
: "${TF_VAR_ingress_ports?not set}"
: "${TF_VAR_egress_ports?not set}"
: "${TF_VAR_ami?not set}"
: "${TF_VAR_instance_type?not set}"
: "${TF_VAR_instance_username?not set}"
: "${TF_VAR_inventory_path?not set}"
: "${TF_VAR_cloudflare_zone_id?not set}"
: "${TF_VAR_pw_ssl_updater_domain_name?not set}"
: "${TF_VAR_mail_address?not set}"
: "${TF_VAR_cert_path?not set}"

set -e
export DEBIAN_FRONTEND="noninteractive"
export LANG=C

echo "[INFO] Portfolio Website SSL Certificate Generator"
echo "[INFO] Updating system"
apt-get update -y && apt-get upgrade -y

echo "[INFO] Installing Terraform, Ansible and necessary packages"
apt install -y gnupg software-properties-common wget
wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null
gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    tee /etc/apt/sources.list.d/hashicorp.list
add-apt-repository --yes --update ppa:ansible/ansible
apt-get update -y && apt-get install -y terraform ansible

echo "[INFO] Setting up Terraform for SSL Generator"
terraform init

echo "[INFO] Bringing up SSL Generator"
terraform apply --auto-approve

echo "[INFO] Bringing down SSL Generator"
terraform destroy --auto-approve
