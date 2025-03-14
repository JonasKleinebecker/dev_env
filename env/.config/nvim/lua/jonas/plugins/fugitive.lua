return {
	"tpope/vim-fugitive",
	config = function()
		vim.keymap.set("n", "<leader>gs", ":Git<CR>", { desc = "open fugitive (git status)" })
		vim.keymap.set("n", "<leader>gc", ":Git commit<CR>", { desc = "git commit" })
		vim.keymap.set("n", "<leader>gp", ":Git push<CR>", { desc = "git push" })
		vim.keymap.set("n", "<leader>gl", ":Git pull<CR>", { desc = "git pull" })
		vim.keymap.set("n", "<leader>gd", ":Git diff<CR>", { desc = "git diff" })
		vim.keymap.set("n", "<leader>ga", ":Git add .<CR>", { desc = "git add all" })
	end,
}
