#!/usr/bin/env bash

CONFIG_DIR="$HOME/.config/sketchybar"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/plugins/icon_map.sh"

command -v aerospace >/dev/null 2>&1 || exit 0

# Remove old dynamic workspace items and bracket
sketchybar --remove '/space\..*/' >/dev/null 2>&1
sketchybar --remove spaces_bracket >/dev/null 2>&1

FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused 2>/dev/null)}"

WORKSPACES="$(
  {
    aerospace list-workspaces --monitor focused --empty no 2>/dev/null
    printf '%s\n' "$FOCUSED"
  } | awk 'NF && !seen[$0]++'
)"

PREV="logo"

for SID in $WORKSPACES; do
  APPS="$(
    aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null \
      | awk 'NF && !seen[$0]++' \
      | head -n 4
  )"

  ICONS=""
  while IFS= read -r APP; do
    [ -z "$APP" ] && continue
    ICONS="$ICONS $(app_icon "$APP")"
  done <<APP_LIST
$APPS
APP_LIST

  [ -z "$ICONS" ] && ICONS=" ·"

  if [ "$SID" = "$FOCUSED" ]; then
    BG=$LAVENDER
    FG=$BASE
    LABEL=$BASE
  else
    BG=$SURFACE0
    FG=$TEXT
    LABEL=$SUBTEXT
  fi

  sketchybar --add item "space.$SID" left \
    --set "space.$SID" \
    icon="$SID" \
    icon.align=center \
    icon.color=$FG \
    label="$ICONS" \
    label.color=$LABEL \
    background.color=$BG \
    background.height=26 \
    background.corner_radius=9 \
    click_script="aerospace workspace $SID" \
    padding_left=2 \
    padding_right=2

  sketchybar --move "space.$SID" after "$PREV"
  PREV="space.$SID"
done

sketchybar --add bracket spaces_bracket '/space\..*/' \
  --set spaces_bracket \
  background.color=$TRANSPARENT \
  background.height=28 \
  background.corner_radius=10
