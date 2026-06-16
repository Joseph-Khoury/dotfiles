#!/usr/bin/env bash
set -euo pipefail

ROOT="${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
TS="$(date +%Y%m%d-%H%M%S)"

backup_if_needed() {
  local dest="$1"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ -L "$dest" ]; then
      rm "$dest"
    else
      mv "$dest" "$dest.backup.$TS"
      echo "Backed up: $dest"
    fi
  fi
}

link_path() {
  local src="$1"
  local dest="$2"

  if [ ! -e "$src" ]; then
    echo "Skipped missing source: $src"
    return
  fi

  mkdir -p "$(dirname "$dest")"
  backup_if_needed "$dest"
  ln -s "$src" "$dest"
  echo "Linked: $dest -> $src"
}

echo "Repo root: $ROOT"
echo "Applying WSL dotfiles..."
echo

link_path "$ROOT/common/nvim" "$HOME/.config/nvim"
link_path "$ROOT/common/tmux/tmux.conf" "$HOME/.tmux.conf"

# Do not link the current macOS-heavy common/shell/zshrc into WSL unless no WSL file exists.
if [ -f "$ROOT/common/shell/zshrc-wsl" ]; then
  link_path "$ROOT/common/shell/zshrc-wsl" "$HOME/.zshrc"
else
  echo "No common/shell/zshrc-wsl found. Leaving ~/.zshrc untouched to avoid applying the macOS-heavy zshrc."
fi

link_path "$ROOT/common/shell/p10k.zsh" "$HOME/.p10k.zsh"
link_path "$ROOT/common/git/gitconfig" "$HOME/.gitconfig"

if [ -d "$ROOT/common/fastfetch" ]; then
  link_path "$ROOT/common/fastfetch" "$HOME/.config/fastfetch"
fi

echo
echo "WSL dotfiles applied. Run: source ~/.zshrc"
