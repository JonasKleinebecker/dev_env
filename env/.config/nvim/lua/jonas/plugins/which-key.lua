return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		spec = {
			{ "<leader>a", group = "Avante" },
			{ "<leader>c", group = "code", mode = { "n", "x" } },
			{ "<leader>d", group = "Debug" },
			{ "<leader>e", group = "File Explorer" },
			{ "<leader>r", group = "Send Code/Rename/Restart" },
			{ "<leader>s", group = "Splits/Debug Steps" },
			{ "<leader>f", group = "Find with Telescope" },
			{ "<leader>x", group = "Diagnostics/Trouble" },
			{ "<leader>h", group = "Git Hunk/Harpoon", mode = { "n", "v" } },
			{ "<leader>v", group = "Vim commands" },
		},
	},
}
