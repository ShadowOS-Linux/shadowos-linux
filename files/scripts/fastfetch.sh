#!/bin/bash
set -oue pipefail

cat << 'EOF' >> /etc/skel/.bashrc

C=/tmp/ortho.json
D=$(date +%Y-%m-%d)
if [ ! -f $C ] || [ "$(jq -r .date $C 2>/dev/null)" != "$D" ]; then
    curl -s --max-time 3 "https://orthocal.info/api/gregorian/$(date +%Y/%m/%d/)" > $C
fi

cd ~
clear
fastfetch
EOF
