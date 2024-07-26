-- Oil.nvim
-- Edit file system like a buffer
-- https://github.com/stevearc/oil.nvim
return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			view_options = {
				show_hidden = true,
			},
		})
	end,

	vim.keymap.set("n", "<LEADER>o", "<CMD>Oil<CR>", { desc = "Trigger Oil file explorer buffer" }),
}
