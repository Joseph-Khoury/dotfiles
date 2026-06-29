# Common environment and shell variables

# Deduplicate path-like arrays while preserving order.
typeset -U path fpath

# Common PATH entries
path=(
  "$HOME/.local/bin"
  "$HOME/bin"
  $path
)
export PATH

# Oh My Zsh locations
export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

# Preferred tools
export EDITOR="${EDITOR:-nvim}"
export VISUAL="${VISUAL:-$EDITOR}"
export PAGER="${PAGER:-less}"
export LESS="${LESS:--R -F -X}"

# Global which can be set in OS-specific paths to adjust when fastfetch is compacted
export FASTFETCH_FULL_MIN_COLS="${FASTFETCH_FULL_MIN_COLS:-150}"
