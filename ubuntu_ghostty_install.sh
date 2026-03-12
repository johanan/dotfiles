#!/bin/bash

sudo apt install -y libgtk-4-dev libgtk4-layer-shell-dev libadwaita-1-dev gettext libxml2-utils

# Install Zig 0.15.2 system-wide if not already present (apt ships an incompatible version)
if ! command -v zig &>/dev/null || [[ "$(zig version)" != "0.15.2" ]]; then
    ZIG_TARBALL="zig-x86_64-linux-0.15.2.tar.xz"
    wget -O "/tmp/${ZIG_TARBALL}" "https://ziglang.org/download/0.15.2/${ZIG_TARBALL}"
    sudo tar -xf "/tmp/${ZIG_TARBALL}" -C /opt
    sudo ln -sf /opt/zig-x86_64-linux-0.15.2/zig /usr/local/bin/zig
fi

TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# get these files for ghostty and pop them in a temp TEMP_DIR
wget https://release.files.ghostty.org/1.3.0/ghostty-1.3.0.tar.gz

tar -xvf ghostty-1.3.0.tar.gz
cd ghostty-1.3.0

# Fix the outdated .iterm2_themes block in build.zig.zon
# Fetch the latest build.zig.zon from main branch
# https://github.com/ghostty-org/ghostty/issues/9606
# wget -O build.zig.zon.main https://raw.githubusercontent.com/ghostty-org/ghostty/main/build.zig.zon

# Extract the .iterm2_themes block from the main branch version
# ITERM2_BLOCK=$(sed -n '/\.iterm2_themes = \.{/,/^[[:space:]]*},/p' build.zig.zon.main)

# # Replace the old .iterm2_themes block in the local build.zig.zon
# perl -i -0pe 's/\.iterm2_themes = \.\{.*?\n\s*\},/'"$(echo "$ITERM2_BLOCK" | perl -pe 's/([\\\/&])/\\$1/g')"'/s' build.zig.zon

# # Clean up the downloaded main branch file
# rm build.zig.zon.main

zig build -p $HOME/.local -Doptimize=ReleaseFast -fsys=fontconfig

# start ghostty on login
systemctl enable --user app-com.mitchellh.ghostty.service
