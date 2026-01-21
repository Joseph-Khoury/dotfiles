-- This is the coolest pluggin for how little code it takes to implement.
-- This plugin allows you to search files, grep text within a project
-- and provides a very nice ui
return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	-- or                              , branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim' },
}
