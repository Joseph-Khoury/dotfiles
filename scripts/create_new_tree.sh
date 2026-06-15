#!/usr/bin/env bash 
set -euo pipefail

# Always run from the dotfiles repo root
ROOT="$(git rev-parse --show-toplevel)"
cd "$ROOT"
echo "Repo root: $ROOT"
echo "Generating new folder structure..."
echo

mkdir -p common/{nvim,tmux,shell,git,keybinds/{curated,generated,scripts}}
mkdir -p macos/{aerospace,alacritty,hammerspoon,sketchybar,neovide,keybinds/generated}
mkdir -p windows/{glazewm,zebar,windows-terminal,powershell,autohotkey,keybinds/generated}
mkdir -p obsidian/{generated,templates}
mkdir -p scripts

echo
echo "Done. New folder structure generated."
echo 
echo "now check:"
echo " ls -a"
