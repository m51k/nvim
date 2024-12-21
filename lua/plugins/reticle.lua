return {
	"tummetott/reticle.nvim",
	event = "VeryLazy", -- optionally lazy load the plugin
	opts = {
		on_startup = {
			cursorline = true,
			cursorcolumn = false,
		},
	},
}
