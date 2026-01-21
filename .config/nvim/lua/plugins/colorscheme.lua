return {
    -- This is where colorschemes go.
    -- Themes can be lazy loaded or on startup with the `lazy` tag.
    -- Main colorscheme needs to have priority 1000

    -- catppuccin
    {
        "catppuccin/nvim",
        name = "catppuccin",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            require("catppuccin").setup({
                flavour = "auto", -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = "latte",
                    dark = "macchiato",
                    transparent_background = true,
                },
            })
            -- setup must be called before loading
            vim.cmd.colorscheme "catppuccin"

            -- General transparency
            vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })

            -- nvim-tree transparency
            vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
            vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
            vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })
            vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "none" })

        end},
}
