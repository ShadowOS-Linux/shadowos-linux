#!/usr/bin/env bash
set -eoux pipefail

dnf install -y anaconda-live firefox lvm2 device-mapper libblockdev-{btrfs,lvm,crypto,mdraid,loop} util-linux --setopt=disable_excludes=*
sed -i '/\[Desktop Entry\]/a NoDisplay=true' /usr/share/applications/org.mozilla.firefox.desktop
