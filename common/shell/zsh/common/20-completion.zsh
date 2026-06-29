# Completion setup
# This is loaded before Oh My Zsh, because Oh My Zsh runs compinit.
mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${HOST}-${ZSH_VERSION}"

# zsh-completions, installed manually into OMZ custom plugins
if [[ -d "$ZSH_CUSTOM/plugins/zsh-completions/src" ]]; then
  fpath=("$ZSH_CUSTOM/plugins/zsh-completions/src" $fpath)
fi

# Debian/Ubuntu/WSL completion locations
for dir in /usr/share/zsh/vendor-completions /usr/share/zsh/site-functions; do
  [[ -d "$dir" ]] && fpath=("$dir" $fpath)
done

# Homebrew completions. Works on macOS and Linuxbrew after brew shellenv has run.
if command -v brew >/dev/null 2>&1; then
  brew_prefix="$(brew --prefix 2>/dev/null)"
  if [[ -n "$brew_prefix" && -d "$brew_prefix/share/zsh/site-functions" ]]; then
    fpath=("$brew_prefix/share/zsh/site-functions" $fpath)
  fi
  unset brew_prefix
fi

# Completion behavior
zstyle ':completion:*' menu no
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Case-insensitive and hyphen/underscore-tolerant completion
zstyle ':completion:*' matcher-list \
  'm:{a-zA-Z}={A-Za-z}' \
  'r:|[._-]=* r:|=*'
