#!/usr/bin/env bash

VOLUME="$(osascript -e 'output volume of (get volume settings)' 2>/dev/null | tr -dc '0-9')"
MUTED="$(osascript -e 'output muted of (get volume settings)' 2>/dev/null)"

[ -z "$VOLUME" ] && VOLUME=0

if [ "$MUTED" = "true" ] || [ "$VOLUME" -eq 0 ]; then
  ICON="󰖁"
else
  ICON="󰕾"
fi

sketchybar --set "$NAME" icon="$ICON" label="${VOLUME}%"
