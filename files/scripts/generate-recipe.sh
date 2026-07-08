#!/bin/bash
set -euo pipefail

DES=("cosmic" "kde" "gnome" "xfce")
GPUS=("base" "nvidia" "nvidia-legacy")
STEAMS=("steam" "nosteam")

mkdir -p recipes/variants

for de in "${DES[@]}"; do
  for gpu in "${GPUS[@]}"; do
    for steam in "${STEAMS[@]}"; do

      if [ "$de" = "cosmic" ]; then
        DE_NAME="linux"
      else
        DE_NAME="$de"
      fi
      DE_DESC="${de^^}"

      GNOME_PAD=$([ "$de" != "kde" ] && echo "-gnome" || echo "")
      NVID_PAD=$([ "$gpu" = "nvidia" ] && echo "-nvidia-open" || { [ "$gpu" = "nvidia-legacy" ] && echo "-nvidia" || echo ""; })
      BASE_IMAGE="ghcr.io/ublue-os/bazzite${GNOME_PAD}${NVID_PAD}"

      IMAGE_NAME="shadowos-${DE_NAME}"
      if [ "$gpu" != "base" ]; then
        IMAGE_NAME="${IMAGE_NAME}-${gpu}"
      fi
      if [ "$steam" = "steam" ]; then
        IMAGE_NAME="${IMAGE_NAME}-steam"
      fi

      if [ "$gpu" = "nvidia" ]; then
        GPU_DESC="Nvidia "
      elif [ "$gpu" = "nvidia-legacy" ]; then
        GPU_DESC="Nvidia Legacy "
      else
        GPU_DESC=""
      fi

      DESCRIPTION="Custom Bazzite ${GPU_DESC}image with ${DE_DESC}."

      cat <<EOF > "recipes/variants/${IMAGE_NAME}.yml"
name: ${IMAGE_NAME}
description: ${DESCRIPTION}
base-image: ${BASE_IMAGE}
image-version: stable

modules:
  - from-file: common-${de}.yml
  - from-file: common-${steam}.yml

  - type: os-release
    properties:
      VARIANT_ID: ${IMAGE_NAME}
EOF

    done
  done
done
