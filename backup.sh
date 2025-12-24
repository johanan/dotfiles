#!/bin/bash

# Backup existing configs before running stow
# Renames existing files/directories with .YYYYMMDD.bak suffix

set -e

BACKUP_SUFFIX=".$(date +%Y%m%d).bak"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Backing up existing configs..."

# Backup .config directory contents
if [ -d "$SCRIPT_DIR/configs/.config" ]; then
    for config_dir in "$SCRIPT_DIR/configs/.config"/*; do
        if [ -d "$config_dir" ]; then
            config_name=$(basename "$config_dir")
            target="$HOME/.config/$config_name"

            if [ -e "$target" ]; then
                backup_path="${target}${BACKUP_SUFFIX}"
                mv "$target" "$backup_path"
            fi
        fi
    done
fi

echo "Backup complete!"
