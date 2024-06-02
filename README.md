# Portfolio Website SSL Certificate Generator

## Status

![Website Status](https://img.shields.io/website?url=https%3A%2F%2Fsashwat.in)
[![Ansible Lint CI](https://github.com/sashuu69/portfolio-website-ssl-cert-generator/actions/workflows/ansible-lint.yaml/badge.svg)](https://github.com/sashuu69/portfolio-website-ssl-cert-generator/actions/workflows/ansible-lint.yaml)
[![Terraform Validate CI](https://github.com/sashuu69/portfolio-website-ssl-cert-generator/actions/workflows/terraform-validate.yml/badge.svg)](https://github.com/sashuu69/portfolio-website-ssl-cert-generator/actions/workflows/terraform-validate.yml)

## Introduction

The repository contains code to generate and renew SSL certificates for Portfolio Website. The certificates are generated using terraform and ansible.

The terraform brings up VPC, subnet, gateway, route table, security group, floating IP and EC2 instance along with DNS entry in cloudflare. After the instance is brought up, ansible generates SSL certificates and saves it under `build/`.

## Instructions

1. Make sure terraform and ansible is installed in the host.
2. Copy contents of `my-settings.auto.tfvars-template` to `my-settings.auto.tfvars`.
   
    ```bash
    cp my-settings.auto.tfvars-template my-settings.auto.tfvars
    ```
3. Update `my-settings.auto.tfvars` to appropriate values.
4. Run `apply_wait_destroy.sh` to generate the certificates.

## Contributors

1. Sashwat K <sashwat0001@gmail.com>

## Other Info

If you face any bugs or want to request a new feature, please create an issue under the repository and provide appropriate labels respectively. If you want to do these by yourself, feel free to raise a PR and I will do what is necessary.

If you want to support me, donations will be helpful.

## Other Repo(s)

1. [sashuu69/portfolio-website](https://github.com/sashuu69/portfolio-website) - The portfolio website flask app
2. [sashuu69/portfolio-website-docker-compose](https://github.com/sashuu69/portfolio-website-docker-compose) - The docker-compose code to bring up portfolio website
3. [sashuu69/portfolio-website-infrastructure/](https://github.com/sashuu69/portfolio-website-infrastructure) - The terraform and ansible code to bring portfolio website on AWS