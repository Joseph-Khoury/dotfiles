# Oh My Zsh and plugin setup

ZSH_THEME="powerlevel10k/powerlevel10k"

# Oh My Zsh update behavior
zstyle ':omz:update' mode reminder

# Show waiting dots during slow completions
COMPLETION_WAITING_DOTS="true"

# Oh My Zsh plugins
# Keep zsh-syntax-highlighting last.
plugins=(
  git
  fzf
  fzf-tab
  colored-man-pages
  command-not-found
  zsh-autosuggestions
  zsh-syntax-highlighting
)

if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  print -P "%F{yellow}Warning:%f Oh My Zsh not found at $ZSH"
fi
