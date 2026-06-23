# vim: set ft=make :

# Setup and manage scrcpy as a virtual camera
[group("Android")]
scrcpy-cam ACTION="":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    
    if [ -f "$HOME/.config/environment.d/99-scrcpy-camera.conf" ]; then
        set -a
        source <(cat "$HOME/.config/environment.d/99-scrcpy-camera.conf" | sed 's/^/export /') > /dev/null 2>&1
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
        mkdir -p "$HOME/.config/environment.d"
        nano "$HOME/.config/environment.d/99-scrcpy-camera.conf"
        echo "${blue}Changes applied.${n}"
        exec ujust scrcpy-cam
    fi
