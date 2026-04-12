#!/bin/bash
set -oue pipefail

TARGET_FILE="/usr/share/ublue-os/bazzite/fastfetch.jsonc"
mkdir -p $(dirname "$TARGET_FILE")
curl -Lo "$TARGET_FILE" https://raw.githubusercontent.com/ublue-os/bazzite/refs/heads/main/system_files/desktop/shared/usr/share/ublue-os/bazzite/fastfetch.jsonc
sed -i 's|"text": "/usr/libexec/bazzite-fetch-image"|"format": "{variant-id}"|g' "$TARGET_FILE"
