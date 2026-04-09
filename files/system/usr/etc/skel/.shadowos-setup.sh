#!/bin/bash

# 1. Variables
LIBREWOLF_PATH="$HOME/.var/app/io.gitlab.librewolf-community/.librewolf"
BACKUP_CSS="$HOME/.shadowos-backup-userChrome.css"
CSS_URL="https://raw.githubusercontent.com/MrOtherGuy/firefox-csshacks/refs/heads/master/chrome/compact_extensions_panel.css"

# 2. Open LibreWolf to force profile creation
flatpak run io.gitlab.librewolf-community "https://github.com/ShadowElixir/PostInstall#recommendations" &
sleep 2

# 3. Identify the profile folder (usually the one containing prefs.js)
PROFILE_DIR=$(find "$LIBREWOLF_PATH" -maxdepth 2 -name "prefs.js" -printf '%h\n' | head -n 1)

if [ -n "$PROFILE_DIR" ]; then
    mkdir -p "$PROFILE_DIR/chrome"
    
    # 4. Try to download the CSS
    if curl -s --head --request GET "$CSS_URL" | grep "200 OK" > /dev/null; then
        curl -L "$CSS_URL" -o "$PROFILE_DIR/chrome/userChrome.css"
    # 5. Fallback to the local backup
    elif [ -f "$BACKUP_CSS" ]; then
        cp "$BACKUP_CSS" "$PROFILE_DIR/chrome/userChrome.css"
    fi
fi

# fastfetch
echo '' >> $HOME/.bashrc
echo 'clear' >> $HOME/.bashrc
echo 'echo ""' >> $HOME/.bashrc
echo 'fastfetch' >> $HOME/.bashrc
echo 'echo ""' >> $HOME/.bashrc

# 7. CLEANUP (The Self-Destruct Sequence)
# Delete the autostart trigger
rm -f "$HOME/.config/autostart/shadowos-setup.desktop"

# Delete the backup CSS file
rm -f "$BACKUP_CSS"

# Delete this script itself
rm -- "$0"
