#!/usr/bin/env bash

ACTIVE_BG=0xff89b4fa
ACTIVE_FG=0xff1e1e2e
INACTIVE_BG=0xff313244
INACTIVE_FG=0xffcdd6f4

CURRENT="$1"
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

if [ "$CURRENT" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" \
    background.color=$ACTIVE_BG \
    icon.color=$ACTIVE_FG
else
  sketchybar --set "$NAME" \
    background.color=$INACTIVE_BG \
    icon.color=$INACTIVE_FG
fi
