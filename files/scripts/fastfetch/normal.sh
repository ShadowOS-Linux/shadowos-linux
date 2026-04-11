#!/usr/bin/env bash

set -euo pipefail

TARGET_FILE="/usr/share/ublue-os/bazzite/fastfetch.jsonc"

if [ -f "$TARGET_FILE" ]; then
    sed -i -c 's/\("text": "\)usr\/libexec\/bazzite-fetch-image\("\)/\1shadowos-linux:latest\2/' "$TARGET_FILE"
else
    echo "Error: $TARGET_FILE not found."
    exit 1
fi

