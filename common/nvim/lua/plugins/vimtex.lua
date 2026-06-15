return {
    "lervag/vimtex",
    lazy = false,     -- we don't want to lazy load VimTeX
    ft = { "tex" },
    -- tag = "v2.15", -- uncomment to pin to a specific release
    init = function()
        -- VimTeX configuration goes here, e.g.
        vim.g.vimtex_view_method = "skim"
        vim.g.vimtex_compiler_method = "latexmk"
        vim.g.vimtex_quickfix_mode = 0
        vim.g.vimtex_syntax_enabled = 0
        vim.g.vimtex_syntax_conceal = {
            accents = 1,
            cites = 1,
            fancy = 1,
            greek = 1,
            math_bounds = 1,
            math_delimiters = 1,
            math_fracs = 1,
            math_super_sub = 1,
            math_symbols = 1,
            sections = 1,
            styles = 1
        }
        -- Start a server for backward linking between vimtex and skim
        -- as soon as a .tex is opened
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "tex",
            callback = function()
                local fixed = "/tmp/nvimsocket"  -- choose a stable path
                -- If there isn't already a server, start one at the fixed address
                local current = vim.v.servername or ""
                if current == "" then
                    vim.env.NVIM_LISTEN_ADDRESS = fixed
                    pcall(vim.fn.serverstart, fixed)
                end
            end,
        })
    end
}
