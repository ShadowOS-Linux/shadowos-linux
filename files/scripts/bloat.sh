#!/usr/bin/env bash
set -euo pipefail

if [ -f "/usr/share/applications/com.gerbilsoft.rom-properties.rp-config.desktop" ]; then
    rm /usr/share/applications/com.gerbilsoft.rom-properties.rp-config.desktop
fi

# documentation
if [ -f "/usr/share/applications/bazzite-documentation.desktop" ]; then
    rm /usr/share/applications/bazzite-documentation.desktop
fi

if [ -f "/usr/share/applications/discourse.desktop" ]; then
    rm /usr/share/applications/discourse.desktop
fi

# steam startup
if [ -f "/etc/xdg/autostart/steam.desktop" ]; then
    rm /etc/xdg/autostart/steam.desktop
fi

if [ -f "/usr/share/applications/steam-autostart.desktop" ]; then
    rm /usr/share/applications/steam-autostart.desktop
fi

if [ -f "/etc/skel/.config/autostart/steam.desktop" ]; then
    rm /etc/skel/.config/autostart/steam.desktop
fi
