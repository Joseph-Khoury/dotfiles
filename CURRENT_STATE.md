# Current Dotfiles State

Date: 2026-06-15

## What I did

- Added floating window keybinds through hammerspoon
- Reorganized dotfiles into **common** / **macos** / **windows structure**.
- Moved shared terminal/editor configs into common.
- Moved macOS specific configs into macOS.
- Set up keybind extraction scripts.
- Set up Obsidian-facing config/keybind tracking.
- Fixed all symlink issues which arose from moving the configs (now I have a script to automate it *untested*)
- Cleaned generated/noisy files from the repo (including weird git env duping in the root folder).

## Current structure

- `common/nvim` → Neovim config
- `common/tmux` → tmux config
- `common/shell` → zsh/shell config
- `macos/aerospace` → AeroSpace config
- `macos/hammerspoon` → Hammerspoon config
- `macos/alacritty` → Alacritty config
- `macos/sketchybar` → Sketchybar config
- `windows/` → ==placeholder for Windows parity setup== 
- `common/keybinds/curated` → manually curated keybinds
- `common/keybinds/generated` → extracted/raw keybinds
- `obsidian/generated` → generated Obsidian notes/Bases

## What works now

- macOS dotfiles are reorganized and working.
- Keybinds are easier to find.
- Windows setup has a place to live.

## What is next

1. Stop changing macOS unless something is broken.
2. Set up WSL on Cookie.
3. Link only common configs first:
    - Neovim
    - tmux
    - zsh
    - git
5. After common is working, configure GlazeWM/Zebar using the parity map (keybindings).
6. Focus on getting the work environment functional

## For later

- Do not redesign or refactor the repo again.
- Do not keep changing keybinds.
- Do not polish Obsidian.
- Do not install random extra tooling. 
