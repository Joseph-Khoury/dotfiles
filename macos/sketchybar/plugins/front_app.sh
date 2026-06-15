#!/usr/bin/env bash

APP="${INFO:-$(osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)}"
[ -z "$APP" ] && APP="Desktop"

sketchybar --set "$NAME" label="$APP"
