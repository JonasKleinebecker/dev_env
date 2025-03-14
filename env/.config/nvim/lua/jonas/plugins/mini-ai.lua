return {
	"echasnovski/mini.ai",
	event = { "BufReadPre", "BufNewFile" },
	version = false,
	config = function()
		require("mini.ai").setup()
	end,
}
