#!/bin/bash
# ==============================================================================
# Script Name: purge_pipeline_artifacts.sh
# Description: Cleans up temporary testing assets, mock keys, and validation 
#              directories on build hosts after pipeline tasks finish.
# ==============================================================================

set -euo pipefail

# Define the target scratch directories to be purged
TARGET_SCRATCH_ZONE="./tmp_validation_run"
LOG_ZONE="./dist/tmp"

echo "[INFO] Commencing automated post-pipeline workspace cleaning routines..."

# Safely purge temporary file systems if they exist
if [ -d "${TARGET_SCRATCH_ZONE}" ]; then
    echo "[INFO] Clearing temporary validation directory structures: ${TARGET_SCRATCH_ZONE}"
    # Delete temporary keys and certificates securely from the build host
    find "${TARGET_SCRATCH_ZONE}" -type f -exec rm -f {} +
    rm -rf "${TARGET_SCRATCH_ZONE}"
fi

if [ -d "${LOG_ZONE}" ]; then
    echo "[INFO] Cleaning temporary packaging files inside distribution zone..."
    rm -rf "${LOG_ZONE}"
fi

# Confirm the workspace matches a clean state profile
if [ ! -d "${TARGET_SCRATCH_ZONE}" ]; then
    echo "[SUCCESS] Post-pipeline asset cleanup completed. Workspace state secured."
    exit 0
else
    echo "[ERROR] Failed to entirely clear the target scratch directory paths." >&2
    exit 1
fi
