#!/usr/bin/env bash
set -euo pipefail

ROOT="${DOTFILES_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

"$ROOT/scripts/collect-keybinds.sh"
"$ROOT/scripts/render-obsidian-notes.py"

OBSIDIAN_SYSTEM="${OBSIDIAN_SYSTEM:-$HOME/Nextcloud/Obsidian/System/Dotfiles Generated}"

if [ -d "$(dirname "$OBSIDIAN_SYSTEM")" ]; then
  mkdir -p "$OBSIDIAN_SYSTEM"
  rsync -a --delete "$ROOT/obsidian/generated/" "$OBSIDIAN_SYSTEM/"
  echo "Synced generated notes to $OBSIDIAN_SYSTEM"
else
  echo "Obsidian destination parent does not exist. Skipping sync."
fi
