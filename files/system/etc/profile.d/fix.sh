#!/bin/bash
# sometimes /etc/skel doesn't work for the first user so this script should fix it and delete itself
cp -rfp /etc/skel/. "$HOME/"
rm -f /etc/profile.d/fix.sh
