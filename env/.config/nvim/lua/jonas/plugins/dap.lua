return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup()

			require("nvim-dap-virtual-text").setup()

			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
			)

			-- Eval var under cursor
			vim.keymap.set("n", "<space>?", function()
				require("dapui").eval(nil, { enter = true })
			end)

			vim.keymap.set("n", "<leader>sc", dap.continue, { desc = "Debug continue" })
			vim.keymap.set("n", "<leader>si", dap.step_into, { desc = "Debug step into" })
			vim.keymap.set("n", "<leader>so", dap.step_over, { desc = "Debug step over" })
			vim.keymap.set("n", "<leader>sr", dap.step_out, { desc = "Debug step out" })
			vim.keymap.set("n", "<leaedr>sb", dap.step_back, { desc = "Debug step back" })
			vim.keymap.set("n", "<leader>dt", ":DapUiToggle<CR>", { desc = "Toggle debug UI" })
			vim.keymap.set(
				"n",
				"<leader>db",
				":DapToggleBreakpoint<CR>",
				{ desc = "Toggle breakpoint on current line" }
			)
			vim.keymap.set(
				"n",
				"<leader>dr",
				":lua require('dapui').open({reset = true})<CR>",
				{ desc = "Reset debug UI" }
			)

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
