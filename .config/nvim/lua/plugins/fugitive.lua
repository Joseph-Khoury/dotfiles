-- This is a git plugin
return {
	"tpope/vim-fugitive",
	cmd = { "Git", "G" },
	keys = {
		{ "<leader>gs", "<cmd>Git<CR>", desc = "Git status (Fugitive)" },
		{ "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
		{ "<leader>gd", "<cmd>Gvdiffsplit<CR>", desc = "Git diff split" },
	},
}
