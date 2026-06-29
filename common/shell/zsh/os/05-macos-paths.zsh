# macOS-specific PATH/bootstrap

# Homebrew Apple Silicon
if [[ "$(uname -m)" == "arm64" &&  -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
# Homebrew Intel fallback
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/joe8922/.cache/lm-studio/bin"

# Go
export PATH=$PATH:$HOME/go/bin

# ??
export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="/Library/TeX/texbin:$PATH"

export FASTFETCH_FULL_MIN_COLS=70

path=(
    "$HOME/.cargo/bin"
    $path
)

typeset -U path PATH
export PATH
