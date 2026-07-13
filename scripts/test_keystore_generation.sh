#!/bin/bash
# ==============================================================================
# Script Name: test_keystore_generation.sh
# Description: Automated verification tool for certificate generation pipelines.
#              Builds test structures, transforms formats, and validates Java 
#              Keystores (JKS) and PKCS12 packages to catch packaging breaks.
# ==============================================================================

set -euo pipefail

# Define temporary execution directories and file markers
TEST_DIR="./tmp_validation_run"
MOCK_CERT_NAME="sec-t1-test-certificate"
export KEY_PASS="TestValidationSecret123!"

echo "[INFO] Commencing automated artifact validation engine testing..."

# Ensure target testing directory structures are clear
mkdir -p "${TEST_DIR}"
cd "${TEST_DIR}"

# 1. Generate local testing keypair and standard self-signed certificate assets
echo "[INFO] Generating test cryptographic keypairs and certificate requests..."
openssl req -x509 -nodes -days 1 -newkey rsa:2048 \
    -keyout "${MOCK_CERT_NAME}.key" \
    -out "${MOCK_CERT_NAME}.crt" \
    -subj "/C=CA/O=Enterprise-Testing/OU=Validation/CN=pipeline-test.internal" \
    2>/dev/null

# 2. Package assets into PKCS12 configuration layers
echo "[INFO] Packaging assets into PKCS12 configuration layers..."
openssl pkcs12 -export \
    -in "${MOCK_CERT_NAME}.crt" \
    -inkey "${MOCK_CERT_NAME}.key" \
    -out "${MOCK_CERT_NAME}.p12" \
    -name "test_alias" \
    -passout "pass:${KEY_PASS}"

# 3. Transform structures into Java Keystore configurations
echo "[INFO] Transforming structures into Java Keystore (JKS) files..."
keytool -importkeystore \
    -srckeystore "${MOCK_CERT_NAME}.p12" \
    -srcstoretype PKCS12 \
    -srcstorepass "${KEY_PASS}" \
    -destkeystore "${MOCK_CERT_NAME}.jks" \
    -deststoretype JKS \
    -deststorepass "${KEY_PASS}" \
    -noprompt \
    2>/dev/null

# 4. Execute validation checking parameters on generated binary keystores
echo "[INFO] Inspecting generated binary keystore integrity..."
if keytool -list -keystore "${MOCK_CERT_NAME}.jks" -storepass "${KEY_PASS}" | grep -q "test_alias"; then
    echo "[SUCCESS] Java Keystore integration testing passed. Structural formats valid."
    cd ..
    rm -rf "${TEST_DIR}"
    exit 0
else
    echo "[CRITICAL] Keystore packaging anomaly detected. Validation checks failed." >&2
    cd ..
    rm -rf "${TEST_DIR}"
    exit 1
fi
