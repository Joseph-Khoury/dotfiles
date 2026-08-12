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

-- paste from system clipboard
map("n", "<leader>p", "\"+p", { desc = "past motion from system clipboard" })
map("v", "<leader>p", "\"+p", { desc = "past selection from system clipboard" })
map("n", "<leader>P", "\"+P", { desc = "past whole line from system clipboard" })

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

-------------------------------------------------------------------------------
-- nvim windows (not the OS) {{{
-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------
-- quality of life {{{
-------------------------------------------------------------------------------

-- auto-align 
map("n", "<leader>aa", function()
    local curpos = vim.fn.getpos(".")         -- Save current cursor position
    vim.cmd("keepjumps normal! gg=G")         -- Indent entire file without jumping
    vim.fn.setpos(".", curpos)                -- Restore cursor position
end, { desc = "Auto-align whole file" })


local function align_equals() -- {{{
    local mark1 = vim.fn.getpos("v")[2]
    local mark2 = vim.fn.getpos(".")[2]

    local first = math.min(mark1, mark2)
    local last = math.max(mark1, mark2)

    local lines = vim.api.nvim_buf_get_lines(
        0,
        first - 1,
        last,
        false
    )

    local max_width = 0

    for _, line in ipairs(lines) do
        local lhs = line:match("^(.-)%s+=%s*[^=]")

        if lhs and not lhs:match("[!<>]$") then
            lhs = lhs:gsub("%s+$", "")
            max_width = math.max(
                max_width,
                vim.fn.strdisplaywidth(lhs)
            )
        end
    end

    for i, line in ipairs(lines) do
        local lhs, rhs = line:match("^(.-)%s+=%s*(.*)$")

        if lhs and not lhs:match("[!<>=]$") then
            lhs = lhs:gsub("%s+$", "")

            local padding = string.rep(
                " ",
                max_width - vim.fn.strdisplaywidth(lhs) + 1
            )

            lines[i] = lhs .. padding .. "= " .. rhs
        end
    end

    vim.api.nvim_buf_set_lines(
        0,
        first - 1,
        last,
        false,
        lines
    )
end -- }}}

-- Align equals signs in visual selection
map("v", "<leader>a=", align_equals, {
    desc = "Align equals in selection",
})

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
