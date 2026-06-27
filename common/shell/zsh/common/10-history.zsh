# Zsh history

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"

HISTSIZE=50000
SAVEHIST=50000

setopt append_history
setopt inc_append_history
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_reduce_blanks
setopt hist_verify
