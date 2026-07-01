local parsers = {
	-- Nvim configuration
	"lua",
	"luadoc",
	"vim",
	"vimdoc",
	"query",

	-- Shell and configuration files
	"bash",
	"zsh",
	"json",
	"toml",
	"yaml",
	"powershell",

	-- Programming
	"c",
	"cpp",
	"cmake",
	"make",
	"python",
	"rust",

	-- Writing
	"bibtex",
	"latex",
	"markdown",
	"markdown_inline",

	-- HDL / FPGA
	"verilog",
	"vhdl",
}

return {
    {
        -- Use an explicit URL so Lazy cannot clone the archived repository.
        name = "nvim-treesitter",
        url = "https://github.com/neovim-treesitter/nvim-treesitter.git",

        dependencies = {
            "neovim-treesitter/treesitter-parser-registry",
        },

        lazy = false,
        build = ":TSUpdate",

        config = function()
            local treesitter = require("nvim-treesitter")

            treesitter.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            -- Asynchronously install any missing parsers and their
            -- matching queries. Existing current installations are no-ops.
            treesitter.install(parsers)

            local group = vim.api.nvim_create_augroup(
                "user_treesitter",
                { clear = true }
            )

            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = "*",

                callback = function(args)
                    local filetype = vim.bo[args.buf].filetype

                    if filetype == "" then
                        return
                    end

                    -- Let VimTeX handle LaTeX syntax.
                    if vim.tbl_contains({
                        "tex",
                        "plaintex",
                        "latex",
                    }, filetype) then
                        return
                    end

                    -- Some filetypes may not have an installed parser.
                    pcall(vim.treesitter.start, args.buf)
                end,
            })
        end,
    },
}
