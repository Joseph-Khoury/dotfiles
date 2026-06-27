return {
    "lervag/vimtex",

    ft = {
        "tex",
        "plaintex",
        "bib",
    },

    init = function()
        local os = require("utils.os")

        ----------------------------------------------------------------------
        -- General VimTeX behaviour {{{
            ----------------------------------------------------------------------

            vim.g.tex_flavor = "latex"

            vim.g.vimtex_compiler_method = "latexmk"

            vim.g.vimtex_compiler_latexmk = {
                executable = "latexmk",
                continuous = 1,
                callback = 1,
                build_dir = "",
                options = {
                    "-pdf",
                    "-verbose",
                    "-file-line-error",
                    "-synctex=1",
                    "-interaction=nonstopmode",
                },
            }

            -- Do not automatically open quickfix for every warning.
            -- Use :VimtexErrors or :copen when you want the list.
            vim.g.vimtex_quickfix_mode = 0

            -- Keep VimTeX syntax enabled for now.
            -- This is useful for VimTeX's math-zone detection, which your
            -- LaTeX snippets can use.
            vim.g.vimtex_syntax_enabled = 1

            -- }}}

            ----------------------------------------------------------------------
            -- Viewer selection {{{
                ----------------------------------------------------------------------

                if os.is_wsl then
                    ------------------------------------------------------------------
                    -- WSL Debian: {{{
                        -- Compile in WSL, view with Windows-native Sioyek through a wrapper that converts paths
                        ------------------------------------------------------------------

                        if os.executable("sioyek.exe") then
                            vim.g.vimtex_view_method = "sioyek"
                            vim.g.vimtex_view_sioyek_exe = "sioyek-wsl"

                            -- Use your actual distro name if it differs.
                            -- Check with: wsl -l -v
                            vim.g.vimtex_callback_progpath = "wsl -d Debian nvim"

                            -- Optional. Enable only if you prefer Sioyek to reuse a window.
                            -- vim.g.vimtex_view_sioyek_options = "--reuse-window"
                        else
                            vim.g.vimtex_view_method = "general"
                        end

                        -- }}}

                    elseif os.is_macos then
                        ------------------------------------------------------------------
                        -- macOS: {{{
                            -- Use Skim.
                            ------------------------------------------------------------------

                            vim.g.vimtex_view_method = "skim"

                            -- Sync PDF position after compilation / :VimtexView.
                            vim.g.vimtex_view_skim_sync = 1

                            -- Do not constantly steal focus from Neovim.
                            vim.g.vimtex_view_skim_activate = 0

                            -- Nice visual cue in Skim.
                            vim.g.vimtex_view_skim_reading_bar = 1

                            -- }}}

                        elseif os.is_linux then
                            ------------------------------------------------------------------
                            -- Native Linux: {{{
                                -- Use Zathura.
                                ------------------------------------------------------------------

                                if os.executable("zathura") then
                                    vim.g.vimtex_view_method = "zathura"
                                    vim.g.vimtex_view_zathura_use_synctex = 1
                                else
                                    vim.g.vimtex_view_method = "general"
                                end

                                -- }}}
                            end
                            -- }}}
                        end,
                    }
