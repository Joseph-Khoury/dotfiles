# Brew path
if [ -x /opt/homebrew/bin/brew ]; then
    # arm64
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    # x86
    eval "$(/usr/local/bin/brew shellenv)"
fi

# # compinit insecure directory fix
# for file in $(compaudit); do
#   sudo chmod 755 $file
#   sudo chmod 755 $(dirname $file)
#   sudo chown $(whoami) $file
# done

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/joe8922/.cache/lm-studio/bin"

export PATH=$PATH:$HOME/go/bin

export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# <<< Lazy-load conda <<<
# source ~/.zsh_addons/lazy_load_conda.zsh

# <<< Language settings <<<
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export PATH="/Library/TeX/texbin:$PATH"

# <<<<<<<<<<<<<<<<<<<< aliases <<<<<<<<<<<<<<<<<<<<
alias dir=ls
alias ls='ls -a'
alias vim=nvim
alias nv=neovide
alias workspace='cd ~/Workspace/;nvim .'
alias inbox='cd ~/Workspace/00_INBOX/;nvim .'
alias vim_config='cd ~/.dotfiles/.config/nvim/;nvim .'
alias hammerspoon_config='cd ~/.dotfiles/.hammerspoon/;nvim .'
alias aerospace_config='cd ~/.dotfiles/.config/aerospace/;nvim aerospace.toml'
alias alacritty_config='cd ~/.dotfiles/.config/alacritty/;nvim alacritty.toml'
alias df="cd ~/.dotfiles/;nvim ."
alias dff="cd ~/.dotfiles/"
alias memorycheck="source ~/bin/memorycheck.sh"

# <<<<<<<<<<<<<<<<<<<< add-ons <<<<<<<<<<<<<<<<<<<<
# zsh-completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit && compinit
fi
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
# load fzf-tab
source ~/.zsh_addons/fzf-tab/fzf-tab.plugin.zsh
# load fzf-tab config
source ~/.zsh_addons/fzf-tab/config.zsh

# <<< these addons need to be loaded last <<<
#
# zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# zsh-syntax highlighting
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Theme
source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme # powerlevel10k


# <<< Display cool stuff <<<
# only when SKIP_NEOFECH is undefined, in an interactive window and not in a tmux env
if [[ -z "$SKIP_NEOFETCH" && -z "$TMUX" && -o interactive ]]; then
    neofetch
fi
# neofetch

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

ff() {
    aerospace list-windows --all | \
        fzf --bind 'enter:execute(aerospace focus --window-id {1})+abort'
    }

# alias rosetta="arch -x86_64 zsh" # chatGPT is actually retarded

ltspice() {
    export WINEPREFIX=~/wineprefixes/ltspice
    nohup wine "$WINEPREFIX/drive_c/Program Files/ADI/LTspice/LTspice.exe" &>/dev/null &
    disown
}
# steam() {
#     export WINEPREFIX=~/wineprefixes/steam
#     nohup wine "$WINEPREFIX/drive_c/Program Files (x86)/Steam/steam.exe" &>/dev/null &
#     disown
# }
