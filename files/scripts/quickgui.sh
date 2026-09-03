#!/bin/bash
set -euo pipefail
TARGET_DIR="/tmp/quickgui-build"
mkdir -p "$TARGET_DIR"
REDIRECT_URL=$(curl -sL -o /dev/null --connect-timeout 10 -w "%{url_effective}" "https://github.com/quickemu-project/quickgui/releases/latest")
TAG_VERSION="${REDIRECT_URL##*/}"
if [ -z "$TAG_VERSION" ] || [ "$TAG_VERSION" = "latest" ]; then
    echo "Error: Network timeout or unable to resolve current release tag metadata."
    exit 1
fi
DOWNLOAD_URL="https://github.com/quickemu-project/quickgui/releases/download/${TAG_VERSION}/quickgui-${TAG_VERSION}+1-linux.rpm"
OUTPUT_FILE="${TARGET_DIR}/quickgui-latest.rpm"
if curl -fL --connect-timeout 10 --retry 3 --retry-delay 2 "$DOWNLOAD_URL" -o "$OUTPUT_FILE"; then
    dnf install -y "$OUTPUT_FILE"
    rm -rf "$TARGET_DIR"
else
    echo "Error: Failed to fetch the specified RPM binary package from GitHub storage endpoints."
    rm -rf "$TARGET_DIR"
    exit 1
fi
