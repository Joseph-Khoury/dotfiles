# Startup commands

# Do not run fastfetch inside a Neovim terminal.
if [[ -o interactive ]] && [[ -z "$NVIM" ]] && (( $+commands[fastfetch] )); then
  command fastfetch --config "$FASTFETCH_CONFIG"
fi
