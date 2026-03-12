#!/bin/bash

set -e

TOFI_VERSION="v0.9.1"
TOFI_URL="https://github.com/philj56/tofi/archive/refs/tags/${TOFI_VERSION}.tar.gz"

echo "Installing tofi ${TOFI_VERSION} dependencies..."
sudo apt install -y \
    libfreetype-dev \
    libcairo2-dev \
    libpango1.0-dev \
    libwayland-dev \
    libxkbcommon-dev \
    libharfbuzz-dev \
    meson \
    scdoc \
    wayland-protocols

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "${TEMP_DIR}"' EXIT

echo "Downloading tofi ${TOFI_VERSION}..."
wget -q --show-progress -O "${TEMP_DIR}/tofi.tar.gz" "${TOFI_URL}"

echo "Extracting..."
tar -xf "${TEMP_DIR}/tofi.tar.gz" -C "${TEMP_DIR}"

cd "${TEMP_DIR}/tofi-${TOFI_VERSION#v}"

echo "Building tofi..."
meson setup build --prefix="${HOME}/.local" --buildtype=release
ninja -C build install

echo "Done. tofi ${TOFI_VERSION} installed."
