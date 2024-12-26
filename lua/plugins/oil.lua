return {
	"stevearc/oil.nvim",
	---@module 'oil'
	---@type oil.SetupOpts
	-- Optional dependencies
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	config = function()
		local oil = require("oil")
		oil.setup({
			columns = {
				"permissions",
				"size",
				"mtime",
				"icon",
			},
		})
		vim.keymap.set("n", "<leader>dj", "<cmd>Oil<cr>", { desc = "File explorer" })
	end,
}
