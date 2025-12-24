#!/bin/bash

# Arch Linux setup script
# Installs packages and utilities for Arch-based systems

set -e

echo "Setting up Arch Linux system..."

# Update system first
echo "Updating system..."
sudo pacman -Syu --noconfirm

# Install packages
echo "Installing packages..."

# Wayland utilities
sudo pacman -S --needed --noconfirm wlsunset hyprpaper hyprlock hypridle

# Power management
sudo pacman -S --needed --noconfirm power-profiles-daemon python-gobject brightnessctl

# Dotfiles management
sudo pacman -S --needed --noconfirm stow

# Fonts
sudo pacman -S --needed --noconfirm otf-fira-sans otf-firamono-nerd

#
# Enable and start power-profiles-daemon
echo "Enabling power-profiles-daemon..."
sudo systemctl enable --now power-profiles-daemon
