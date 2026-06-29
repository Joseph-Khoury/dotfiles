# fzf-tab configuration
# Loaded before Oh My Zsh sources the fzf-tab plugin.

# Use normal fzf even inside tmux. This avoids fzf-tab switching into an
# ugly tmux-specific popup/backend.
zstyle ':fzf-tab:*' fzf-command fzf

# General fzf UI.
# bg:-1/bg+:-1/gutter:-1 keeps the terminal/tmux default background instead
# of forcing a solid fzf background.
zstyle ':fzf-tab:*' fzf-flags \
  '--height=45%' \
  '--layout=reverse' \
  '--border=rounded' \
  '--ansi' \
  '--preview-window=right:60%:wrap' \
  '--color=bg:-1,bg+:-1,gutter:-1'

# Move between completion groups with < and >.
zstyle ':fzf-tab:*' switch-group '<' '>'

# File/directory preview.
# fzf-tab provides $realpath for file-like completions.
zstyle ':fzf-tab:complete:*:*' fzf-preview '
  if [[ -n "$realpath" && -d "$realpath" ]]; then
    if command -v eza >/dev/null 2>&1; then
      eza -1 --color=always --icons=auto --group-directories-first "$realpath"
    else
      command ls -la "$realpath"
    fi

  elif [[ -n "$realpath" && -f "$realpath" ]]; then
    if command -v bat >/dev/null 2>&1; then
      bat --style=numbers --color=always --line-range=:200 "$realpath"
    elif command -v batcat >/dev/null 2>&1; then
      batcat --style=numbers --color=always --line-range=:200 "$realpath"
    else
      sed -n "1,200p" "$realpath"
    fi

  elif [[ -n "$word" ]]; then
    printf "%s\n" "$word"
  fi
'

zstyle ':fzf-tab:*' fzf-flags \
  '--height=45%' \
  '--layout=reverse' \
  '--border=rounded' \
  '--ansi' \
  '--preview-window=right:60%:wrap' \
  '--color=bg:-1,bg+:-1,gutter:-1' \
  '--bind=ctrl-j:preview-down' \
  '--bind=ctrl-k:preview-up' \
  '--bind=ctrl-d:preview-half-page-down' \
  '--bind=ctrl-u:preview-half-page-up' \
  '--bind=ctrl-f:preview-page-down' \
  '--bind=ctrl-b:preview-page-up' \
  '--bind=ctrl-/:toggle-preview'
