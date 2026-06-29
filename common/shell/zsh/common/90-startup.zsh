# Startup commands
# Anything that prints to the terminal must NOT run directly during zsh init,
# because Powerlevel10k instant prompt will capture it and show a warning.
#
# Instead, run visual startup output once, right before the first real prompt.

autoload -Uz add-zsh-hook

_dotfiles_startup_fastfetch() {
  # Run only once.
  add-zsh-hook -d precmd _dotfiles_startup_fastfetch

  # Interactive shells only.
  [[ -o interactive ]] || return

  # Do not run inside a Neovim terminal.
  [[ -n "$NVIM" ]] && return

  # Manual escape hatch.
  [[ -n "$DOTFILES_NO_FASTFETCH" ]] && return

  # Need fastfetch.
  (( $+commands[fastfetch] )) || return

  # Use our wrapper function from 70-functions.zsh, not `command fastfetch`,
  # so the compact/full layout logic is respected.
  fastfetch
}

add-zsh-hook precmd _dotfiles_startup_fastfetch
