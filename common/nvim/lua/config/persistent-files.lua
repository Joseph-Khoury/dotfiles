-- Create swap, backup, and undo directory for persistence.
local state_dir = vim.fn.stdpath("state")
local dirs = {
    swap = state_dir .. "/swap//",
    backup = state_dir .. "/backup//",
    undo = state_dir .. "/undo//",
}

for _, dir in pairs(dirs) do
    vim.fn.mkdir(dir, "p")
end

-- swap files: crash recovery for currently open buffers
vim.opt.swapfile = true
vim.opt.directory = dirs.swap

-- backup files: preserve the previous version when writing
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.backupdir = dirs.backup
vim.opt.backupcopy = "yes" -- safer for symlinks
vim.opt.backupext = "~" --Recognisable backup suffix

-- undo files: preserve recent actions like a git tree for version control
vim.opt.undofile = true
vim.opt.undodir = dirs.undo

-- Exclude sensitive or temporary locations
vim.opt.backupskip = {
    "/tmp/*",
    "/private/tmp/*",
    vim.fn.expand("~/.cache/*"),
    vim.fn.expand("~/.local/share/Trash/*"),
    vim.fn.expand("~/.password-store/*"),
}
