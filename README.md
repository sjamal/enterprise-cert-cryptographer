# Enterprise Certificate Cryptographer & Format Engine

Managing TLS certificates in a complex enterprise infrastructure requires support for highly fragmented target keystores. This project provides certificate packaging, transformation, workspace cleanup routines, and distribution scripts designed to bridge automated certificate authorities with diverse enterprise runtime engines. 

## Operational Complexity Abstracted
Enterprise architectures require distinct cryptographic formats across various platforms. This application serves as a transformation broker, packaging raw certificates into runtime-specific storage formats to eliminate manual configuration errors.

┌───────────────────────┐
│ Standard X.509 Assets │
└───────────┬───────────┘
│ (Automated Transformation)
▼
┌────────────────────────┼────────────────────────┐
▼                        ▼                        ▼
┌─────────────────┐      ┌─────────────────┐      ┌─────────────────┐
│ Java Runtimes   │      │ Edge Systems    │      │ Gateway Proxies │
├─────────────────┤      ├─────────────────┤      ├─────────────────┤
│ WebSphere, DB2  │      │ Caddy, Apache2  │      │ DataPower MPGW  │
│ JKS / KDB Files │      │ PEM / Key Pairs │      │ Crypto ValCreds │
└─────────────────┘      └─────────────────┘      └─────────────────┘

## System Transformations & Verification Modules
- **Java Platform Ingestion Engine (`scripts/format_converter.sh`):** Packages assets into Java Keystores (`.jks`) and PKCS12 (`.p12`) packages required by processing software like IBM WebSphere Liberty, OpenLiberty, and DB2 Global Security Kit (`gsk KDB`).
- **Web Servers / Proxies:** Structured raw `.pem` and private key pairs for Caddy Proxy and Apache2.
- **Network Ingress:** Base64-encoded formatting frameworks ready for import into IBM DataPower Multi-Protocol Gateways (MPGW), Front Side Handlers (FSH), and Validation Credentials (ValCreds).
- **Edge Compute Layouts (`scripts/generate_keypairs.sh`):** Standardizes internal development execution requirements for standard system protocols (RSA, ECDSA, Ed25519).
- **Automated Artifact Testing (`scripts/test_keystore_generation.sh`):** Automated verification tool for certificate generation pipelines. Builds test structures, transforms formats, and validates Java Keystores (JKS) and PKCS12 packages to catch packaging breaks.
- **Workspace Cleanup Agent (`scripts/purge_pipeline_artifacts.sh`):** Cleans up temporary testing assets, mock keys, and validation directories on build hosts after pipeline tasks finish to maintain a clean security footprint.
- **docs/DEPLOYMENT_RUNBOOK.md:** Operational guide detailing format conversions, storage rules, and verification checks.

## Architectural Component Layout
- **scripts/generate_keypairs.sh:** Automates certificate generation tasks across corporate encryption formats (RSA, ECDSA, Ed25519).
- **scripts/format_converter.sh:** Handles binary package transformations for web proxies and Java targets.
- **scripts/test_keystore_generation.sh:** Independent script validating artifact processing integrity within testing loops.
- **docs/DEPLOYMENT_RUNBOOK.md:** Operational guide detailing format conversions, storage rules, and verification checks.

## Automated Verification Workflow
To run format transformation validations locally or within build loops, execute the verification script below:

```bash
# Execute local artifact packaging test checking validation logic
bash scripts/test_keystore_generation.sh
```