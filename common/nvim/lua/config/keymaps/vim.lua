-- Better navigation for wrapped lines
vim.keymap.set('n', 'j', 'gj', { desc = "Move down by a visual line" })
vim.keymap.set('n', 'k', 'gk', { desc = "Move up by a visual line" })
vim.keymap.set('n', '0', 'g0', { desc = "Move to beginning of a visual line" })
vim.keymap.set('n', '$', 'g$', { desc = "Move to end of a visual line" })

-- Move line up or down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line upwards" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line downwards" })

-- Keeps cursor in the same place when appending line below
vim.keymap.set("n", "J", "mzJ`z", { desc = "Keep cursor in same place when appending line below"})

-- Keep cursor in same position when scrolling
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Keep cursor centered when scrolling up"})
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Keep cursor centered when scrolling down"})

-- keep cursor in middle while searching
vim.keymap.set("n", "n", "nzzzv", { desc = "Keep cursor in middle while searching next"})
vim.keymap.set("n", "N", "Nzzzv", { desc = "Keep cursor in middle while searching previous"})

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste without replacing register" })

-- more deletion stuff
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copying" })

-- next greates remaps ever!!!
-- allows you to yank into system clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "yank motion to system clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "yank selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "yank whole line to system clipboard" })

-- chmod
vim.keymap.set("n", "<leader>ex", function()
    local file = vim.fn.expand("%:p")
    vim.cmd("!chmod +x " .. vim.fn.shellescape(file))
    print("Made " .. file .. " executable")
end,
    { desc = "Make current file executable" })

-- buffer navigation
vim.keymap.set('n', '<leader>bn', ':bnext<CR>')
vim.keymap.set('n', '<leader>bp', ':bprev<CR>')
vim.keymap.set('n', '<leader>bf', ':Telescope buffers<CR>')

-- Windows {{{

-- Window navigation
vim.keymap.set('n', '<leader>wh', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<leader>wj', '<C-w>j', { desc = 'Move to below window' })
vim.keymap.set('n', '<leader>wk', '<C-w>k', { desc = 'Move to above window' })
vim.keymap.set('n', '<leader>wl', '<C-w>l', { desc = 'Move to right window' })

-- Close current window
vim.keymap.set('n', '<leader>wc', '<C-w>c', { desc = 'Close window' })

-- Equalize split sizes
vim.keymap.set('n', '<leader>w=', '<C-w>=', { desc = 'Equalize splits' })

-- Rotate layout
vim.keymap.set('n', '<leader>wr', '<C-w>r', { desc = 'Rotate windows' })

-- Switch to last accessed window
vim.keymap.set('n', '<leader>wp', '<C-w>p', { desc = 'Previous window' })

-- }}}

-- quality of life {{{
vim.keymap.set("n", "<leader>==", function()
    local curpos = vim.fn.getpos(".")         -- Save current cursor position
    vim.cmd("keepjumps normal! gg=G")         -- Indent entire file without jumping
    vim.fn.setpos(".", curpos)                -- Restore cursor position
end, { desc = "Auto-align whole file" })

vim.keymap.set('n', '<leader>wso', function()
  vim.cmd('write')
  local ft = vim.bo.filetype
  if ft == 'lua' or ft == 'vim' then
    vim.cmd('source %')
  else
    print("File not sourced: not a config file")
  end
end, { desc = "Write and source if Lua/Vim file" })

-- }}}
