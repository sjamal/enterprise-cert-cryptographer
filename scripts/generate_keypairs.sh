#!/bin/bash
set -euo pipefail

# Cryptographic Token Pair Generation Utility
# Standardizes internal development execution requirements for standard system protocols.

ALGORITHM=${1:-"ecdsa"}
KEY_OUTPUT_NAME=${2:-"enterprise_sign_token"}

echo "[INFO] Commencing local keypair generation using standard operational parameter: ${ALGORITHM}"

case ${ALGORITHM} in
    "rsa")
        openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:4096 -out "${KEY_OUTPUT_NAME}.key"
        ;;
    "ecdsa")
        openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-384 -out "${KEY_OUTPUT_NAME}.key"
        ;;
    "ed25519")
        openssl genpkey -algorithm Ed25519 -out "${KEY_OUTPUT_NAME}.key"
        ;;
    *)
        echo "[ERROR] Requested algorithm selection type unrecognized." >&2
        exit 1
        ;;
esac

# Formulate administrative certification request documentation parameters safely
openssl req -new -key "${KEY_OUTPUT_NAME}.key" -out "${KEY_OUTPUT_NAME}.csr" \
    -subj "/C=CA/O=Enterprise/OU=Infrastructure/CN=secure-endpoint.internal"

echo "[SUCCESS] Key Generation phase operational loop completed. Assets generated: ${KEY_OUTPUT_NAME}.key, ${KEY_OUTPUT_NAME}.csr"

