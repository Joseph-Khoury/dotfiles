-- Add the ability to toggle a line between comment and not
return {
	"numToStr/Comment.nvim",
	lazy = false,
	config = function()
		require("Comment").setup()
	end,
}

