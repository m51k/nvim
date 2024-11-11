return {
	"navarasu/onedark.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = false,
	},
	config = function()
		require("onedark").setup({
			style = "dark",
			highlights = {
				["StatusLine"] = { bg = "#1d2026" },
				["StatusLineNC"] = { bg = "#1d2026" },
			},
		})
	end,
}
