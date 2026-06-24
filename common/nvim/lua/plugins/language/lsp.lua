-- Language Server Protocol
return {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        'mason-org/mason.nvim',
        'mason-org/mason-lspconfig.nvim',
        "barreiroleo/ltex_extra.nvim",
    },
    config = function()
        local ensure_installed = {
            "pyright", -- .py
            "bashls", -- .zsh/.sh
            "lua_ls", -- .lua
            "texlab", -- .tex
            "ltex", -- .tex
            "rust_analyzer",
            "taplo",
        }

        local lspconfig = require("lspconfig")
        local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = ensure_installed,
            handlers = {
                ["lua_ls"] = function ()
                    lspconfig.lua_ls.setup({
                        settings = {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT', -- used by neovim
                                    path = vim.split(package.path, ';'),
                                },
                                diagnostics = {
                                    globals = {
                                        "hs", "spoon", -- hammerspoon
                                    },
                                },
                                workspace = {
                                    library = {
                                        vim.env.VIMRUNTIME,
                                        vim.fn.stdpath("config"),
                                        vim.fn.expand("~/.dotfiles"),
                                    },
                                    checkThirdParty = false,
                                },
                                telemetry = { enable = false },
                            },
                        },
                    })
                end,
                ["ltex"] = function()
                    lspconfig.ltex.setup({
                        capabilities = default_capabilities,
                        settings = {
                            ltex = {
                                language = "en-US",
                                -- Your other ltex settings
                            },
                        },
                    })
                end,
                ["pyright"] = function()
                    lspconfig.pyright.setup({
                        settings = {
                            python = {
                                venvPath = ".venv",
                                pythonPath = "./.venv/bin/python",
                            },
                        },
                    })
                end,
            },
        })

        -- Separate LspAttach autocmd for ltex_extra
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.name == "ltex" then
                    require("ltex_extra").setup({
                        load_langs = { "en-US" },
                        init_check = true,
                        path = vim.fn.stdpath("config") .. "/spell",
                        log_level = "warn",
                    })
                end
            end
        })

        -- Optional: LSP keybindings
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(ev)
                local opts = { buffer = ev.buf }
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts) -- Native vim highlighting
                -- vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<cr>", opts) -- Using Telescope
                vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- mimicks putting your mouse cursor to see what something is
                vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts) -- rename a symbol
                vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts) -- this is doing the recommended smart suggestion
                vim.keymap.set("n", "<leader>vws", require("telescope.builtin").lsp_workspace_symbols, opts)
                vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
                vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

                -- diagnostic stuff
                vim.keymap.set("n", "<leader>kd", vim.diagnostic.open_float,  opts) -- opens the diagnostic for an error or warning etc.
                vim.keymap.set("n", "[d", function() vim.diagnostic.jump({count=-1,float=true}) end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.jump({count=1,float=true}) end, opts)
            end
        })
    end
}
