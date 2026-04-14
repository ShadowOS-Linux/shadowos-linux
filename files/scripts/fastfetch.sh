#!/bin/bash
set -oue pipefail

TARGET_FILE="/usr/share/ublue-os/bazzite/fastfetch.jsonc"
mkdir -p $(dirname "$TARGET_FILE")
curl -Lo "$TARGET_FILE" https://raw.githubusercontent.com/ublue-os/bazzite/refs/heads/main/system_files/desktop/shared/usr/share/ublue-os/bazzite/fastfetch.jsonc
sed -i 's|"type": "command"|"type": "os"|g' "$TARGET_FILE"
sed -i 's|"text": "/usr/libexec/bazzite-fetch-image"|"format": "{variant-id}"|g' "$TARGET_FILE"
sed -i 's|"1": "94"|"1": "31"|g' "$TARGET_FILE"
sed -i '/"[2-6]": "[0-9]*"/d' "$TARGET_FILE"
sed -i 's/31",/31"/g' "$TARGET_FILE"

echo -e "\ncd ~\nclear\nfastfetch" >> "/etc/skel/.bashrc"
