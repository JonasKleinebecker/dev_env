return {
	"quarto-dev/quarto-nvim",
	opts = {},
	dependencies = {
		"jmbuhr/otter.nvim",
		opts = {},
		config = function()
			local quarto = require("quarto")
			quarto.setup()

			vim.keymap.set({ "n", "i" }, "<m-i>", "<esc>i```{python}<cr>```<esc>O", { desc = "Insert python block" })
		end,
	},
}
