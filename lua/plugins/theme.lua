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
			},
		}
		require("nightfox").setup({ groups = groups })
	end,
}
