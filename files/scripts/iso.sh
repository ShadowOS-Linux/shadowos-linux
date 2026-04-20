#!/usr/bin/env bash
set -eoux pipefail

dnf install -y NetworkManager NetworkManager-team anaconda-live libblockdev-btrfs
