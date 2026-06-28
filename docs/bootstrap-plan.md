# Dotfiles bootstrap plan

This document records what the setup scripts are expected to install and link.

The scripts are intentionally conservative:

- Existing real files/directories are backed up before replacement.
- Existing correct symlinks are left alone.
- Windows uses copy-with-backup by default because some Windows apps dislike live symlinked config files.
- Use dry-run first when supervising a new machine.

## Entry points

### macOS / WSL / native Linux

```sh
./scripts/setup-unix.sh fresh --dry-run
./scripts/setup-unix.sh fresh --yes
./scripts/setup-unix.sh update --yes
./scripts/setup-unix.sh doctor
```

Modes:

- `fresh`: core tools + GUI tools + LaTeX tools + links
- `update`: core tools + links; use `--gui` or `--latex` to add heavier parts
- `link`: links only
- `doctor`: checks commands and links

Useful flags:

- `--dry-run`
- `--yes`
- `--no-install`
- `--no-link`
- `--gui` / `--no-gui`
- `--latex` / `--no-latex`

### Windows host

```powershell
.\scripts\setup-windows.ps1 fresh -DryRun
.\scripts\setup-windows.ps1 fresh -Yes
.\scripts\setup-windows.ps1 update -Yes
.\scripts\setup-windows.ps1 doctor
```

By default, Windows config is copied with backups. Use `-UseSymlinks` only after Developer Mode/admin symlink permissions are working.

## Symlink/copy map

### Shared Unix-like targets: macOS, WSL, native Linux

| Repo path | Live path | Type |
|---|---:|---|
| repo root | `~/.dotfiles` | symlink, if repo is not already there |
| `common/nvim` | `~/.config/nvim` | symlink |
| `common/tmux/tmux.conf` | `~/.tmux.conf` | symlink |
| `common/shell/zsh/zshrc` | `~/.zshrc` | symlink |
| `common/shell/zsh/p10k.zsh` | `~/.p10k.zsh` | symlink |
| `common/shell/fastfetch` | `~/.config/fastfetch` | symlink |
| `common/lazygit` | `~/.config/lazygit` | symlink |
| `common/neofetch` | `~/.config/neofetch` | symlink, legacy if present |

The `~/.dotfiles` link matters because the Zsh loader defaults to `DOTFILES=$HOME/.dotfiles`.

### macOS-only targets

| Repo path | Live path | Type |
|---|---:|---|
| `macos/aerospace` | `~/.config/aerospace` | symlink |
| `macos/alacritty` | `~/.config/alacritty` | symlink |
| `macos/hammerspoon` | `~/.hammerspoon` | symlink |
| `macos/sketchybar` | `~/.config/sketchybar` | symlink |
| `macos/neovide/neovide` | `~/.config/neovide` | symlink |

### Windows host targets

| Repo path | Live path | Default |
|---|---:|---|
| `windows/glazewm/config.yaml` | `%USERPROFILE%\.glzr\glazewm\config.yaml` | copy with backup |
| `windows/zebar` | `%USERPROFILE%\.glzr\zebar` | copy with backup |
| `windows/windows-terminal/settings.json` | Windows Terminal `settings.json` | copy with backup |
| `windows/powershell/Microsoft.PowerShell_profile.ps1` | `$PROFILE` | copy with backup |
| Sioyek generated preference | `%APPDATA%\sioyek\prefs_user.config` | ensure `vimtex_wsl_fix 1` |

## External downloads inferred from the repo

### Shared CLI tools

Required or strongly expected:

- `git`
- `zsh`
- `curl`
- `tmux`
- `neovim`
- `ripgrep` (`rg`)
- `fd` / Debian `fd-find`
- `fzf`
- `unzip`
- C/build tools for native plugin builds such as Telescope FZF
- `python3`, `python3-venv`, `python3-pip`
- `node`, `npm`
- `lazygit`, because both ToggleTerm and `lazygit.nvim` call the external binary
- `tree-sitter` CLI, useful for parser installs/health and grammar work; Neovim parsers are still managed separately by the plugin

Useful optional tools used by aliases or workflow:

- `fastfetch`
- `zoxide`
- `atuin`
- `eza`
- `bat`
- `tree`
- `shellcheck`
- `shfmt`
- `jq`

### Zsh and tmux plugins

Installed/updated by `setup-unix.sh`:

- Oh My Zsh
- Powerlevel10k
- `fzf-tab`
- `zsh-autosuggestions`
- `zsh-syntax-highlighting`
- `zsh-completions`
- tmux TPM

### Neovim plugins

Installed by Lazy.nvim from `common/nvim` after `nvim --headless "+Lazy! sync" +qa` or opening Neovim:

- Telescope, FZF native extension, UI-select extension
- nvim-cmp, LuaSnip, cmp sources, cmp-vimtex
- nvim-lspconfig, Mason, Mason-LSPConfig, Trouble
- VimTeX, render-markdown
- Oil, Flash, Harpoon
- Fugitive, LazyGit plugin
- Catppuccin, lualine, fine-cmdline
- Treesitter and parser registry

Important distinction: Lazy installs the `nvim-treesitter` plugin, but the OS still needs a compiler/toolchain. The `tree-sitter` CLI is also installed by the bootstrap script because it is useful for parser generation/health checks and grammar development.

### Mason language servers

Your Neovim config requests:

- `lua_ls`
- `bashls`
- `taplo`
- `pyright`
- `rust_analyzer`
- `texlab`
- `ltex_plus`
- `verible`
- `vhdl_ls`

These are installed by Mason when the LSP config loads.

### LaTeX and PDF viewers

For full LaTeX workflow:

- `latexmk`
- `biber`
- TeX Live packages on Debian/Linux:
  - `texlive-latex-recommended`
  - `texlive-latex-extra`
  - `texlive-fonts-recommended`
  - `texlive-science`
  - `texlive-pictures`
- macOS:
  - `mactex-no-gui`
  - Skim
- native Linux:
  - Zathura
  - `zathura-pdf-poppler`
- WSL:
  - compile with Linux LaTeX tools
  - view with Windows Sioyek through `~/.local/bin/sioyek-wsl`

### macOS GUI/windowing tools

For full macOS setup:

- AeroSpace
- JankyBorders/borders
- SketchyBar
- Alacritty
- Neovide
- Hammerspoon
- JetBrains Mono Nerd Font

### Windows host tools

For full Windows host setup:

- Git
- Windows Terminal
- GlazeWM
- Zebar
- Sioyek
- optionally Alacritty and Neovide

Winget package identifiers can change. The Windows script treats GUI installs as best-effort and continues if an ID is unavailable.

## What the scripts do not try to solve

- They do not permanently delete existing configs; they back them up.
- They do not force a specific Git remote.
- They do not install Vivado or vendor FPGA tools.
- They do not guarantee Neovim nightly/stable version policy beyond checking the installed `nvim`.
- They do not configure private machine-specific secrets. Put those in ignored local files.
