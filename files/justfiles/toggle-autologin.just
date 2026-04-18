# Toggle autologin for COSMIC
toggle-autologin:
    #!/usr/bin/env bash
    set -euo pipefail
    CONF='/etc/greetd/cosmic-greeter.toml'
    USERNAME=$(whoami)

    if grep -q 'initial_session' "$CONF"; then
        echo 'Disabling autologin...'
        sudo sed -i '/initial_session/,+3d' "$CONF"
    else
        echo "Enabling autologin for $USERNAME..."
        sudo bash -c "echo -e '\n[initial_session]\ncommand = cosmic-session\nuser = $USERNAME' >> $CONF"
    fi
    echo 'Operation complete.'
