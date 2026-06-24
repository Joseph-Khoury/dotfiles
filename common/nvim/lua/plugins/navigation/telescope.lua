-- This is the coolest pluggin for how little code it takes to implement.
-- This plugin allows you to search files, grep text within a project
-- and provides a very nice ui
return {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
}
