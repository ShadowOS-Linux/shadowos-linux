#!/usr/bin/env bash
set -euo pipefail

BUILD_ROOT="/tmp/heroic-build-sandbox"
mkdir -p "$BUILD_ROOT"
cd "$BUILD_ROOT"

dnf install -y rpm-build

python3 -m venv pyenv
source pyenv/bin/activate
pip install nodeenv

nodeenv --node=latest --prebuilt node_env
source node_env/bin/activate

npm install -g pnpm@10

git clone https://github.com/Heroic-Games-Launcher/HeroicGamesLauncher.git --recurse-submodules repo
cd repo

git fetch origin pull/5620/head
git diff HEAD...FETCH_HEAD | git apply

pnpm install
pnpm download-helper-binaries
pnpm dist:linux rpm

RPM_FILE=$(find dist/ -type f -name "*.rpm" | head -n 1)
if [ -n "$RPM_FILE" ] && [ -f "$RPM_FILE" ]; then
    dnf install -y "$RPM_FILE"
else
    exit 1
fi

deactivate
deactivate_node

dnf remove -y rpm-build
dnf clean all

rm -rf "$HOME/.npm"
rm -rf "$HOME/.cache/pnpm"
rm -rf "$HOME/.cache/electron-builder"
rm -rf "$HOME/.local/share/pnpm"

cd /tmp
rm -rf "$BUILD_ROOT"
