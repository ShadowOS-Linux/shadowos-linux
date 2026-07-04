#!/usr/bin/env bash

set -euo pipefail

if [ -f "/usr/share/applications/bazzite-steam-bpm.desktop" ]; then
    rm /usr/share/applications/bazzite-steam-bpm.desktop
fi

if [ -d "/usr/share/gnome-shell/extensions/add-to-steam@pupper.space" ]; then
    rm -rf /usr/share/gnome-shell/extensions/add-to-steam@pupper.space
fi
