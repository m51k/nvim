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
			window = {
				padding = 0,
				margin = { vertical = 0, horizontal = 0 }
			},
			hide = {
				cursorline = false,
				only_win = true,
			},
			render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				-- if vim.bo[props.buf].modified then
				--     filename = "[+] " .. filename
				-- end

				local MiniIcons = require('mini.icons')
				local icon, hl, is_default = MiniIcons.get('file', filename)
				hl = "#" .. string.format("%06x", vim.inspect(vim.api.nvim_get_hl_by_name(hl, true).foreground))
				local modified = vim.bo[props.buf].modified
				-- return { { ft_icon, guifg = ft_color, guibg = hl }, { " " }, { filename } }
				return {
					icon and { ' ', icon, ' ', guibg = hl, guifg = s.bg0 } or '',
					' ',
					{ filename, gui = modified and 'bold,italic' or 'bold' },
					' ',
					guibg = s.bg0,
				}
			end,
		})
	end,
}
