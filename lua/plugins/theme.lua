return {
	"EdenEast/nightfox.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = false,
	},
	config = function()
		local spec = require("nightfox.spec").load("carbonfox")
		local groups = {
			all = {
				diffAdded = { fg = spec.git.add },
				diffDeleted = { fg = spec.git.removed },
				diffChanged = { fg = spec.git.changed },
				NormalFloat = { fg = spec.fg1, bg = spec.bg1 },
				MsgArea = { fg = spec.fg0, bg = spec.bg0 },
				FzfLuaScrollBorderEmpty = { fg = spec.bg1, bg = spec.bg1 },
				FzfLuaBorder = { fg = spec.fg3, bg = spec.bg1 },
			},
		}
		require("nightfox").setup({ groups = groups })
	end,
}
