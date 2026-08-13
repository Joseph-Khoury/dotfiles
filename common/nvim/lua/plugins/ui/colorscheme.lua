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
                flavour = "macchiato", -- latte, frappe, macchiato, mocha
                background = { -- :h background
                    light = "latte",
                    dark = "macchiato",
                },
                transparent_background = not vim.g.neovide
            })
            -- setup must be called before loading
            vim.cmd.colorscheme "catppuccin"

            local bg = "none"

            if vim.g.neovide then
                local colors = require("catppuccin.palettes").get_palette(
                    "macchiato")
                bg = colors.base
            end

            for _, group in ipairs({
                -- General background
                "Normal",
                "NormalFloat",
                "NormalNC",

                -- nvim-tree background
                "NvimTreeNormal",
                "NvimTreeNormalNC",
                "NvimTreeEndOfBuffer",
                "NvimTreeWinSeparator",
            }) do
                vim.api.nvim_set_hl(0, group, { bg = bg, })
            end
        end,
    },
}

            -- -- General transparency
            -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
            -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
            -- vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
            --
            -- -- nvim-tree transparency
            -- vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
            -- vim.api.nvim_set_hl(0, "NvimTreeNormalNC", { bg = "none" })
            -- vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })
            -- vim.api.nvim_set_hl(0, "NvimTreeWinSeparator", { bg = "none" })
