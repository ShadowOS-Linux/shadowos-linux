if [[ $- == *i* ]]; then
    fastfetch

    C="/tmp/orthocal.json"
    D=$(date +%Y-%m-%d)

    if [ -f "$C" ] && [ "$(jq -r .date "$C" 2>/dev/null)" != "$D" ]; then
        rm -f "$C"
    fi

    if [ ! -f "$C" ]; then
        curl -s --max-time 2 "https://orthocal.info/api/gregorian/$(date +%Y/%m/%d/)" > "$C.tmp" 2>/dev/null
        if [ -s "$C.tmp" ] && jq . "$C.tmp" >/dev/null 2>&1; then
            mv "$C.tmp" "$C"
        else
            rm -f "$C.tmp"
        fi
    fi

    cd ~
    clear
    fastfetch
fi
