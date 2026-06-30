# Common aliases

# Basic
alias cls='clear'
alias vim='nvim'
alias zreload='source ~/.zshrc'

# Safer defaults
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Dotfiles and config
alias dot='cd ~/.dotfiles && nvim .'
alias dots='cd ~/.dotfiles'
alias zconf='nvim ~/.zshrc'
alias zdir='cd ~/.dotfiles/common/shell/zsh && nvim .'
alias ndir='cd ~/.dotfiles/common/nvim && nvim .'

# Directories
alias clouddir='cd /mnt/c/Users/joe89/Nextcloud/'
alias cloud='clouddir && nvim .'
alias clddir='clouddir'
alias cld='cloud'

# CLI apps
# if (( $+commands[fastfetch] )); then
#   alias fastfetch='fastfetch --config "$FASTFETCH_CONFIG"'
# fi

if (( $+commands[eza] )); then
  alias ls='eza --icons=auto --group-directories-first'
  alias ll='eza -lah --icons=auto --group-directories-first --git'
  alias la='eza -a --icons=auto --group-directories-first'
  alias tree='eza --tree --icons=auto --group-directories-first'
else
  alias ll='ls -lah'
  alias la='ls -a'
  alias l='ls -CF'
fi

if (( $+commands[zoxide] )); then
    alias cd='z'
fi

if (( $+commands[bat] )); then
  alias cat='bat'
  alias b='bat'
elif (( $+commands[batcat] )); then
  alias cat='batcat'
  alias b='batcat'
fi

# Git shortcuts
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
