# vim: set ft=make :

# Setup and manage scrcpy as a virtual camera
[group("Android")]
scrcpy-cam ACTION="":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    
    ENV_FILE="$HOME/.config/environment.d/99-scrcpy-camera.conf"

    if [ -f /etc/environment ]; then
        set -a
        source <(cat /etc/environment | sed 's/^/export /') > /dev/null 2>&1
        set +a
    fi

    if [ -f "$ENV_FILE" ]; then
        set -a
        source <(sed 's/^/export /' "$ENV_FILE") > /dev/null 2>&1
        set +a
    fi

    if [[ $(id -u) -eq 0 ]]; then
      echo "Please do not run this command as root"
      exit 1
    fi

    OPTION={{ ACTION }}
    
    if [[ "$OPTION" == "" || "$OPTION" == "run" ]]; then
        if pgrep -x "scrcpy" > /dev/null; then
            OPTION="stop"
        else
            OPTION="start"
        fi
    fi

    if [[ "$OPTION" == "help" ]]; then
      echo "Usage: ujust scrcpy-cam <option>"
      echo "  Use 'run' to Toggle Camera"
      echo "  Use 'edit' to Edit Env"
      exit 0
    fi

    if [[ "$OPTION" == "start" ]]; then
        SCRCPY_CAMERA_LABEL="${SCRCPY_CAMERA_LABEL:-Android Virtual Camera}"
        SCRCPY_CAMERA_ID="${SCRCPY_CAMERA_ID:-1}"
        SCRCPY_CAMERA_SIZE="${SCRCPY_CAMERA_SIZE:-1920x1080}"

        echo "${yellow}Refreshing v4l2loopback driver...${n}"
        sudo modprobe -r v4l2loopback 2>/dev/null || true
        sudo modprobe v4l2loopback exclusive_caps=1 card_label="$SCRCPY_CAMERA_LABEL"
        
        sleep 0.2
        
        SCRCPY_V4L2_SINK=$(v4l2-ctl --list-devices | grep -A 1 "$SCRCPY_CAMERA_LABEL" | grep -o "/dev/video[0-9]\+" | head -n 1)

        if [ -z "$SCRCPY_V4L2_SINK" ]; then
            echo "${red}Error: Failed to map device with label \"$SCRCPY_CAMERA_LABEL\"${n}"
        else
            echo "${green}Starting scrcpy on $SCRCPY_V4L2_SINK...${n}"
            nohup scrcpy --video-source=camera \
                   --camera-id=$SCRCPY_CAMERA_ID \
                   --camera-size=$SCRCPY_CAMERA_SIZE \
                   --v4l2-sink="$SCRCPY_V4L2_SINK" \
                   --no-audio --no-video-playback --no-window > /dev/null 2>&1 &
            disown
        fi

    elif [[ "$OPTION" == "stop" ]]; then
        echo "${red}Killing scrcpy...${n}"
        pkill -x scrcpy > /dev/null 2>&1 || true
        
        sleep 1
        echo "${red}Unloading v4l2loopback...${n}"
        sudo modprobe -r v4l2loopback 2>/dev/null || echo "${yellow}Driver busy or already unloaded.${n}"

    elif [[ "${OPTION,,}" =~ (^edit[[:space:]]environment[[:space:]]variables|edit) ]]; then
        if [ ! -f "$ENV_FILE" ]; then
            echo "${blue}Creating new camera profile configuration file...${n}"
            mkdir -p "$(dirname "$ENV_FILE")"
            cat << 'EOF' > "$ENV_FILE"
SCRCPY_CAMERA_ID=1
SCRCPY_CAMERA_SIZE=1920x1080
SCRCPY_CAMERA_LABEL="Android Virtual Camera"
SCRCPY_V4L2_SINK=/dev/video0
EOF
        fi
        
        nano "$ENV_FILE"
        echo "${blue}Changes applied. Note: You may need to log out and back in for systemd to refresh these values globally.${n}"
        exec ujust scrcpy-cam
    fi
