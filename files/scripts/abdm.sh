#!/bin/bash
set -euo pipefail

# 1. Define persistent system paths for BlueBuild image composition
APP_NAME="ABDownloadManager"
SYS_APP_PATH="/var/usrlocal/lib/$APP_NAME"
SYS_BIN_PATH="/var/usrlocal/bin"
SYS_APP_ENTRY="/var/usrlocal/share/applications"

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

# 6. Extract into a temporary staging folder cleanly
echo "Extracting archive..."
TMP_EXTRACT=$(mktemp -d)
tar -xzf "$TARBALL_TARGET" -C "$TMP_EXTRACT"
rm -f "$TARBALL_TARGET"

# Clear any previous build leftovers in the persistent path layout
rm -rf "$SYS_APP_PATH"
mkdir -p "$SYS_APP_PATH" "$SYS_BIN_PATH" "$SYS_APP_ENTRY"

# Extract internal files properly without nested directory clashing
if [ -d "$TMP_EXTRACT/$APP_NAME" ]; then
    echo "Moving contents of nested $APP_NAME directory to target persistent path..."
    cp -r "$TMP_EXTRACT/$APP_NAME/." "$SYS_APP_PATH/"
    rm -rf "$TMP_EXTRACT"
else
    echo "Flat structure detected. Moving contents to target persistent path..."
    cp -r "$TMP_EXTRACT/." "$SYS_APP_PATH/"
    rm -rf "$TMP_EXTRACT"
fi

# 7. Dynamically locate the bundled app icon inside the layout path
# This looks for the proper app icon asset (like ABDownloadManager.png or icon.png)
RESOLVED_ICON=$(find "$SYS_APP_PATH" -type f \( -name "ABDownloadManager.png" -o -name "icon.png" \) | head -n 1)

if [ -z "$RESOLVED_ICON" ]; then
    RESOLVED_ICON="$SYS_APP_PATH/lib/ABDownloadManager.png"
fi

# 8. Create execution link and global desktop entry shortcut inside /var/usrlocal
ln -sf "$SYS_APP_PATH/bin/$APP_NAME" "$SYS_BIN_PATH/$APP_NAME"

cat <<EOF > "${SYS_APP_ENTRY}/com.abdownloadmanager.desktop"
[Desktop Entry]
Name=AB Download Manager
Comment=Manage and organize your download files better than before
GenericName=Downloader
Categories=Utility;Network;
Exec="/usr/local/bin/$APP_NAME"
Icon=$RESOLVED_ICON
Terminal=false
Type=Application
StartupWMClass=com-abdownloadmanager-desktop-AppKt
EOF

echo "AB Download Manager has been successfully installed."
