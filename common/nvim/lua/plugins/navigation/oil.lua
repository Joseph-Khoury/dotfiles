-- Preamble {{{
    local detail = false

    -- declare a global function to retrieve the current directory
    function _G.get_oil_winbar()
        local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
        local dir = require("oil").get_current_dir(bufnr)
        if dir then
            return vim.fn.fnamemodify(dir, ":~")
        else
            -- if there is no current directory (e.g. over ssh), just show the buffer name
            return vim.api.nvim_buf_get_name(0)
        end
    end

    -- }}}

return {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@diagnostic disable-next-line: undefined-doc-name
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = {
        { "nvim-mini/mini.icons", opts = {} },
        { "JezerM/oil-lsp-diagnostics.nvim", opts = {} },
        {
            "malewicz1337/oil-git.nvim",
            opts = {
                show_file_highlights = true,
                show_directory_highlights = true,

                show_file_symbols = true,
                show_directory_symbols = true,

                show_ignored_files = false,
                show_ignored_directories = false,

                symbol_position = "eol",
            },

        },
    },
        -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
        config = function ()
            require("oil").setup({
                default_file_explorer = true,
                delete_to_trash = true,
                skip_confirm_for_simple_edits = false,
                view_options = {
                    show_hidden = true,
                    natural_order = true,
                    is_always_hidden = function(name, _)
                        return name == '..' or name == '.git'
                    end,
                },
                win_options = {
                    wrap = true,
                    -- Show CWD in status bar
                    winbar = "%!v:lua.get_oil_winbar()",
                },
                keymaps = {
                    ["gd"] = {
                        desc = "Toggle file detail view",
                        callback = function()
                            detail = not detail
                            if detail then
                                require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
                            else
                                require("oil").set_columns({ "icon" })
                            end
                        end,
                    },
                },
                vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }),
                vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { desc = "Open parent directory in a floating window" }),
            })
        end,
    }
