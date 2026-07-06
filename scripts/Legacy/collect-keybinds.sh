#!/usr/bin/env bash
set -euo pipefail

ROOT="${DOTFILES_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

COMMON_OUT="$ROOT/common/keybinds/generated"
MACOS_OUT="$ROOT/macos/keybinds/generated"
WINDOWS_OUT="$ROOT/windows/keybinds/generated"

mkdir -p "$COMMON_OUT" "$MACOS_OUT" "$WINDOWS_OUT"

echo "Collecting keybinds..."

# AeroSpace
if command -v aerospace >/dev/null 2>&1; then
  echo "Collecting AeroSpace keybinds..."
  aerospace config --get mode --keys > "$MACOS_OUT/aerospace-modes.txt" || true

  while read -r mode; do
    [ -z "$mode" ] && continue
    aerospace config --get "mode.${mode}.binding" --json > "$MACOS_OUT/aerospace-${mode}.json" || true
  done < "$MACOS_OUT/aerospace-modes.txt"
fi

# tmux
if command -v tmux >/dev/null 2>&1; then
  if tmux info >/dev/null 2>&1; then
    echo "Collecting tmux keybinds..."
    tmux list-keys > "$COMMON_OUT/tmux.txt" || true
  else
    echo "tmux installed, but no tmux server running. Skipping live tmux extraction."
  fi
fi

# Alacritty
if [ -f "$HOME/.config/alacritty/alacritty.toml" ]; then
  echo "Copying live Alacritty config..."
  cp "$HOME/.config/alacritty/alacritty.toml" "$MACOS_OUT/alacritty.toml"
elif [ -f "$ROOT/macos/alacritty/alacritty.toml" ]; then
  echo "Copying repo Alacritty config..."
  cp "$ROOT/macos/alacritty/alacritty.toml" "$MACOS_OUT/alacritty.toml"
fi

# Hammerspoon cannot be fully exported from shell.
# Use ExportHammerspoonHotkeys() from inside Hammerspoon.

echo "Done."
