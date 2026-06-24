local map = vim.keymap.set

-- Better navigation for wrapped lines
map('n', 'j', 'gj', { desc = "Move down by a visual line" })
map('n', 'k', 'gk', { desc = "Move up by a visual line" })
map('n', '0', 'g0', { desc = "Move to beginning of a visual line" })
map('n', '$', 'g$', { desc = "Move to end of a visual line" })

-- Move line up or down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected line upwards" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected line downwards" })

-- Keeps cursor in the same place when appending line below
map("n", "J", "mzJ`z", { desc = "Keep cursor in same place when appending line below"})

-- Keep cursor in same position when scrolling
map("n", "<C-u>", "<C-u>zz", { desc = "Keep cursor centered when scrolling up"})
map("n", "<C-d>", "<C-d>zz", { desc = "Keep cursor centered when scrolling down"})

-- keep cursor in middle while searching
map("n", "n", "nzzzv", { desc = "Keep cursor in middle while searching next"})
map("n", "N", "Nzzzv", { desc = "Keep cursor in middle while searching previous"})

-- greatest remap ever
map("x", "<leader>p", [["_dP]], { desc = "Paste without replacing register" })

-- more deletion stuff
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Delete without copying" })

-- next greates remaps ever!!!
-- allows you to yank into system clipboard
map("n", "<leader>y", "\"+y", { desc = "yank motion to system clipboard" })
map("v", "<leader>y", "\"+y", { desc = "yank selection to system clipboard" })
map("n", "<leader>Y", "\"+Y", { desc = "yank whole line to system clipboard" })

-- chmod
map("n", "<leader>ex", function()
    local file = vim.fn.expand("%:p")
    vim.cmd("!chmod +x " .. vim.fn.shellescape(file))
    print("Made " .. file .. " executable")
end,
    { desc = "Make current file executable" })

-- buffer navigation
map('n', '<leader>bn', ':bnext<CR>')
map('n', '<leader>bp', ':bprev<CR>')
map('n', '<leader>bf', ':Telescope buffers<CR>')

-- Windows {{{

-- Window navigation
map('n', '<leader>wh', '<C-w>h', { desc = 'Move to left window' })
map('n', '<leader>wj', '<C-w>j', { desc = 'Move to below window' })
map('n', '<leader>wk', '<C-w>k', { desc = 'Move to above window' })
map('n', '<leader>wl', '<C-w>l', { desc = 'Move to right window' })

-- Close current window
map('n', '<leader>wc', '<C-w>c', { desc = 'Close window' })

-- Equalize split sizes
map('n', '<leader>w=', '<C-w>=', { desc = 'Equalize splits' })

-- Rotate layout
map('n', '<leader>wr', '<C-w>r', { desc = 'Rotate windows' })

-- Switch to last accessed window
map('n', '<leader>wp', '<C-w>p', { desc = 'Previous window' })

-- }}}

-- quality of life {{{

-- auto-align
map("n", "<leader>==", function()
    local curpos = vim.fn.getpos(".")         -- Save current cursor position
    vim.cmd("keepjumps normal! gg=G")         -- Indent entire file without jumping
    vim.fn.setpos(".", curpos)                -- Restore cursor position
end, { desc = "Auto-align whole file" })

-- write and source config
map('n', '<leader>wso', function()
  vim.cmd('write')
  local ft = vim.bo.filetype
  if ft == 'lua' or ft == 'vim' then
    vim.cmd('source %')
  else
    print("File not sourced: not a config file")
  end
end, { desc = "Write and source if Lua/Vim file" })

-- new line in normal mode
map('n', '<leader><CR>', 'o<Esc>', { desc = "Insert empty line below" })
map('n', '<leader><s-CR>', 'O<Esc>', { desc = "Insert empty line above" })

-- }}}
