# WSL-specific aliases

alias explorer='explorer.exe'
alias openhere='explorer.exe .'
alias copy='clip.exe'
alias neovide='/mnt/c/Program\ Files/Neovide/neovide.exe --wsl'
alias nv='neovide'

if [[ -d /mnt/c/Users ]]; then
  alias cusers='cd /mnt/c/Users'
fi
