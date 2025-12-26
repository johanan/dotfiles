#!/bin/bash

set -e

# Parse command line arguments
CLEANUP=false
if [[ "$1" == "--cleanup" ]]; then
  CLEANUP=true
fi

# Set up pkg-config to find libraries in /usr/local
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:/usr/local/share/pkgconfig:${PKG_CONFIG_PATH}"

echo "Installing hyprlock..."

# Install dependencies
echo "Installing cmake and build dependencies..."
sudo apt update
sudo apt install -y cmake build-essential libgbm-dev libdrm-dev mesa-common-dev libegl1-mesa-dev libgles2-mesa-dev hyprland-dev libpugixml-dev libwayland-dev libwayland-egl-backend-dev wayland-protocols libcairo2-dev libpango1.0-dev libpam0g-dev libsystemd-dev libjpeg-dev libwebp-dev libmagic-dev meson librsvg2-dev libinput-dev libseat-dev libdisplay-info-dev
sudo apt install -y libzip-dev libtomlplusplus-dev libxcursor-dev libre2-dev libxcb-xfixes0-dev libxcb-icccm4-dev libxcb-composite0-dev libxcb-res0-dev libxcb-errors-dev libxml2-dev libxcb1-dev libxcb-xkb-dev bison flex libiniparser-dev

# Create temporary directory for source
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Build libxkbcommon from source (need version 1.11.0+ for xkb v2 format)
if ! pkg-config --exists "xkbcommon >= 1.11.0" 2>/dev/null; then
  echo "Building libxkbcommon..."
  git clone --depth 1 --branch xkbcommon-1.11.0 https://github.com/xkbcommon/libxkbcommon.git
  cd libxkbcommon
  meson setup build -Denable-docs=false -Denable-wayland=true -Denable-x11=true
  meson compile -C build
  sudo meson install -C build
  sudo ldconfig
  cd ..
else
  echo "libxkbcommon >= 1.11.0 already installed"
fi

# Build hyprwayland-scanner from source (need version 0.4.4+)
if ! pkg-config --exists "hyprwayland-scanner >= 0.4.5" 2>/dev/null; then
  echo "Building hyprwayland-scanner..."
  git clone --depth 1 --branch v0.4.5 https://github.com/hyprwm/hyprwayland-scanner.git
  cd hyprwayland-scanner
  cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
  cmake --build ./build --config Release -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
  sudo cmake --install ./build
  cd ..
else
  echo "hyprwayland-scanner already installed"
fi

# Build hyprutils
if ! pkg-config --exists "hyprutils >= 0.11." 2>/dev/null; then
  echo "Building hyprutils..."
  git clone --depth 1 --branch v0.11.0 https://github.com/hyprwm/hyprutils.git
  cd hyprutils
  cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
  cmake --build ./build --config Release -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
  sudo cmake --install ./build
  cd ..
else
  echo "hyprutils already installed"
fi

# Build hyprlang
if ! pkg-config --exists "hyprlang >= 0.6.3" 2>/dev/null; then
  echo "Building hyprlang..."
  git clone --depth 1 --branch v0.6.4 https://github.com/hyprwm/hyprlang.git
  cd hyprlang
  cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
  cmake --build ./build --config Release -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
  sudo cmake --install ./build
  cd ..
else
  echo "hyprlang already installed"
fi

# Build hyprgraphics
if ! pkg-config --exists "hyprgraphics >= 0.4.0" 2>/dev/null; then
  echo "Building hyprgraphics..."
  git clone --depth 1 --branch v0.4.0 https://github.com/hyprwm/hyprgraphics.git
  cd hyprgraphics
  cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
  cmake --build ./build --config Release -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
  sudo cmake --install ./build
  cd ..
else
  echo "hyprgraphics already installed"
fi

# Build hyprland-protocols
if ! pkg-config --exists "hyprland-protocols >= 0.7.0" 2>/dev/null; then
  echo "Building hyprland-protocols..."
  git clone --depth 1 --branch v0.7.0 https://github.com/hyprwm/hyprland-protocols.git
  cd hyprland-protocols
  meson setup build
  sudo meson install -C build
  cd ..
else
  echo "hyprland-protocols already installed"
fi

# Build hyprcursor
if ! pkg-config --exists "hyprcursor >= 0.1.13" 2>/dev/null; then
  echo "Building hyprcursor..."
  git clone --depth 1 --branch v0.1.13 https://github.com/hyprwm/hyprcursor.git
  cd hyprcursor
  cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
  sudo cmake --install ./build
  sudo ldconfig
  cd ..
else
  echo "hyprcursor already installed"
fi

if ! pkg-config --exists "aquamarine >= 0.10.0" 2>/dev/null; then
  echo "Installing aquamarine..."
  git clone --recursive --branch v0.10.0 https://github.com/hyprwm/aquamarine.git
  cd aquamarine
  cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  cmake --build ./build --config Release --target all -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
  sudo cmake --install ./build
  cd ..
else
  echo "aquamarine already installed"
fi

if ! pkg-config --exists "hyprland >= 0.52.2" 2>/dev/null; then
  echo "Installing hyprland..."
  git clone --recursive --branch v0.52.2 https://github.com/hyprwm/hyprland.git
  cd hyprland
  make all
  sudo make install
  cd ..
else
  echo "hyprland already installed"
fi

# Build sdbus-c++
if ! pkg-config --exists "sdbus-c++ >= 2.1.0" 2>/dev/null; then
  echo "Building sdbus-c++..."
  git clone --depth 1 --branch v2.1.0 https://github.com/Kistler-Group/sdbus-cpp.git
  cd sdbus-cpp
  cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
  cmake --build ./build --config Release -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)
  sudo cmake --install ./build
  cd ..
else
  echo "sdbus-c++ already installed"
fi

# Build and install hyprlock
if [[ "$(hyprlock --version 2>/dev/null)" != "Hyprlock version v0.9.2" ]]; then
  echo "Building hyprlock..."
  git clone --depth 1 --branch v0.9.2 https://github.com/hyprwm/hyprlock.git
  cd hyprlock
  cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -S . -B ./build
  cmake --build ./build --config Release --target hyprlock -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF) --verbose

  # Install hyprlock
  echo "Installing hyprlock..."
  sudo cmake --install build
  cd ..
else
  echo "hyprlock v0.9.2 already installed"
fi

# Build and install hypridle
if [[ "$(hypridle --version 2>/dev/null)" != "hypridle v0.1.7" ]]; then
  echo "Building hypridle..."
  git clone --depth 1 --branch v0.1.7 https://github.com/hyprwm/hypridle.git
  cd hypridle
  cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  # Install hypridle
  echo "Installing hypridle..."
  sudo cmake --install build
  cd ..
else
  echo "hypridle v0.1.7 already installed"
fi

# Build and install hyprtoolkit
if ! pkg-config --exists "hyprtoolkit" 2>/dev/null; then
  echo "Building hyprtoolkit..."
  git clone --depth 1 https://github.com/hyprwm/hyprtoolkit.git
  cd hyprtoolkit
  cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  echo "Installing hyprtoolkit..."
  sudo cmake --install build
  cd ..
else
  echo "hyprtoolkit already installed"
fi

# Build and install hyprland-guiutils
if ! command -v hyprland-guiutils &> /dev/null; then
  echo "Building hyprland-guiutils..."
  git clone --depth 1 https://github.com/hyprwm/hyprland-guiutils.git
  cd hyprland-guiutils
  cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
  cmake --build ./build --config Release --target all -j$(nproc 2>/dev/null || getconf _NPROCESSORS_CONF)

  echo "Installing hyprland-guiutils..."
  sudo cmake --install build
  cd ..
else
  echo "hyprland-guiutils already installed"
fi

# Update library cache
echo "Updating library cache..."
sudo ldconfig

# Clean up build dependencies if requested
if [[ "$CLEANUP" == true ]]; then
  echo "Removing build dependencies..."
  sudo apt autoremove -y cmake build-essential libgbm-dev libdrm-dev mesa-common-dev libegl1-mesa-dev libgles2-mesa-dev libpugixml-dev libwayland-dev libwayland-egl-backend-dev wayland-protocols libxkbcommon-dev libcairo2-dev libpango1.0-dev libpam0g-dev libsystemd-dev libjpeg-dev libwebp-dev libmagic-dev meson
  sudo apt autoremove -y
  echo "Build dependencies removed"
fi

# Clean up source files
echo "Cleaning up source files..."
cd /
rm -rf "$TEMP_DIR"

echo "hyprlock installation complete!"
if [[ "$CLEANUP" == false ]]; then
  echo "Run with --cleanup flag to remove build dependencies after installation"
fi
