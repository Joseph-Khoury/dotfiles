return {
    {
        "nvim-treesitter/nvim-treesitter",

        -- Tree-sitter must be available before opening normal buffers.
        lazy = false,

        -- Keep installed parsers compatible with the plugin queries.
        build = ":TSUpdate",

        config = function()
            local treesitter = require("nvim-treesitter")

            treesitter.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            -- -- Asynchronous and a no-op for parsers already installed.
            -- treesitter.install(parsers)

            local group = vim.api.nvim_create_augroup(
                "user_treesitter",
                { clear = true }
            )

            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = "*",

                callback = function(args)
                    local filetype = vim.bo[args.buf].filetype

                    -- Let VimTeX own LaTeX syntax highlighting. Its syntax
                    -- engine supports VimTeX features such as conceal and
                    -- syntax-based math-zone detection.
                    if vim.tbl_contains(
                        { "tex", "plaintex", "latex" },
                        filetype
                    ) then
                    return
                end

                -- Silently do nothing when no parser exists for a
                -- particular filetype.
                pcall(vim.treesitter.start, args.buf)
            end,
        })
    end,
},
}
