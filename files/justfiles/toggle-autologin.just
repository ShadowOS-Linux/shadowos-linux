# vim: set ft=make :

# Toggle autologin
toggle-autologin:
    #!/usr/bin/env bash
    set -euo pipefail
    USERNAME=$(whoami)

    if systemctl is-active --quiet cosmic-greeter; then
        CONF='/etc/greetd/cosmic-greeter.toml'

        if grep -q 'initial_session' "$CONF"; then
            echo 'Disabling COSMIC autologin...'
            sudo sed -i '/initial_session/,+3d' "$CONF"
            sudo sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$CONF"
        else
            echo "Enabling COSMIC autologin for $USERNAME..."
            sudo sed -i -e :a -e '/^\n*$/{$d;N;ba' -e '}' "$CONF"
            sudo bash -c "echo -e '\n[initial_session]\ncommand = cosmic-session\nuser = $USERNAME' >> $CONF"
        fi

    elif systemctl is-active --quiet lightdm; then
        CONF='/etc/lightdm/lightdm.conf'

        if grep -q '^autologin-user=' "$CONF"; then
            echo 'Disabling LightDM autologin...'
            sudo sed -i 's/^autologin-user=.*/#autologin-user=/' "$CONF"
            sudo sed -i 's/^autologin-user-timeout=.*/#autologin-user-timeout=0/' "$CONF"
        else
            echo "Enabling LightDM autologin for $USERNAME..."
            if grep -q '^#autologin-user=' "$CONF"; then
                sudo sed -i "s/^#autologin-user=.*/autologin-user=$USERNAME/" "$CONF"
            else
                sudo bash -c "echo 'autologin-user=$USERNAME' >> $CONF"
            fi

            if grep -q '^#autologin-user-timeout=' "$CONF"; then
                sudo sed -i 's/^#autologin-user-timeout=.*/autologin-user-timeout=0/' "$CONF"
            else
                sudo bash -c "echo 'autologin-user-timeout=0' >> $CONF"
            fi
        fi

    else
        echo "Error: Neither cosmic-greeter nor lightdm appears to be actively running."
        exit 1
    fi

    echo 'Operation complete.'
