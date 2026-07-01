# WSL-specific aliases

alias explorer='explorer.exe'
alias openhere='explorer.exe .'
alias copy='clip.exe'
alias neovide='/mnt/c/Program\ Files/Neovide/neovide.exe --wsl'
alias nv='neovide'
alias psdots='cd /mnt/c/Users/joe89/.dotfiles'
alias psdot='psdots && nvim .'

if [[ -d /mnt/c/Users ]]; then
  alias cusers='cd /mnt/c/Users'
fi
