#!/bin/bash
set -euo pipefail

# 1. Define global system paths for image composition
APP_NAME="ABDownloadManager"
SYS_APP_PATH="/usr/local/lib/$APP_NAME"
SYS_BIN_PATH="/usr/local/bin"
SYS_APP_ENTRY="/usr/local/share/applications"

# 2. Determine system architecture
case "$(uname -m)" in
    x86_64 | amd64) ARCH="x64" ;;
    aarch64 | arm64) ARCH="arm64" ;;
    *) echo "Unsupported architecture"; exit 1 ;;
esac

# 3. Target URLs
RELEASE_URL="https://api.github.com/repos/amir1376/ab-download-manager/releases/latest"
GITHUB_RELEASE_DOWNLOAD="https://github.com/amir1376/ab-download-manager/releases/download"

# 4. Resolve the latest version string using the upstream command format
echo "Fetching latest AB Download Manager release version metadata..."
LATEST_VERSION=$(curl -fSs --connect-timeout 10 "${RELEASE_URL}" | grep '"tag_name":' | sed -E 's/.*"tag_name": ?"([^"]+)".*/\1/')

if [ -z "$LATEST_VERSION" ]; then
    echo "Error: Failed to fetch tag version from GitHub API."
    exit 1
fi

ASSET_NAME="${APP_NAME}_${LATEST_VERSION:1}_linux_${ARCH}.tar.gz"
DOWNLOAD_URL="$GITHUB_RELEASE_DOWNLOAD/${LATEST_VERSION}/$ASSET_NAME"
TARBALL_TARGET="/tmp/$ASSET_NAME"

# 5. Download the release tarball
echo "Downloading payload from: $DOWNLOAD_URL"
curl -fSL --connect-timeout 10 --retry 3 "$DOWNLOAD_URL" -o "$TARBALL_TARGET"

# 6. Extract into a temporary staging folder first to check its layout
echo "Extracting archive..."
TMP_EXTRACT=$(mktemp -d)
tar -xzf "$TARBALL_TARGET" -C "$TMP_EXTRACT"
rm -f "$TARBALL_TARGET"

# Clear any system path leftovers from previous container tasks
rm -rf "$SYS_APP_PATH"
mkdir -p "$(dirname "$SYS_APP_PATH")" "$SYS_BIN_PATH" "$SYS_APP_ENTRY"

# Check if the developer included an inner ABDownloadManager folder
if [ -d "$TMP_EXTRACT/$APP_NAME" ]; then
    echo "Detected nested $APP_NAME directory. Flattening layout structure..."
    mv "$TMP_EXTRACT/$APP_NAME" "$SYS_APP_PATH"
    rm -rf "$TMP_EXTRACT"
else
    echo "Flat structure detected. Moving to target application path..."
    mv "$TMP_EXTRACT" "$SYS_APP_PATH"
fi

# 7. Dynamically locate the bundled app icon inside the final layout path
# This handles variations like $SYS_APP_PATH/lib/icon.png vs $SYS_APP_PATH/lib/ABDownloadManager/icon.png
RESOLVED_ICON=$(find "$SYS_APP_PATH" -type f -name "icon.png" | head -n 1)

# Fallback string if find yields absolutely nothing
if [ -z "$RESOLVED_ICON" ]; then
    RESOLVED_ICON="$SYS_APP_PATH/lib/icon.png"
fi

# 8. Create execution link and global desktop entry shortcut
ln -sf "$SYS_APP_PATH/bin/$APP_NAME" "$SYS_BIN_PATH/$APP_NAME"

cat <<EOF > "${SYS_APP_ENTRY}/com.abdownloadmanager.desktop"
[Desktop Entry]
Name=AB Download Manager
Comment=Manage and organize your download files better than before
GenericName=Downloader
Categories=Utility;Network;
Exec="$SYS_BIN_PATH/$APP_NAME"
Icon=$RESOLVED_ICON
Terminal=false
Type=Application
StartupWMClass=com-abdownloadmanager-desktop-AppKt
EOF

echo "AB Download Manager has been successfully built into the system image paths with dynamic path fallback mappings intact."
