#!/usr/bin/env bash
set -euo pipefail

git clone --depth=1 --single-branch https://github.com/rafaelmardojai/firefox-gnome-theme.git /etc/themes/mozilla/browser/gnome/
git clone --depth=1 --single-branch https://github.com/MrOtherGuy/firefox-csshacks.git /etc/themes/mozilla/browser/csshacks/
git clone --depth=1 --single-branch https://github.com/rafaelmardojai/thunderbird-gnome-theme.git /etc/themes/mozilla/email/gnome/
