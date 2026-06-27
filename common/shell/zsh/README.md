# Zsh config layout

This directory contains the shared Zsh config for WSL, Linux, and macOS.

## Load order

1. `zshrc` starts Powerlevel10k instant prompt.
2. `common/00-detect.zsh` detects `macos`, `linux`, or `wsl`.
3. `common/05-env.zsh` sets shared environment variables.
4. `os/05-*.zsh` loads OS-specific paths such as Homebrew and Neovim.
5. `common/10-history.zsh` sets history behavior.
6. `common/20-completion.zsh` configures completion paths and completion style.
7. `common/30-oh-my-zsh.zsh` loads Oh My Zsh and plugins.
8. `common/40-prompt.zsh` loads Powerlevel10k config.
9. `common/50-tools.zsh` loads zoxide and atuin if installed.
10. `common/60-aliases.zsh` and `os/60-*.zsh` define aliases.
11. `common/70-functions.zsh` defines helper functions.
12. `common/90-startup.zsh` runs startup commands like fastfetch.
13. `local/*.zsh` contains private machine-specific overrides and is not meant for git.

## Useful commands

- `zdir` opens this config directory in Neovim.
- `zsh-files` prints the split config files.
- `zsh-doctor` shows active plugins, plugin origins, commands, fpath, and completion audit.
- `zreload` reloads `~/.zshrc`.
