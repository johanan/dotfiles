#!/bin/bash

THEME="${1}"
WIDTH="${2:-3840}"
HEIGHT="${3:-2400}"
SVG="/usr/share/desktop-base/${THEME}/wallpaper/contents/images/1920x1200.svg"

rsvg-convert -w "$WIDTH" -h "$HEIGHT" "$SVG" -o "${HOME}/Pictures/${THEME%.theme}.png" || echo "rsvg-convert not found. Run: sudo apt install librsvg2-bin"
