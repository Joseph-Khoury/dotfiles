-- This plugin is for adding a navigatable clipboard
return {
    "AckslD/nvim-neoclip.lua",
    dependencies = {
        {'nvim-telescope/telescope.nvim'},
        { "kkharji/sqlite.lua", module = "sqlite" },
    },
    config = function()
        require('neoclip').setup({
            history = 1000,
            enable_persistent_history = false,
            length_limit = 1048576,
            continuous_sync = false,
            db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
            filter = nil,
            preview = true,
            prompt = nil,
            default_register = '"',
            default_register_macros = 'q',
            enable_macro_history = true,
            content_spec_column = false,
            disable_keycodes_parsing = false,
            dedent_picker_display = false,
            initial_mode = 'insert',
            on_select = {
                move_to_front = false,
                close_telescope = true,
            },
            on_paste = {
                set_reg = false,
                move_to_front = false,
                close_telescope = true,
            },
            on_replay = {
                set_reg = false,
                move_to_front = false,
                close_telescope = true,
            },
            on_custom_action = {
                close_telescope = true,
            },
            keys = {
                telescope = {
                    i = {
                        move_selection_next = '<c-n>',
                        move_selection_previous = '<c-p>',
                        paste = "<c-s-p>",
                        replay = '<c-q>',  -- replay a macro
                        delete = '<c-d>',  -- delete an entry
                        edit = '<c-e>',  -- edit an entry
                    },
                },
            },
        })
        require("telescope").load_extension("neoclip")
    end,
}
