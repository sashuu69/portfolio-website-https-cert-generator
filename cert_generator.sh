#!/bin/bash

: "${EMAIL_ADDRESS? not set}"
: "${DOMAIN? no set}"
: "${CERT_PATH? no set}"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case $ARCH in
    x86_64)
        ARCH="amd64"
        ;;
    aarch64)
        ARCH="arm64"
        ;;
    armv7l)
        ARCH="arm"
        ;;
    i386)
        ARCH="386"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac
TARGET="${OS}_${ARCH}"
INSTALLER_URL=$(curl -L https://api.github.com/repos/xenolf/lego/releases/latest --no-progress-meter | grep browser_download_url | grep ${TARGET} | cut -d '"' -f 4)
INSTALLER_PATH=/tmp/$(basename "$INSTALLER_URL")

echo "[INFO] -------------------------"
echo "[INFO] SSL Certificate Generator"
echo "[INFO] -------------------------"
echo ""

echo "[INFO] Installing Lego..." 

curl -L -o ${INSTALLER_PATH} ${INSTALLER_URL} --no-progress-meter
tar xzf ${INSTALLER_PATH} -C /tmp

echo "[INFO] Generating certificates..."
/tmp/lego --tls --email="${EMAIL_ADDRESS}" --domains="${DOMAIN}" --domains="www.${DOMAIN}" --path="${CERT_PATH}" --accept-tos run

echo "[INFO] Compressing generated certificates..."
tar -czf "${CERT_PATH}.tar.gz" ${CERT_PATH}

echo "[INFO] Certificates generated..."
