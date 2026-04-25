#!/usr/bin/env bash
set -euo pipefail

APPS_TO_HIDE=(
    "qt5ct"
    "qt6ct"
    "bazzite-documentation"
    "discourse"
    "waydroid-container-restart"
    "com.gerbilsoft.rom-properties.rp-config"
    "org.gnome.Yelp"
)

for app in "${APPS_TO_HIDE[@]}"; do
    FILE="/usr/share/applications/${app}.desktop"
    
    if [ -f "$FILE" ]; then
        if ! grep -q "NoDisplay=true" "$FILE"; then
            echo "Hiding: $app"
            sed -i '/\[Desktop Entry\]/a NoDisplay=true' "$FILE"
        else
            echo "Already hidden: $app"
        fi
    else
        echo "Skipping: $app (not installed)"
    fi
done

if [ -f "/etc/skel/.config/autostart/steam.desktop" ]; then
    echo "Removing Steam autostart from skel..."
    rm -f "/etc/skel/.config/autostart/steam.desktop"
fi
