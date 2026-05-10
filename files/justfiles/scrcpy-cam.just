# vim: set ft=make :

# Setup and manage scrcpy as a virtual camera
[group("Android")]
scrcpy-cam ACTION="":
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh
    
    if [[ $(id -u) -eq 0 ]]; then
      echo "Please do not run this command as root"
      exit 1
    fi

    OPTION={{ ACTION }}
    if [ "$OPTION" == "help" ]; then
      echo "Usage: ujust scrcpy-cam <option>"
      echo "  <option>: Specify the quick option to skip the prompt"
      echo "  Use 'start-driver' to Load V4L2 Module"
      echo "  Use 'run' to Start Camera Stream"
      echo "  Use 'stop' to End Camera Stream"
      echo "  Use 'remove-driver' to Unload V4L2 Module"
      exit 0
    elif [ "$OPTION" == "" ]; then
      echo "${bold}Android Camera Setup (scrcpy)${normal}"
      OPTION=$(Choose \
        "Load V4L2 Module" \
        "Start Camera Stream" \
        "End Camera Stream" \
        "Unload V4L2 Module" \
      )
    fi

    if [[ "${OPTION,,}" =~ (^load[[:space:]]v4l2[[:space:]]module|start-driver) ]]; then
        echo "${green}Loading v4l2loopback...${n}"
        sudo modprobe v4l2loopback exclusive_caps=1 card_label="$SCRCPY_CAMERA_LABEL"
    
    elif [[ "${OPTION,,}" =~ (^start[[:space:]]camera[[:space:]]stream|run) ]]; then
        echo "${green}Starting scrcpy...${n}"
        nohup scrcpy --video-source=camera \
               --camera-id=$SCRCPY_CAMERA_ID \
               --camera-size=$SCRCPY_CAMERA_SIZE \
               --v4l2-sink=$SCRCPY_V4L2_SINK \
               --no-audio --no-video-playback --no-window > /dev/null 2>&1 &
        disown

    elif [[ "${OPTION,,}" =~ (^end[[:space:]]camera[[:space:]]stream|stop) ]]; then
        echo "${red}Killing scrcpy...${n}"
        pkill -x scrcpy > /dev/null 2>&1 || true

    elif [[ "${OPTION,,}" =~ (^unload[[:space:]]v4l2[[:space:]]module|remove-driver) ]]; then
        echo "${red}Removing v4l2loopback...${n}"
        sudo modprobe -r v4l2loopback
    fi
