# macOS-specific PATH/bootstrap

# Homebrew Apple Silicon
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Homebrew Intel fallback
if [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH
