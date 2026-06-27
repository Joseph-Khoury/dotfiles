# Common shell functions

# Move to directory and then list all files
cdls() {
  builtin cd "$@" && ls -a
}

# Make a directory and enter it
mkcd() {
  mkdir -p "$1" && builtin cd "$1"
}

# # Reload shell config
# zreload() {
#     exec zsh
# }

# Show the split zsh config files in load order
zsh-files() {
  print -P "%F{cyan}Common:%f"
  print -l -- "$ZSH_CONFIG_DIR"/common/*.zsh(N)
  print
  print -P "%F{cyan}OS:%f $ZSH_OS"
  case "$ZSH_OS" in
    macos) print -l -- "$ZSH_CONFIG_DIR"/os/*macos*.zsh(N) ;;
    wsl)   print -l -- "$ZSH_CONFIG_DIR"/os/*linux*.zsh(N) "$ZSH_CONFIG_DIR"/os/*wsl*.zsh(N) ;;
    linux) print -l -- "$ZSH_CONFIG_DIR"/os/*linux*.zsh(N) ;;
  esac
  print
  print -P "%F{cyan}Local:%f"
  print -l -- "$ZSH_CONFIG_DIR"/local/*.zsh(N)
}

# Inspect what zsh is actually using
zsh-doctor() {
  print -P "%F{cyan}== Zsh ==%f"
  printf "%-16s %s\n" "ZSH_VERSION:" "$ZSH_VERSION"
  printf "%-16s %s\n" "SHELL:" "$SHELL"
  printf "%-16s %s\n" "ZSH_OS:" "$ZSH_OS"
  printf "%-16s %s\n" "ZSH_CONFIG_DIR:" "$ZSH_CONFIG_DIR"
  print

  print -P "%F{cyan}== Oh My Zsh ==%f"
  printf "%-16s %s\n" "ZSH:" "$ZSH"
  printf "%-16s %s\n" "ZSH_CUSTOM:" "$ZSH_CUSTOM"
  print

  print -P "%F{cyan}== Active plugins ==%f"
  print -l -- $plugins
  print

  print -P "%F{cyan}== Plugin origin ==%f"
  for plugin in $plugins; do
    if [[ -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
      printf "%-28s %s\n" "$plugin" "custom: $ZSH_CUSTOM/plugins/$plugin"
    elif [[ -d "$ZSH/plugins/$plugin" ]]; then
      printf "%-28s %s\n" "$plugin" "builtin: $ZSH/plugins/$plugin"
    else
      printf "%-28s %s\n" "$plugin" "missing"
    fi
  done
  print

  print -P "%F{cyan}== Important commands ==%f"
  for cmd in zsh git nvim fzf rg fd eza bat batcat zoxide atuin fastfetch brew; do
    if command -v "$cmd" >/dev/null 2>&1; then
      printf "%-12s %s\n" "$cmd" "$(command -v "$cmd")"
    else
      printf "%-12s %s\n" "$cmd" "missing"
    fi
  done
  print

  print -P "%F{cyan}== fpath ==%f"
  print -l -- $fpath
  print

  print -P "%F{cyan}== Completion audit ==%f"
  autoload -Uz compaudit
  compaudit 2>/dev/null || true
}

# fastfetch
unalias fastfetch 2>/dev/null

fastfetch() {
  # If arguments are passed, behave like normal fastfetch.
  # Example: fastfetch --version
  if (( $# > 0 )); then
    command fastfetch "$@"
    return
  fi

  local cols="${COLUMNS:-$(tput cols 2>/dev/null || echo 120)}"
  [[ "$cols" == <-> ]] || cols=120

  local cfgdir="$HOME/.dotfiles/common/shell/fastfetch"
  local full="$cfgdir/config.jsonc"
  local compact="$cfgdir/compact.jsonc"

  if (( cols < 150 )); then
    command fastfetch --config "$compact"
  else
    command fastfetch --config "$full"
  fi
}

ff() {
  fastfetch "$@"
}
