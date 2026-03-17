#!/bin/bash

set -e

sudo apt update

# Core Hyprland
echo "Installing Hyprland..."
sudo apt install -y \
    hyprland \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    hyprland-guiutils

# Hyprland ecosystem tools
echo "Installing Hyprland ecosystem tools..."
sudo apt install -y \
    hyprpaper \
    hypridle \
    hyprlock

# Status bar
echo "Installing waybar..."
sudo apt install -y waybar

# Audio (pipewire stack)
echo "Installing pipewire/wireplumber..."
sudo apt install -y \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    wireplumber \
    libspa-0.2-bluetooth

# Brightness and media controls
echo "Installing brightness and media controls..."
sudo apt install -y \
    brightnessctl \
    playerctl

echo "Installing wlsunset..."
sudo apt install -y wlsunset

# Clipboard and misc wayland utilities
echo "Installing wayland utilities..."
sudo apt install -y \
    wl-clipboard \
    cliphist
