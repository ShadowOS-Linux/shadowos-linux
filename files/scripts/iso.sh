#!/usr/bin/env bash
set -eoux pipefail

dnf install -y --disableexcludes=all anaconda-live libblockdev-btrfs
