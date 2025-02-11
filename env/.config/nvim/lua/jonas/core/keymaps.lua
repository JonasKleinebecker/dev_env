vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Remap J and K to 5j and 5k
keymap.set({ "v", "n" }, "J", "5j", { desc = "Move down 5 lines" })
keymap.set({ "v", "n" }, "K", "5k", { desc = "Move up 5 lines" })

-- Remap line join functionality to <leader>j and <leader>k
keymap.set("n", "<leader>j", "J", { desc = "Join lines (was J)" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- neovim keybinds
keymap.set("n", "<leader>vx", "<cmd>!chmod +x %<CR>", { silent = true, desc = "Make current file executable" })
keymap.set("n", "<leader>vs", "<cmd>source %<CR>", { silent = true, desc = "Source current file" })
keymap.set("n", "<leader>vm", "<cmd>Mason<CR>", { silent = true, desc = "Mason" })
keymap.set("n", "<leader>vl", "<cmd>Lazy<CR>", { silent = true, desc = "Lazy" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- quickfix list
keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic Quickfix list" })

-- highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- keymap.set("n", "<leader>tx", "<cmd>bd<CR>", { desc = "Close current Buffer" })
-- keymap.set("n", "<leader>tn", "<cmd>bn<CR>", { desc = "Go to next Buffer" })
-- keymap.set("n", "<leader>tp", "<cmd>bp<CR>", { desc = "Go to previous Buffer" })
-- keymap.set("n", "<leader>tf", "<cmd>new<CR>", { desc = "Create new Buffer" })
-- keymap.set("n", "<leader>to", function()
-- 	local current_buf = vim.fn.bufnr("%")
-- 	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
-- 		if buf ~= current_buf then
-- 			vim.api.nvim_buf_delete(buf, { force = true })
-- 		end
-- 	end
-- end, { desc = "Close all Buffers but current" })
