# Linux-specific aliases

if (( $+commands[xclip] )); then
  alias copy='xclip -selection clipboard'
elif (( $+commands[wl-copy] )); then
  alias copy='wl-copy'
fi
