#!/bin/bash

# Install dotfiles using GNU Stow

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if stow is installed
if ! command -v stow &> /dev/null; then
    echo "Error: GNU Stow is not installed"
    echo "Install it with: sudo pacman -S stow"
    exit 1
fi

cd "$SCRIPT_DIR"
stow -v configs

echo ""
echo "Done! Configs are now symlinked to this repo."
