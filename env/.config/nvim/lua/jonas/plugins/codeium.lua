return {
	"Exafunction/codeium.nvim",
	event = "BufEnter",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"hrsh7th/nvim-cmp",
	},
	config = function()
		require("codeium").setup({
			virtual_text = {
				enabled = true,
				idle_delay = 20,
				key_bindings = {
					accept = "<C-f>",
					accept_word = "<C-a>",
					accept_line = "<C-l>",
					clear = false,
					next = "<A-h>",
					prev = "<A-l>",
				},
			},
		})
	end,
}
