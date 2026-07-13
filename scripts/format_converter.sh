#!/bin/bash
# file: scripts/format_converter.sh
set -euo pipefail

# Enterprise Certificate Converter Utility
# Translates standard corporate certificates into application-specific formats (IBM, Java, Caddy)

CERT_NAME=$1
TARGET_DIR="./dist/${CERT_NAME}"
mkdir -p "${TARGET_DIR}"

echo "[INFO] Formatting assets for Certificate: ${CERT_NAME}"

# 1. Generate standard PKCS12 bundle from separate key and cert files (Used by Caddy/Datapower)
openssl pkcs12 -export \
    -in "${CERT_NAME}.crt" \
    -inkey "${CERT_NAME}.key" \
    -out "${TARGET_DIR}/${CERT_NAME}.p12" \
    -name "${CERT_NAME}_alias" \
    -passout pass:ChangeMeSecurely123!

# 2. Convert PKCS12 into a Java Keystore (JKS) required for IBM WebSphere / OpenLiberty
keytool -importkeystore \
    -srckeystore "${TARGET_DIR}/${CERT_NAME}.p12" \
    -srcstoretype PKCS12 \
    -srcstorepass ChangeMeSecurely123! \
    -destkeystore "${TARGET_DIR}/${CERT_NAME}_key.jks" \
    -deststoretype JKS \
    -deststorepass ChangeMeSecurely123! \
    -noprompt

echo "[SUCCESS] Formatted distributions ready for deployment in JKS and PKCS12 architectures."

