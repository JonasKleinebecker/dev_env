return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		harpoon:setup()

		vim.keymap.set("n", "<leader>h", function()
			harpoon:list():add()
		end, { desc = "Add a file to the Harpoon list" })
		vim.keymap.set("n", "<leader>tl", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Toggle the Harpoon quick menu" })

		vim.keymap.set("n", "<leader>1", function()
			harpoon:list():select(1)
		end, { desc = "Select the first file in the Harpoon list" })
		vim.keymap.set("n", "<leader>2", function()
			harpoon:list():select(2)
		end, { desc = "Select the second file in the Harpoon list" })
		vim.keymap.set("n", "<leader>3", function()
			harpoon:list():select(3)
		end, { desc = "Select the third file in the Harpoon list" })
		vim.keymap.set("n", "<leader>4", function()
			harpoon:list():select(4)
		end, { desc = "Select the fourth file in the Harpoon list" })

		vim.keymap.set("n", "<leader>tp", function()
			harpoon:list():prev()
		end, { desc = "Go to the previous file in the Harpoon list" })
		vim.keymap.set("n", "<leader>tn", function()
			harpoon:list():next()
		end, { desc = "Go to the next file in the Harpoon list" })
	end,
}
