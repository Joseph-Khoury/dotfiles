-- #1 NvimTree {{{

vim.keymap.set("n", "<leader>pv", '<cmd>NvimTreeToggle<CR>', { desc = "Toggle File Tree" })

-- }}}

-- #2 Telescope {{{

local builtin = require('telescope.builtin')

-- Find files
vim.keymap.set("n", '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })

-- Find files (Git)
vim.keymap.set("n", '<C-p>', builtin.git_files, { desc = 'Telescope find files in git' })

-- Search within file content
vim.keymap.set("n", '<leader>ps', builtin.live_grep, { desc = 'Telescope live grep' })

-- }}}

-- #3 harpoon {{{

local harpoon = require("harpoon")
harpoon:setup() --[[ Required ]]

-- Add current buffer to harpoon 
vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon file" })

-- Open harpoon menu
vim.keymap.set("n", "<leader>hf", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open harpoon menu" })

-- Go to specific harpoon
vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Previous harpoon" })
vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Previous harpoon" })

-- }}}

-- #4 neoclip {{{

vim.keymap.set("n", '<leader>cp', "<cmd>Telescope neoclip<CR>", { desc = 'Telescope clipboard' })

-- }}}

-- #5 Toggle term {{{

-- Toggle the terminal 
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggles the term" })
-- vim.keymap.set("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
vim.keymap.set("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })
vim.cmd([[tnoremap <Esc> <C-\><C-n>]])

vim.keymap.set("n", "<leader>rn", function()
    require("toggleterm.terminal").Terminal:new({
        cmd = "python3 " .. vim.fn.expand("%"),
        direction = "float",
        close_on_exit = false,
    }):toggle()
end, { desc = "Run Python in float terminal" })

-- }}}

-- #6 LazyGit {{{
local lazygit = require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
vim.keymap.set("n", "<leader>gt", function() lazygit:toggle() end)

-- }}}
