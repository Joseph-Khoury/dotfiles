require("config.autocmds.folds")

-- Stop continuing comments on newline
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function ()
        vim.opt_local.formatoptions:remove({ "r", "o" })
    end,
})
