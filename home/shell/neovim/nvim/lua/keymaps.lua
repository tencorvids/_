-- Clear search highlight with <Esc> in normal mode
vim.keymap.set("n", "<ESC>", "<CMD>nohlsearch<CR>")

-- Center screen while cycling
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Remap jk / kj to <ESC> to exit insert mode
vim.api.nvim_set_keymap("i", "jk", "<ESC>", { noremap = true })
vim.api.nvim_set_keymap("i", "kj", "<ESC>", { noremap = true })

-- Navigate splits with <CTRL> hjkl
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
