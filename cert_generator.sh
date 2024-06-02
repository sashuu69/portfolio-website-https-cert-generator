#!/bin/bash

echo "[INFO] -------------------------"
echo "[INFO] SSL Certificate Generator"
echo "[INFO] -------------------------"
echo ""

echo "[INFO] Installing Lego..." 
INSTALLER_URL=$(curl -L https://api.github.com/repos/xenolf/lego/releases/latest --no-progress-meter | grep browser_download_url | grep linux_amd64 | cut -d '"' -f 4)
INSTALLER_PATH=/tmp/$(basename "$INSTALLER_URL")

curl -L -o $INSTALLER_PATH $INSTALLER_URL --no-progress-meter
tar xzf $INSTALLER_PATH -C /tmp

echo "[INFO] Generating certificates..."
/tmp/lego --tls --email="$EMAIL_ADDRESS" --domains="$DOMAIN" --domains="www.$DOMAIN" --path="/tmp/certs" --accept-tos run

echo "[INFO] Compressing /tmp/certs..."
tar -czf /tmp/certs.tar.gz /tmp/certs