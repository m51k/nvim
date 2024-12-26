return {
	"saghen/blink.cmp",
	version = "*",

	---@module "blink.cmp"
	---@type blink.cmp.Config
	opts = {
		keymap = { preset = "default" },

		completion = {
			accept = {
				auto_brackets = {
					enabled = true,
				},
			},
			menu = {
				-- nvim-cmp style menu
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind_icon", "kind" },
					},
				},
			},
		},
		appearance = {
			nerd_font_variant = "normal",
		},

		sources = {
			default = { "lsp", "path", "buffer" },
			cmdline = {},
		},
	},
	opts_extend = { "sources.default" },
}
