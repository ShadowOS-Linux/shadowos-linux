#!/usr/bin/env bash
set -eoux pipefail

dnf install -y anaconda-live libblockdev-btrfs firefox --setopt=disable_excludes=*
sed -i '/\[Desktop Entry\]/a NoDisplay=true' /usr/share/applications/org.mozilla.firefox.desktop
