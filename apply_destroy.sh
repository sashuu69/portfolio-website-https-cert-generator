#!/bin/bash

echo "[INFO] Portfolio Website SSL Certificate Generator"
echo "[INFO] Setting up Terraform"
terraform init
echo "[INFO] Bringing up Generator"
terraform apply --auto-approve
echo "[INFO] Brining down Generator"
terraform destroy --auto-approve
