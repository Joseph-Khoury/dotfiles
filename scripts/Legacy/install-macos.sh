#!/usr/bin/env bash
set -euo pipefail

ROOT="${DOTFILES_ROOT:-$(cd "$(dirname "$0")/.." && pwd)}"

backup_path() {
  local path="$1"
  if [ -e "$path" ] || [ -L "$path" ]; then
    local backup="${path}.backup.$(date +%Y%m%d%H%M%S)"
    echo "Backing up $path -> $backup"
    mv "$path" "$backup"
  fi
}

link_path() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$src" ]; then
    echo "Source does not exist: $src"
    return 1
  fi

  mkdir -p "$(dirname "$dest")"
  backup_path "$dest"

  echo "Linking $dest -> $src"
  ln -s "$src" "$dest"
}

echo "This will replace selected live configs with symlinks."
echo "It will back up existing live configs first."
echo "Press Enter to continue, Ctrl-C to cancel."
read -r _

link_path "$ROOT/common/nvim" "$HOME/.config/nvim"
link_path "$ROOT/common/tmux/tmux.conf" "$HOME/.tmux.conf"
link_path "$ROOT/common/shell/zshrc" "$HOME/.zshrc"

if [ -f "$ROOT/common/git/gitconfig" ]; then
  link_path "$ROOT/common/git/gitconfig" "$HOME/.gitconfig"
fi

link_path "$ROOT/macos/aerospace" "$HOME/.config/aerospace"
link_path "$ROOT/macos/alacritty" "$HOME/.config/alacritty"
link_path "$ROOT/macos/hammerspoon" "$HOME/.hammerspoon"
link_path "$ROOT/macos/sketchybar" "$HOME/.config/sketchybar"

echo "Done."
echo "Now test: nvim, tmux, zsh, AeroSpace, Hammerspoon, Alacritty, Sketchybar."
