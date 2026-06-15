return {
  'akinsho/toggleterm.nvim',
  version = "*",
  config = function()
    require("toggleterm").setup({
      direction = 'float', -- or "horizontal", "vertical", "tab"
      open_mapping = [[<c-\>]], -- default toggle
      shade_terminals = true,
      start_in_insert = true,
    })
  end
}

