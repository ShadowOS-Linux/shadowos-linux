#!/bin/bash
set -euo pipefail

LATEST_URL=$(curl -s https://api.github.com/repos/Universal-Debloater-Alliance/universal-android-debloater-next-generation/releases/latest \
| grep "browser_download_url" \
| grep -w "uad-ng-linux" \
| head -n 1 \
| cut -d '"' -f 4)

TARGET="/usr/bin/uad"

if [ -n "$LATEST_URL" ]; then
    echo "Downloading UAD: $LATEST_URL"
    curl -L "$LATEST_URL" -o "$TARGET"
    
    chmod +x "$TARGET"
    echo "Installation complete."
else
    echo "Error: Could not isolate the specific Linux binary URL."
    exit 1
fi
