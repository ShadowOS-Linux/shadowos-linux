#!/usr/bin/env bash
set -euo pipefail
curl -L --fail "https://github.com/brcly/linuwux-runtime/releases/latest/download/liblinuwux.so" -o /usr/lib64/liblinuwux.so
chmod 0755 /usr/lib64/liblinuwux.so
