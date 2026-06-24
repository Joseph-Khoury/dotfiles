-- Extract the keymaps for the obsidian database
vim.api.nvim_create_user_command("ExportKeymaps", function()
  require("tools.export_keymaps").export("~/.dotfiles/common/keybinds/generated/nvim.jsonl")
end, {})
