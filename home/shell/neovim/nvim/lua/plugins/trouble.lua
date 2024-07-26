-- Trouble.nvim
-- Diagnostics, references, telescope results, quickfix and location list.
-- https://github.com/folke/trouble.nvim
return {
	"folke/trouble.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {},

	vim.keymap.set("n", "<LEADER>xx", "<CMD>Trouble diagnostics toggle<CR>", { desc = "Toggle trouble list" }),
}
