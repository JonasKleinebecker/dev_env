return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"folke/todo-comments.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local tel_builtin = require("telescope.builtin")
		local transform_mod = require("telescope.actions.mt").transform_mod

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		-- or create your custom action
		local custom_actions = transform_mod({
			open_trouble_qflist = function(prompt_bufnr)
				trouble.toggle("quickfix")
			end,
		})

		telescope.setup({
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<M-k>"] = actions.move_selection_previous, -- move to prev result
						["<M-j>"] = actions.move_selection_next, -- move to next result
						["<C-c>"] = actions.close,
					},
					n = {
						["<M-k>"] = actions.move_selection_previous, -- move to prev result
						["<M-j>"] = actions.move_selection_next, -- move to next result
						["<C-c>"] = actions.close,
						["q"] = actions.close,
					},
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

		keymap.set("n", "<leader>fF", function()
			tel_builtin.find_files({ hidden = true })
		end, { desc = "Fuzzy find files in cwd, including hidden files" })
		keymap.set("n", "<ledaer>fS", function()
			tel_builtin.live_grep({ hidden = true })
		end, { desc = "Find string in cwd, including hidden files" })
		keymap.set("n", "<leader>fC", function()
			tel_builtin.grep_string({ hidden = true })
		end, { desc = "Find string under cursor in cwd, including hidden files" })
	end,
}
