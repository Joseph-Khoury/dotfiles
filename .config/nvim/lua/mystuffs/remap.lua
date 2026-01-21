vim.g.mapleader= " "
vim.keymap.set("n", "<leader>pv", '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle File Tree' })

-- Telescope keybinds ##################################################################
local builtin = require('telescope.builtin')
vim.keymap.set("n", '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })
-- vim.keymap.set("n", '<C-p>', builtin.git_files, { desc = 'Telescope find files in git' })
vim.keymap.set("n", '<leader>ps', builtin.live_grep, { desc = 'Telescope live grep' })

-- Neoclip keybinds ###################################################################
vim.keymap.set("n", '<leader>cp', "<cmd>Telescope neoclip<CR>", { desc = 'Clipboard' })

-- Harpoon keybinds ##################################################################
local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon file" }) -- Add a file to the list
vim.keymap.set("n", "<leader>hf", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open harpoon menu" }) -- open file menu

vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Previous harpoon" })
vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Previous harpoon" })

-- cmp toggle ##################################################################
local cmp_toggle = require("mystuffs.cmp_toggle")
vim.keymap.set("n", "<C-k>", cmp_toggle.toggle, {desc = "Toggle cmp autocompletion" })

-- vim remaps ##################################################################
-- move commands
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z") -- Keeps cursor in the same place when appending line below

-- Keep cursor in same position when scrolling
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")

-- keep cursor in middle while searching
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", "\"_dP")

-- more deletion stuff
vim.keymap.set("n", "<leader>d", "\"d")
vim.keymap.set("v", "<leader>d", "\"d")

-- next greates remaps ever!!!
-- allows you to yank into system clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- chmod
vim.keymap.set("n", "<leader>ex", function()
    local file = vim.fn.expand("%:p")
    vim.cmd("!chmod +x " .. vim.fn.shellescape(file))
    print("Made " .. file .. " executable")
end, { desc = "Make current file executable" })


-- buffer navigation
vim.keymap.set('n', '<leader>bn', ':bnext<CR>')
vim.keymap.set('n', '<leader>bp', ':bprev<CR>')
vim.keymap.set('n', '<leader>bb', ':Telescope buffers<CR>')


-- file execution
-- local file_execution = require("mystuffs.file_execution")
-- vim.keymap.set("n", "<leader>rn", file_execution.run_code, { desc = "Execute the current file via a console command" })

-- toggleterm ################################################################## 
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggles the term" })
-- vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })
vim.cmd([[tnoremap <Esc> <C-\><C-n>]])


vim.keymap.set('n', '<leader>wso', function()
  vim.cmd('write')
  local ft = vim.bo.filetype
  if ft == 'lua' or ft == 'vim' then
    vim.cmd('source %')
  else
    print("File not sourced: not a config file")
  end
end, { desc = "Write and source if Lua/Vim file" })
vim.keymap.set("n", "<leader>rn", function()
    require("toggleterm.terminal").Terminal:new({
        cmd = "python3 " .. vim.fn.expand("%"),
        direction = "float",
        close_on_exit = false,
    }):toggle()
end, { desc = "Run Python in float terminal" })
-- local lazygit = require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
-- vim.keymap.set("n", "<leader>gt", function() lazygit:toggle() end)

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

-- quality of life ################################################################## 
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

-- new line in normal mode
vim.keymap.set('n', '<CR>', 'm`o<Esc>``', { desc = "Enter newline below cursor in normal mode" })
vim.keymap.set('n', '<S-CR>', 'm`O<Esc>``', { desc = "Enter newline below cursor in normal mode" })
