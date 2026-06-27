local severity = vim.diagnostic.severity

vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 2,
    },

    signs = {
        text = {
            [severity.ERROR] = "",
            [severity.WARN] = "",
            [severity.INFO] = "",
            [severity.HINT] = "",
        },
    },

    underline = true,
    update_in_insert = false,
    severity_sort = true,

    float = {
        border = "rounded",
        source = "if_many",
        header = "",
        prefix = "",
    },
})
