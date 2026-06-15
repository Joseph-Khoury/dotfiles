#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"

if pgrep -x "Nextcloud" >/dev/null 2>&1; then
  sketchybar --set "$NAME" icon.color=$BLUE background.color=$SURFACE0
else
  sketchybar --set "$NAME" icon.color=$OVERLAY0 background.color=$SURFACE0
fi
