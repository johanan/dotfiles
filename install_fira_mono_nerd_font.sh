#!/bin/bash

set -e

FONT_NAME="FiraCode"
NERD_FONTS_VERSION="v3.4.0"
DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/${NERD_FONTS_VERSION}/${FONT_NAME}.tar.xz"
FONT_DIR="${HOME}/.local/share/fonts/FiraCodeNerdFontMono"

echo "Installing FiraMono Nerd Font ${NERD_FONTS_VERSION}..."

mkdir -p "${FONT_DIR}"

TEMP_DIR=$(mktemp -d)
trap 'rm -rf "${TEMP_DIR}"' EXIT

echo "Downloading ${FONT_NAME}.tar.xz..."
wget -q --show-progress -O "${TEMP_DIR}/${FONT_NAME}.tar.xz" "${DOWNLOAD_URL}"

echo "Extracting fonts..."
tar -xf "${TEMP_DIR}/${FONT_NAME}.tar.xz" -C "${TEMP_DIR}"

find "${TEMP_DIR}" -name "*.ttf" -exec cp {} "${FONT_DIR}/" \;

echo "Refreshing font cache..."
fc-cache -f "${FONT_DIR}"

echo "Done. FiraMono Nerd Font installed to ${FONT_DIR}"
echo "Verify with: fc-list | grep -i firamono"

# --- Fira Sans ---
FIRA_SANS_DIR="${HOME}/.local/share/fonts/FiraSans"
FIRA_SANS_BASE_URL="https://github.com/google/fonts/raw/main/ofl/firasans"
FIRA_SANS_FILES=(
    "FiraSans-Thin.ttf"
    "FiraSans-ThinItalic.ttf"
    "FiraSans-ExtraLight.ttf"
    "FiraSans-ExtraLightItalic.ttf"
    "FiraSans-Light.ttf"
    "FiraSans-LightItalic.ttf"
    "FiraSans-Regular.ttf"
    "FiraSans-Italic.ttf"
    "FiraSans-Medium.ttf"
    "FiraSans-MediumItalic.ttf"
    "FiraSans-SemiBold.ttf"
    "FiraSans-SemiBoldItalic.ttf"
    "FiraSans-Bold.ttf"
    "FiraSans-BoldItalic.ttf"
    "FiraSans-ExtraBold.ttf"
    "FiraSans-ExtraBoldItalic.ttf"
    "FiraSans-Black.ttf"
    "FiraSans-BlackItalic.ttf"
)

echo "Installing Fira Sans..."
mkdir -p "${FIRA_SANS_DIR}"

for font_file in "${FIRA_SANS_FILES[@]}"; do
    if [ -f "${FIRA_SANS_DIR}/${font_file}" ]; then
        echo "Skipping ${font_file} (already installed)"
    else
        echo "Downloading ${font_file}..."
        wget -q --show-progress -O "${FIRA_SANS_DIR}/${font_file}" "${FIRA_SANS_BASE_URL}/${font_file}"
    fi
done

echo "Refreshing font cache..."
fc-cache -f "${FIRA_SANS_DIR}"

echo "Done. Fira Sans installed to ${FIRA_SANS_DIR}"
echo "Verify with: fc-list | grep -i 'fira sans'"
