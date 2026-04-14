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
sed -i 's/"keys": "light_blue"/"keys": "red"/g' "$TARGET_FILE"
sed -i 's/"user": "light_blue"/"user": "red"/g' "$TARGET_FILE"
sed -i '/"modules": \[/a \
        { "type": "title", "key": " 󱓚", "keyColor": "red" }, \
        { "type": "command", "key": " 󰸗", "text": "date '\''+%A %d, %B %Y'\''" }, \
        { "type": "command", "key": " 󱈔", "text": "curl -s https://orthocal.info/api/ > /tmp/ortho.json && jq -r .summary_title /tmp/ortho.json" }, \
        { "type": "command", "key": " 󰦕", "text": "jq -r .feast_level_description /tmp/ortho.json" }, \
        { "type": "command", "key": " 󱗗", "text": "jq -r .fast_level_desc /tmp/ortho.json" }, \
        { "type": "command", "key": " 󱠗", "text": "jq -r .fast_exception_desc /tmp/ortho.json" }, \
        { "type": "command", "key": " 󰚚", "text": "jq -r '\''.saints[0:2] | join(\", \")'\'' /tmp/ortho.json" }, \
        { "type": "command", "key": " 󰗊", "text": "jq -r '\''.readings[0].display'\'' /tmp/ortho.json" }, \
        "break",' "$TARGET_FILE"

echo -e "\ncd ~\nclear\nfastfetch" >> "/etc/skel/.bashrc"
