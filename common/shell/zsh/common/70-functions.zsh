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

# Get the columns to choose which fastfetch config
_ff_terminal_cols() {
  emulate -L zsh

  local cols="${COLUMNS:-}"

  # Fallback if COLUMNS is empty, unset, or weird.
  if ! [[ "$cols" == <-> ]] || (( cols <= 0 )); then
    cols="$(command tput cols 2>/dev/null || print -r -- 80)"
  fi

  # Final fallback.
  if ! [[ "$cols" == <-> ]] || (( cols <= 0 )); then
    cols=80
  fi

  print -r -- "$cols"
}

# fastfetch
unalias fastfetch 2>/dev/null

fastfetch() {
      emulate -L zsh

  local config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
  local full="$config_home/fastfetch/config.jsonc"
  local compact="$config_home/fastfetch/compact.jsonc"

  local cols
  cols="$(_ff_terminal_cols)"

  # Tune this number for your full config.
  local full_min_cols=70

  if (( cols >= full_min_cols )) && [[ -r "$full" ]]; then
    command fastfetch --config "$full"
  elif [[ -r "$compact" ]]; then
    command fastfetch --config "$compact"
  else
    command fastfetch
  fi

}

ff() {
  fastfetch "$@"
}
