--- folds
vim.opt.foldmethod = "marker"
vim.opt.foldmarker = "{{{,}}}"
vim.opt.foldenable = true

-- Do not force all folds open every time a file is opened
vim.opt.foldlevelstart = -1

vim.opt.viewoptions = {
    "folds",
    "cursor",
}

local fold_view_group = vim.api.nvim_create_augroup("remember_folds", { clear = true })

vim.api.nvim_create_autocmd("BufWinLeave", {
    group = fold_view_group,
    pattern = "*",
    callback = function(args)
        if vim.bo[args.buf].buftype == "" then
            vim.cmd("silent! mkview")
        end
    end,
})

vim.api.nvim_create_autocmd("BufWinEnter", {
    group = fold_view_group,
    pattern = "*",
    callback = function(args)
        if vim.bo[args.buf].buftype == "" then
            vim.cmd("silent! loadview")
        end
    end,
})

