local map = vim.keymap.set

-- #1 NvimTree {{{

map("n", "<leader>pv", '<cmd>NvimTreeToggle<CR>', { desc = "Toggle File Tree" })

-- }}}

-- #2 Telescope {{{

local builtin = require('telescope.builtin')

-- Find files
map("n", '<leader>pf', builtin.find_files, { desc = 'Telescope find files' })

-- Find files (Git)
map("n", '<C-p>', builtin.git_files, { desc = 'Telescope find files in git' })

-- Search within file content
map("n", '<leader>ps', builtin.live_grep, { desc = 'Telescope live grep' })

-- }}}

-- #3 harpoon {{{

local harpoon = require("harpoon")
harpoon:setup() --[[ Required ]]

-- Add current buffer to harpoon 
map("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon file" })

-- Open harpoon menu
map("n", "<leader>hf", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Open harpoon menu" })

-- Go to specific harpoon
map("n", "<leader>h1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
map("n", "<leader>h2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
map("n", "<leader>h3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
map("n", "<leader>h4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })

-- Toggle previous & next buffers stored within Harpoon list
map("n", "<leader>hp", function() harpoon:list():prev() end, { desc = "Previous harpoon" })
map("n", "<leader>hn", function() harpoon:list():next() end, { desc = "Previous harpoon" })

-- }}}

-- #4 neoclip {{{

map("n", '<leader>cp', "<cmd>Telescope neoclip<CR>", { desc = 'Telescope clipboard' })

-- }}}

-- #5 Toggle term {{{

-- Toggle the terminal 
map("n", "<leader>tt", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggles the term" })
-- map("n", "<leader>th", "<cmd>ToggleTerm direction=horizontal<CR>", { desc = "Toggle horizontal terminal" })
map("n", "<leader>tv", "<cmd>ToggleTerm direction=vertical<CR>", { desc = "Toggle vertical terminal" })
vim.cmd([[tnoremap <Esc> <C-\><C-n>]])

map("n", "<leader>rn", function()
    require("toggleterm.terminal").Terminal:new({
        cmd = "python3 " .. vim.fn.expand("%"),
        direction = "float",
        close_on_exit = false,
    }):toggle()
end, { desc = "Run Python in float terminal" })

-- }}}

-- #6 LazyGit {{{
local lazygit = require("toggleterm.terminal").Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })
map("n", "<leader>gt", function() lazygit:toggle() end)

-- }}}
