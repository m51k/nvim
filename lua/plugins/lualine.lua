return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "echasnovski/mini.icons" },
	config = function()
		local lualine = require("lualine")
		lualine.setup({
			options = {
				globalstatus = true,
			},
		})
	end,
}
