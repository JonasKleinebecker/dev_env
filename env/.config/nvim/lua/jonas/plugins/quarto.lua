return {
	"quarto-dev/quarto-nvim",
	opts = {},
	dependencies = {
		"jmbuhr/otter.nvim",
		opts = {},
		config = function()
			local quarto = require("quarto")
			quarto.setup()

			vim.keymap.set({ "n", "v" }, "<m-i>", "<esc>i```{python}<cr>```<esc>O", { desc = "Insert python block" })
			vim.keymap.set(
				"n",
				"<leader>qp",
				quarto.quartoPreview,
				{ silent = true, noremap = true, desc = "Quarto preview" }
			)
			vim.keymap.set(
				"n",
				"<leader>qx",
				quarto.quartoClosePreview,
				{ silent = true, noremap = true, desc = "Quarto close preview" }
			)
			vim.keymap.set(
				"n",
				"<leader>qa",
				quarto.activate,
				{ silent = true, noremap = true, desc = "Quarto activate" }
			)
		end,
	},
}
