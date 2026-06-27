-- Add line numbers and relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Text wrapping
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↪ "
vim.opt.textwidth = 0

-- define tabs in terms of spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- smart indenting
vim.opt.smartindent = true

-- search
vim.opt.hlsearch = false -- Don't keep the search items highlighted
vim.opt.incsearch = true -- Starts the search before pressing enter

vim.opt.termguicolors = true

vim.opt.scrolloff = 8 -- As you scroll, you won't have <8 lines from edges of screen
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@") --???

vim.opt.updatetime = 300 -- fast updatetime

vim.opt.colorcolumn = "80" -- falsecolor column reminding you of the 80 character limit


