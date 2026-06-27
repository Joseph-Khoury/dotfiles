-- Language Server Protocol
-- Neovim 0.12-style setup: vim.lsp.config() + Mason auto-enable.
return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        "mason-org/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "barreiroleo/ltex_extra.nvim",
        { "folke/trouble.nvim", opts = {}, cmd = "Trouble" },
    },
    config = function()
        local os = require("utils.os")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        vim.lsp.config("lua_ls", {
            settings = {
                Lua = {
                    runtime = {
                        version = "LuaJIT",
                    },
                    diagnostics = {
                        globals = {
                            "vim",
                            "hs",
                            "spoon",
                        },
                    },
                    workspace = {
                        checkThirdParty = false,
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })

        vim.lsp.config("pyright", {
            settings = {
                python = {
                    analysis = {
                        typeCheckingMode = "basic",
                        autoSearchPaths = true,
                        useLibraryCodeForTypes = true,
                    },
                },
            },
        })

        vim.lsp.config("texlab", {
            settings = {
                texlab = {
                    build = {
                        executable = "latexmk",
                        args = {
                            "-pdf",
                            "-interaction=nonstopmode",
                            "-synctex=1",
                            "%f",
                        },
                        onSave = false,
                    },
                    forwardSearch = {
                        executable = os.is_macos and "displayline" or nil,
                    },
                },
            },
        })

        vim.lsp.config("ltex_plus", {
            settings = {
                ltex = {
                    language = "en-US",
                    enabled = {
                        "bibtex",
                        "context",
                        "context.tex",
                        "html",
                        "latex",
                        "markdown",
                        "org",
                        "restructuredtext",
                        "tex",
                    },
                },
            },
        })

        vim.lsp.config("verible", {})
        vim.lsp.config("vhdl_ls", {})

        require("mason-lspconfig").setup({
            ensure_installed = {
                -- Neovim / configuration
                "lua_ls",
                "bashls",
                "taplo",

                -- Programming
                "pyright",
                "rust_analyzer",

                -- Academic writing
                "texlab",
                "ltex_plus",

                -- HDL / time-tagging project
                "verible",
                "vhdl_ls",
            },
            automatic_enable = true,
        })

        local ltex_extra_initialized = false
        local group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = group,
            callback = function(event)
                local client = vim.lsp.get_client_by_id(event.data.client_id)

                local function map(mode, lhs, rhs, desc)
                    vim.keymap.set(mode, lhs, rhs, {
                        buffer = event.buf,
                        silent = true,
                        desc = desc,
                    })
                end

                -- Keep your familiar mappings for now, but also expose a clearer <leader>l namespace.
                map("n", "gd", vim.lsp.buf.definition, "LSP: go to definition")
                map("n", "gD", vim.lsp.buf.declaration, "LSP: go to declaration")
                map("n", "K", vim.lsp.buf.hover, "LSP: hover")
                map("i", "<C-h>", vim.lsp.buf.signature_help, "LSP: signature help")

                map("n", "<leader>vrn", vim.lsp.buf.rename, "LSP: rename symbol")
                map("n", "<leader>vca", vim.lsp.buf.code_action, "LSP: code action")
                map("n", "<leader>vrr", vim.lsp.buf.references, "LSP: references")
                map("n", "<leader>vws", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "LSP: workspace symbols")

                map("n", "<leader>lr", vim.lsp.buf.rename, "LSP: rename symbol")
                map("n", "<leader>la", vim.lsp.buf.code_action, "LSP: code action")
                map("n", "<leader>lR", vim.lsp.buf.references, "LSP: references")
                map("n", "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", "LSP: document symbols")
                map("n", "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "LSP: workspace symbols")

                map("n", "<leader>kd", vim.diagnostic.open_float, "Diagnostics: current position")
                map("n", "<leader>ld", vim.diagnostic.open_float, "Diagnostics: current position")
                map("n", "[d", function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end, "Diagnostics: previous")
                map("n", "]d", function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end, "Diagnostics: next")
                map("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", "Diagnostics: Trouble")
                map("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", "Diagnostics: buffer Trouble")

                if client and client.name == "ltex_plus" and not ltex_extra_initialized then
                    require("ltex_extra").setup({
                        load_langs = { "en-US" },
                        init_check = true,
                        path = vim.fn.stdpath("config") .. "/spell",
                        log_level = "warn",
                    })
                    ltex_extra_initialized = true
                end
            end,
        })
    end,
}
