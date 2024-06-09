#!/bin/bash

docker run \
    -e TF_VAR_prefix="$PW_PREFIX" \
    -e TF_VAR_aws_access_key_id="$PW_AWS_ACCESS_KEY_ID" \
    -e TF_VAR_aws_secret_access_key="$PW_AWS_SECRET_ACCESS_KEY" \
    -e TF_VAR_region="$PW_AWS_REGION" \
    -e TF_VAR_cloudflare_mail="$PW_CLOUDFLARE_MAIL" \
    -e TF_VAR_cloudflare_api_key="$PW_CLOUDFLARE_API_KEY" \
    -e TF_VAR_vpc_cidr_block="$PW_AWS_VPC_CIDR_BLOCK" \
    -e TF_VAR_subnet_cidr_block="$PW_AWS_SUBNET_CIDR_BLOCK" \
    -e TF_VAR_route_table_cidr_block="$PW_AWS_ROUTE_CIDR_BLOCK" \
    -e TF_VAR_public_key_path="$PW_AWS_PUBLIC_KEY_PATH" \
    -e TF_VAR_ingress_ports="$PW_AWS_INGRESS_PORTS" \
    -e TF_VAR_egress_ports="$PW_AWS_EGRESS_PORTS" \
    -e TF_VAR_ami="$PW_AWS_AMI" \
    -e TF_VAR_instance_type="$PW_INSTANCE_TYPE" \
    -e TF_VAR_instance_username="$PW_INSTANCE_USERNAME" \
    -e TF_VAR_inventory_path="$PW_ANSIBLE_INVENTORY_PATH" \
    -e TF_VAR_cloudflare_zone_id="$PW_CLOUDFLARE_ZONE_ID" \
    -e TF_VAR_pw_ssl_updater_domain_name="$PW_DOMAIN_NAME" \
    -e TF_VAR_mail_address="$PW_MAIL_ADDRESS" \
    -e TF_VAR_cert_path="$PW_SSL_CERT_PATH" \
    -v "$PWD:/build" \
    -w /build \
    --rm docker.io/ubuntu:noble \
    /build/apply_destroy.sh
