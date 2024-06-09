# Portfolio Website SSL Certificate Generator

## Status

![Website Status](https://img.shields.io/website?url=https%3A%2F%2Fsashwat.in)
[![Ansible Lint CI](https://github.com/sashuu69/portfolio-website-ssl-cert-generator/actions/workflows/ansible-lint.yaml/badge.svg)](https://github.com/sashuu69/portfolio-website-ssl-cert-generator/actions/workflows/ansible-lint.yaml)
[![Terraform Validate CI](https://github.com/sashuu69/portfolio-website-ssl-cert-generator/actions/workflows/terraform-validate.yml/badge.svg)](https://github.com/sashuu69/portfolio-website-ssl-cert-generator/actions/workflows/terraform-validate.yml)

## Introduction

The repository contains code to generate and renew SSL certificates for Portfolio Website. The certificates are generated using terraform and ansible.

The terraform brings up VPC, subnet, gateway, route table, security group, floating IP and EC2 instance along with DNS entry in cloudflare. After the instance is brought up, ansible generates SSL certificates and saves it under `build/`.

## Instructions

1. Make sure docker is installed on the host.
2. Copy contents of `env.template` to `env`.
   
    ```bash
    cp env.template env
    ```
3. Update `my-settings.auto.tfvars` to appropriate values. The following is an example.

    ```bash
    sashuu69@Sashwats-MacBook-Pro portfolio-website-https-cert-generator % cat env
    export PW_PREFIX="pw"
    export PW_AWS_ACCESS_KEY_ID="<AWS-ACCESS-KEY-ID>"
    export PW_AWS_SECRET_ACCESS_KEY="<AWS-SECRET-ACCESS-KEY>"
    export PW_AWS_REGION="ap-south-1"
    export PW_CLOUDFLARE_MAIL="<CLOUDFLARE-MAIL-ID>"
    export PW_CLOUDFLARE_API_KEY="<CLOUDFLARE-API-KEY>"
    export PW_AWS_VPC_CIDR_BLOCK="10.0.0.0/16"
    export PW_AWS_SUBNET_CIDR_BLOCK="10.0.1.0/24"
    export PW_AWS_ROUTE_CIDR_BLOCK="0.0.0.0/0"
    export PW_AWS_PUBLIC_KEY_PATH="build/ssh/id_rsa.pub"
    export PW_AWS_INGRESS_PORTS="[22,80,443]"
    export PW_AWS_EGRESS_PORTS="[0]"
    export PW_AWS_AMI="ami-0f58b397bc5c1f2e8"
    export PW_INSTANCE_TYPE="t2.micro"
    export PW_INSTANCE_USERNAME="ubuntu"
    export PW_ANSIBLE_INVENTORY_PATH="build/inventory.ini"
    export PW_CLOUDFLARE_ZONE_ID="<CLOUDFLARE-ZONE-ID>"
    export PW_DOMAIN_NAME="<DOMAIN>"
    export PW_MAIL_ADDRESS="<MAIL-ADDRESS>"
    export PW_SSL_CERT_PATH="/tmp/certs"
    sashuu69@Sashwats-MacBook-Pro portfolio-website-https-cert-generator %
    ```
4. Run `run.sh` to generate the certificates. The certs will be available as tar under  `build/<ip-address>/tmp`.
5. Untar the tar file under the above mentioned path. The certificates include `<domain>.crt`, `<domain>.issuer.crt`, `<domain>.json` and `<domain>.key`.

## Contributors

1. Sashwat K <sashwat0001@gmail.com>

## Other Info

If you face any bugs or want to request a new feature, please create an issue under the repository and provide appropriate labels respectively. If you want to do these by yourself, feel free to raise a PR and I will do what is necessary.

If you want to support me, donations will be helpful.

## Other Repo(s)

1. [sashuu69/portfolio-website](https://github.com/sashuu69/portfolio-website) - The portfolio website flask app
2. [sashuu69/portfolio-website-docker-compose](https://github.com/sashuu69/portfolio-website-docker-compose) - The docker-compose code to bring up portfolio website
3. [sashuu69/portfolio-website-infrastructure](https://github.com/sashuu69/portfolio-website-infrastructure) - The terraform and ansible code to bring portfolio website on AWS
