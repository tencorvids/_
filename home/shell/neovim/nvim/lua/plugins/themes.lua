return {
	"scottmckendry/cyberdream.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("cyberdream").setup({
			transparent = true,
			italic_comments = true,
			hide_fillchars = true,
			borderless_telescope = true,
			terminal_colors = true,
		})
		vim.cmd("colorscheme cyberdream")
	end,
}
