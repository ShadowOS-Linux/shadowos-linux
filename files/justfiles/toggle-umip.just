# vim: set ft=make :
# Toggle UMIP
[group("System")]
toggle-umip:
    #!/usr/bin/bash
    source /usr/lib/ujust/ujust.sh

    if rpm-ostree kargs | grep -q "clearcpuid=umip"; then
        echo "${red}Removing clearcpuid=umip...${n}"
        sudo rpm-ostree kargs --delete-if-present=clearcpuid=umip
    else
        echo "${green}Adding clearcpuid=umip...${n}"
        sudo rpm-ostree kargs --append-if-missing=clearcpuid=umip
    fi
