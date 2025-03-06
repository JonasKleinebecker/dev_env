_G.CheckAndRunPython = function()
	local script_path = vim.fn.expand("~/.local/scripts/check_and_run_ipython.sh")
	local output = vim.fn.system(script_path)

	for line in output:gmatch("[^\r\n]+") do
		if line:match("^let g:slime_default_config") then
			local config = line:match("let g:slime_default_config = (%b{})")
			if config then
				vim.b.slime_config = vim.fn.eval(config)
			end
		end
	end
end

return {
	{
		"jpalardy/vim-slime",
		config = function()
			vim.g.slime_target = "tmux"
			vim.g.slime_cell_delimiter = "```"
			vim.g.slime_bracketed_paste = 1
			vim.g.slime_python_ipython = 0
			vim.g.slime_dont_ask_default = 1

			vim.api.nvim_set_keymap(
				"n",
				"<leader>rr",
				":lua CheckAndRunPython()<CR><Plug>SlimeLineSend<CR>",
				{ desc = "send python code to tmux", silent = false }
			)
			vim.api.nvim_set_keymap(
				"v",
				"<leader>rr",
				":lua CheckAndRunPython()<CR><Plug>SlimeRegionSend<CR>",
				{ desc = "send python code to tmux", silent = false }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<leader>rc",
				":lua CheckAndRunPython()<CR><Plug>SlimeSendCell<CR>",
				{ desc = "send python cell to tmux", silent = false }
			)
		end,
	},
}
