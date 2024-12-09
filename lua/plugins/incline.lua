return {
	"b0o/incline.nvim",
	event = "BufReadPre",
	dependencies = { "echanovski/mini.icons" },
	config = function()
		local incline = require("incline")
		local s = require("nightfox.spec").load("carbonfox")
		incline.setup({
			highlight = {
				groups = {
					InclineNormal = { guibg = s.bg0, guifg = s.fg2 },
					InclineNormalNC = { guibg = s.bg0, guifg = s.fg3 },
				},
			},
			window = { margin = { vertical = 0, horizontal = 1 } },
			hide = {
				cursorline = false,
				only_win = false,
			},
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				if vim.bo[props.buf].modified then
					filename = "[+] " .. filename
				end

				local icon, color = MiniIcons.get("file", filename)
				return { { icon, guifg = color }, { " " }, { filename } }
			end,
		})
	end,
}
