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
		local action_state = require("telescope.actions.state")
		local tel_builtin = require("telescope.builtin")
		local transform_mod = require("telescope.actions.mt").transform_mod
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values

		local trouble = require("trouble")
		local trouble_telescope = require("trouble.sources.telescope")

		local function get_keymaps()
			local keymaps = {}
			local modes = { "n", "i", "v", "c", "s", "o", "l" }
			for _, mode in ipairs(modes) do
				for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
					if map.desc then
						table.insert(keymaps, {
							mode = mode,
							lhs = map.lhs,
							desc = map.desc,
						})
					end
				end
			end
			return keymaps
		end

		-- Custom Telescope picker for keymaps
		local function keymaps_picker(opts)
			opts = opts or {}
			local keymaps = get_keymaps()

			if #keymaps == 0 then
				print("No keymaps with descriptions found.")
				return
			end

			pickers
				.new(opts, {
					prompt_title = "Keymaps",
					finder = finders.new_table({
						results = keymaps,
						entry_maker = function(entry)
							return {
								value = entry,
								display = string.format("%s: %s -> %s", entry.mode, entry.lhs, entry.desc),
								ordinal = string.format("%s %s %s", entry.mode, entry.lhs, entry.desc),
							}
						end,
					}),
					sorter = conf.generic_sorter(opts),
					attach_mappings = function(prompt_bufnr, map)
						actions.select_default:replace(function()
							actions.close(prompt_bufnr)
							local selection = action_state.get_selected_entry()
							if selection then
								print(vim.inspect(selection.value))
							else
								print("No selection made.")
							end
						end)
						return true
					end,
				})
				:find()
		end

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

		-- Set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "Fuzzy find files in cwd (git)" })
		keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Fuzzy find help tags" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
		keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })
		keymap.set("n", "<leader>fk", function()
			keymaps_picker()
		end, { desc = "Find keymaps" })

		keymap.set("n", "<leader>fF", function()
			tel_builtin.find_files({ hidden = true })
		end, { desc = "Fuzzy find files in cwd, including hidden files" })
		keymap.set("n", "<leader>fG", function()
			tel_builtin.git_files({ hidden = true })
		end, { desc = "Fuzzy find files in cwd (git), including hidden files" })
		keymap.set("n", "<leader>fS", function()
			tel_builtin.live_grep({ hidden = true })
		end, { desc = "Find string in cwd, including hidden files" })
		keymap.set("n", "<leader>fC", function()
			tel_builtin.grep_string({ hidden = true })
		end, { desc = "Find string under cursor in cwd, including hidden files" })
		keymap.set("n", "<leader>fof", function()
			tel_builtin.find_files({
				cwd = "/mnt/g/Meine Ablage/Obsidian/Main_vault/",
			})
		end, { desc = "Fuzzy find files in Obsidian vault" })
		keymap.set("n", "<leader>fos", function()
			tel_builtin.live_grep({
				cwd = "/mnt/g/Meine Ablage/Obsidian/Main_vault/",
			})
		end, { desc = "Find string in Obsidian vault" })
		keymap.set("n", "<leader>foF", function()
			tel_builtin.find_files({
				cwd = "/mnt/g/Meine Ablage/Obsidian/Main_vault/",
				hidden = true,
			})
		end, { desc = "Fuzzy find files in Obsidian vault, including hidden files" })
		keymap.set("n", "<leader>foS", function()
			tel_builtin.live_grep({
				cwd = "/mnt/g/Meine Ablage/Obsidian/Main_vault/",
				hidden = true,
			})
		end, { desc = "Find string in Obsidian vault, including hidden files" })
	end,
}
