#!/bin/bash
set -euo pipefail

LATEST_URL="https://github.com/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/latest/download/uad-ng-linux"
TARGET="/usr/bin/uad"

if curl -L --retry 3 --retry-delay 2 "$LATEST_URL" -o "$TARGET"; then
    chmod +x "$TARGET"
    echo "Installation complete."
else
    echo "Error: Failed to fetch the binary payload from GitHub."
    exit 1
fi
