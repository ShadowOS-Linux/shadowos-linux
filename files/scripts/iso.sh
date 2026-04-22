#!/usr/bin/env bash
set -eoux pipefail

dnf install -y anaconda-live libblockdev-btrfs --setopt=disable_excludes=*
