#!/usr/bin/env bash
set -euo pipefail

brew install zsh fzf zoxide atuin eza bat ripgrep fd fastfetch

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
clone_or_pull https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
clone_or_pull https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_pull https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k"

ln -sf "$HOME/.dotfiles/common/shell/zsh/zshrc" "$HOME/.zshrc"
ln -sf "$HOME/.dotfiles/common/shell/zsh/p10k.zsh" "$HOME/.p10k.zsh"

echo "Done. Restart with: exec zsh"
