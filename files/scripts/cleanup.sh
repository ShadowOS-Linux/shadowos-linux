#!/usr/bin/env bash

set -euo pipefail

# 1. Remove Package Manager Bloat
dnf clean all
rm -rf /var/cache/dnf/*
rm -rf /var/cache/yum/*
rm -rf /var/lib/dnf/history.*
rm -rf /var/tmp/rpm-ostree.*

# 2. Remove Documentation and Manuals
rm -rf /usr/share/man/*
rm -rf /usr/share/doc/*
rm -rf /usr/share/info/*

# 3. Clean up Temporary Build Files
rm -rf /tmp/*
rm -rf /var/tmp/*

# 4. Remove Flatpak Metadata/Temp files
if [ -d "/var/lib/flatpak/repo/tmp" ]; then
    echo "Cleaning Flatpak repo temp files..."
    rm -rf /var/lib/flatpak/repo/tmp/*
fi

# 5. Remove Hardware DB Caches
echo "Cleaning hardware database caches..."
rm -rf /etc/udev/hwdb.bin
rm -rf /var/lib/udev/hwdb.bin
