require("config.neovide").setup()

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

require("config.lazy")
require("mystuffs")

-- Add line numbers and relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true


-- Text wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪ "
vim.opt.textwidth = 0

-- Better navigation for wrapped lines
vim.keymap.set('n', 'j', 'gj')  -- Move down by visual line
vim.keymap.set('n', 'k', 'gk')  -- Move up by visual line
vim.keymap.set('n', '0', 'g0')  -- Go to beginning of visual line
vim.keymap.set('n', '$', 'g$')  -- Go to end of visual line

-- -- Auto-wrap for LaTeX files
-- vim.api.nvim_create_autocmd("FileType", {
--     pattern = "tex",
--     callback = function()
--         vim.opt_local.wrap = true
--         vim.opt_local.linebreak = true
--         vim.opt_local.spell = true
--         vim.opt_local.spelllang = "en_us"
--     end,
-- })

-- define tabs in terms of spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- smart indenting
vim.opt.smartindent = true

-- I use a lot multiple windows and git, so I don't want a swap file
-- instead undo directories so that I can manage undoes from days and days ago
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.nvim/undodir"

vim.opt.hlsearch = false -- Don't keep the search items highlighted
vim.opt.incsearch = true -- Starts the search before pressing enter

vim.opt.termguicolors = true

vim.opt.scrolloff = 8 -- As you scroll, you won't have <8 lines from edges of screen
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@") --???

vim.opt.updatetime = 50 -- fast updatetime

vim.opt.colorcolumn = "80" -- falsecolor column reminding you of the 80 character limit

-- diagnostic signs
local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn",  text = "" },
    { name = "DiagnosticSignHint",  text = "" },
    { name = "DiagnosticSignInfo",  text = "" },
}

for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.name, numhl = "" })
end

-- configure diagnostic display
vim.diagnostic.config({
    virtual_text = {
        prefix = '●',
        spacing = 4,
    },
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})

-- Python venv
local function set_python_host()
  local venv = vim.fn.getcwd() .. '/.venv/bin/python'
  if vim.fn.executable(venv) == 1 then
    vim.g.python3_host_prog = venv
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = set_python_host,
})
