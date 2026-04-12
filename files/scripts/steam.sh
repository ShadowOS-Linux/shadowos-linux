#!/usr/bin/env bash

set -euo pipefail

if [ -f "/usr/share/applications/bazzite-steam-bpm.desktop" ]; then
    rm /usr/share/applications/bazzite-steam-bpm.desktop
fi
