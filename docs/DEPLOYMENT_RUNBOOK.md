# Runbook: Cryptographic Transformations & Storage Formatting

## 1. Context Overview
This runbook explains how to format, package, and transform raw certificate inputs into the custom keystore layouts required by enterprise application platforms, proxies, and data center security layers.

## 2. Generating Token Validation Keys
When internal development systems need new cryptographic verification tokens, run this script to generate private keys and their corresponding sign requests:

```bash
# Options: rsa (4096-bit), ecdsa (P-384 curve), ed25519
# Command Structure: bash scripts/generate_keypairs.sh <algorithm> <output_filename>
bash scripts/generate_keypairs.sh "ecdsa" "sec-prd-tor-caddyproxy"
```

## 3. Keystore Packaging Engine
To deploy standard X.509 assets to Java engines (IBM WebSphere, OpenLiberty) or proxy contexts (IBM DataPower), convert the formats using the script below:

```bash
# Convert raw PEM keypairs into PKCS12 bundles and Java Keystore configurations
# Expected Input Files: <cert_name>.crt, <cert_name>.key
bash scripts/format_converter.sh "sec-prd-tor-caddyproxy"
```

## 4. Format Verification Procedures
Confirm formatting consistency before staging assets to application target systems:

```bash
# Verify internal validity of generated Java Keystores (JKS)
keytool -list -v -keystore ./dist/sec-prd-tor-caddyproxy/sec-prd-tor-caddyproxy_key.jks -storepass ChangeMeSecurely123!

# Inspect parameters inside generated PKCS12 packages
openssl pkcs12 -info -in ./dist/sec-prd-tor-caddyproxy/sec-prd-tor-caddyproxy.p12 -passin pass:ChangeMeSecurely123! -noout
```
