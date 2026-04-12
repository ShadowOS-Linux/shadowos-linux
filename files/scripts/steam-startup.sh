#!/usr/bin/env bash
set -euo pipefail

if [ -f "/etc/xdg/autostart/steam.desktop" ]; then
    rm /etc/xdg/autostart/steam.desktop
fi

if [ -f "/usr/share/applications/steam-autostart.desktop" ]; then
    rm /usr/share/applications/steam-autostart.desktop
fi

if [ -f "/etc/skel/.config/autostart/steam.desktop" ]; then
    rm /etc/skel/.config/autostart/steam.desktop
fi
