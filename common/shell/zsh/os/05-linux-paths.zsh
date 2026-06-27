# Linux-specific PATH/bootstrap

# Official Neovim binary, if installed there
if [[ -d /opt/nvim-linux-x86_64/bin ]]; then
  path=("/opt/nvim-linux-x86_64/bin" $path)
fi

# Linuxbrew, if present
if [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

export PATH
