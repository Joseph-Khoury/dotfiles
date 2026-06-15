#!/usr/bin/env bash

PERCENT="$(pmset -g batt | grep -Eo '[0-9]+%' | head -n 1)"
SOURCE="$(pmset -g batt | head -n 1)"

if [ -z "$PERCENT" ]; then
  sketchybar --set "$NAME" drawing=off
  exit 0
fi

if echo "$SOURCE" | grep -q "AC Power"; then
  ICON="󰂄"
else
  ICON="󰁹"
fi

sketchybar --set "$NAME" drawing=on icon="$ICON" label="$PERCENT"
