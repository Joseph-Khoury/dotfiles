#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y zsh fzf zsh-completions git curl

if command -v brew >/dev/null 2>&1; then
  brew install zoxide atuin eza bat ripgrep fd fastfetch || true
fi

ZSH="${ZSH:-$HOME/.oh-my-zsh}"
ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"
mkdir -p "$ZSH_CUSTOM/plugins"

clone_or_pull() {
  local repo="$1"
  local dest="$2"
  if [[ -d "$dest/.git" ]]; then
    git -C "$dest" pull --ff-only
  else
    git clone --depth=1 "$repo" "$dest"
  fi
}

clone_or_pull https://github.com/Aloxaf/fzf-tab "$ZSH_CUSTOM/plugins/fzf-tab"
clone_or_pull https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_pull https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

ln -sf "$HOME/.dotfiles/common/shell/zsh/zshrc" "$HOME/.zshrc"

echo "Done. Restart with: exec zsh"
