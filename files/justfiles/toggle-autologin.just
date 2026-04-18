# Toggle autologin for COSMIC
toggle-autologin:
    #!/usr/bin/env bash
    CONF="/etc/greetd/cosmic-greeter.toml"
    USERNAME=$(whoami)
    
    if grep -q "\[initial_session\]" "$CONF"; then
        echo "Disabling autologin..."
        # Removes the [initial_session] block and the two lines following it
        sudo sed -i '/\[initial_session\]/,+2d' "$CONF"
    else
        echo "Enabling autologin for $USERNAME..."
        sudo bash -c "cat <<EOF >> $CONF

[initial_session]
command = \"cosmic-session\"
user = \"$USERNAME\"
EOF"
    fi
    echo "Done! Autologin status has been flipped."
