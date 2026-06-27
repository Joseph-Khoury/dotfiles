-- Completion + snippets.
return {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "rafamadriz/friendly-snippets",
        "micangl/cmp-vimtex",
    },
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")
        local types = require("luasnip.util.types")

        luasnip.setup({
            enable_autosnippets = true,
            update_events = { "TextChanged", "TextChangedI" },
            region_check_events = { "CursorMoved", "CursorHold", "InsertEnter" },
            delete_check_events = { "TextChanged", "InsertLeave" },
            ext_opts = {
                [types.insertNode] = {
                    active = {
                        hl_group = "Visual",
                    },
                },
                [types.choiceNode] = {
                    active = {
                        hl_group = "IncSearch",
                        virt_text = {
                            { " choice ", "Comment" },
                        },
                    },
                },
            },
        })

        require("luasnip.loaders.from_vscode").lazy_load()
        require("luasnip.loaders.from_lua").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/luasnippets" },
        })

        cmp.setup({
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            formatting = {
                format = function(entry, item)
                    local names = {
                        nvim_lsp = "[LSP]",
                        lazydev = "[LazyDev]",
                        luasnip = "[Snippet]",
                        vimtex = "[VimTeX]",
                        path = "[Path]",
                        buffer = "[Buffer]",
                    }
                    item.menu = names[entry.source.name] or ("[" .. entry.source.name .. "]")
                    return item
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-Space>"] = cmp.mapping.complete(),
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<CR>"] = cmp.mapping.confirm({ select = false }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_locally_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<C-e>"] = cmp.mapping(function()
                    if luasnip.choice_active() then
                        luasnip.change_choice(1)
                    else
                        cmp.abort()
                    end
                end, { "i", "s" }),
            }),
            sources = cmp.config.sources({
                { name = "lazydev", group_index = 0 },
                { name = "nvim_lsp", priority = 1000 },
                { name = "luasnip", priority = 900 },
                { name = "vimtex", priority = 800 },
                { name = "path", priority = 500 },
                { name = "buffer", priority = 300, keyword_length = 3 },
            }),
            enabled = function()
                return require("mystuffs.cmp_toggle").enabled
            end,
        })
    end,
}
