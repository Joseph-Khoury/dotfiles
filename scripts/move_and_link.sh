#!/usr/bin/env bash
set -euo pipefail
DOTFILES="~/.dotfiles"

move_and_link() {
    src="$1"
    dst="$DOTFILES/$2"

    echo "Moving $src -> $dst"
    mkdir -p "$(dirname "$dst")"
    mv "$src" "$dst"
    ln -s "$dst" "$src"
}

# move_and_link ~/.config/alacritty .config/alacritty
# move_and_link ~/.config/aerospace .config/aerospace
# move_and_link ~/.config/sketchybar .config/sketchybar
# move_and_link ~/.config/nvim .config/nvim
# move_and_link ~/.config/tmux .config/tmux
move_and_link $1 $2
