# vim: set ft=make :
# Toggle UMIP
[group("System")]
toggle-umip:
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh

    if rpm-ostree kargs | grep -q "clearcpuid=umip"; then
        echo "${green}Enabling UMIP...${n}"
        sudo rpm-ostree kargs --delete-if-present=clearcpuid=umip
    else
        echo "${red}Disabling UMIP...${n}"
        sudo rpm-ostree kargs --append-if-missing=clearcpuid=umip
    fi
