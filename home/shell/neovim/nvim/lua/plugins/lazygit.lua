-- Lazygit.nvim
-- Trigger lazygit inside of neovim
-- https://github.com/kdheepak/lazygit.nvim
return {
	"kdheepak/lazygit.nvim",

	vim.keymap.set("n", "<LEADER>gg", "<CMD>LazyGit<CR>", { desc = "Trigger and user LazyGit from nvim" }),
}
