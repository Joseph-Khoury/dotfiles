#!/usr/bin/env bash
set -euo pipefail

ROOT="${DOTFILES_ROOT:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

echo "Repo root: $ROOT"
echo "Importing live WSL configs into repo..."
echo

mkdir -p "$ROOT/common/shell" "$ROOT/common/git" "$ROOT/common/fastfetch"

if [ -f "$HOME/.zshrc" ]; then
  cp "$HOME/.zshrc" "$ROOT/common/shell/zshrc-wsl"
  echo "Imported ~/.zshrc -> common/shell/zshrc-wsl"
else
  echo "Skipped missing ~/.zshrc"
fi

if [ -f "$HOME/.p10k.zsh" ]; then
  cp "$HOME/.p10k.zsh" "$ROOT/common/shell/p10k.zsh"
  echo "Imported ~/.p10k.zsh -> common/shell/p10k.zsh"
else
  echo "Skipped missing ~/.p10k.zsh"
fi

if [ -f "$HOME/.gitconfig" ]; then
  cp "$HOME/.gitconfig" "$ROOT/common/git/gitconfig"
  echo "Imported ~/.gitconfig -> common/git/gitconfig"
else
  echo "Skipped missing ~/.gitconfig"
fi

if [ -d "$HOME/.config/fastfetch" ]; then
  rm -rf "$ROOT/common/fastfetch"
  mkdir -p "$ROOT/common/fastfetch"
  cp -R "$HOME/.config/fastfetch/." "$ROOT/common/fastfetch/"
  echo "Imported ~/.config/fastfetch -> common/fastfetch"
else
  echo "Skipped missing ~/.config/fastfetch"
fi

echo
echo "Import complete. Check with: git status --short"
