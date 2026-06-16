#!/usr/bin/env bash
set -euo pipefail

sudo apt update
sudo apt install -y \
  zsh git curl fzf fastfetch stow tmux neovim \
  ripgrep fd-find unzip build-essential \
  python3 python3-venv python3-pip \
  nodejs npm

# Debian calls fd "fdfind". Make the common "fd" command available.
mkdir -p "$HOME/.local/bin"
if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
  ln -s "$(command -v fdfind)" "$HOME/.local/bin/fd"
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_or_skip() {
  local repo="$1"
  local dest="$2"
  if [ -d "$dest/.git" ] || [ -d "$dest" ]; then
    echo "Already exists: $dest"
  else
    git clone --depth=1 "$repo" "$dest"
  fi
}

clone_or_skip "https://github.com/romkatv/powerlevel10k.git" \
  "$ZSH_CUSTOM/themes/powerlevel10k"
clone_or_skip "https://github.com/Aloxaf/fzf-tab.git" \
  "$ZSH_CUSTOM/plugins/fzf-tab"
clone_or_skip "https://github.com/zsh-users/zsh-autosuggestions.git" \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_or_skip "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_or_skip "https://github.com/tmux-plugins/tpm" \
  "$HOME/.tmux/plugins/tpm"

if [ "${SHELL:-}" != "$(command -v zsh)" ]; then
  echo "Setting zsh as default shell. You may need to enter your password."
  chsh -s "$(command -v zsh)" || true
fi

echo "WSL tool install complete. Restart the terminal if chsh changed your shell."
