#!/bin/bash

sudo apt install -y zig
sudo apt install -y libgtk-4-dev libgtk4-layer-shell-dev libadwaita-1-dev gettext libxml2-utils

TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# get these files for ghostty and pop them in a temp TEMP_DIR
wget https://release.files.ghostty.org/1.2.3/ghostty-1.2.3.tar.gz

tar -xvf ghostty-1.2.3.tar.gz
cd ghostty-1.2.3

# Fix the outdated .iterm2_themes block in build.zig.zon
# Fetch the latest build.zig.zon from main branch
wget -O build.zig.zon.main https://raw.githubusercontent.com/ghostty-org/ghostty/main/build.zig.zon

# Extract the .iterm2_themes block from the main branch version
ITERM2_BLOCK=$(sed -n '/\.iterm2_themes = \.{/,/^[[:space:]]*},/p' build.zig.zon.main)

# Replace the old .iterm2_themes block in the local build.zig.zon
perl -i -0pe 's/\.iterm2_themes = \.\{.*?\n\s*\},/'"$(echo "$ITERM2_BLOCK" | perl -pe 's/([\\\/&])/\\$1/g')"'/s' build.zig.zon

# Clean up the downloaded main branch file
rm build.zig.zon.main

zig build -p $HOME/.local -Doptimize=ReleaseFast
