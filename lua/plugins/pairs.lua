return {
	"echasnovski/mini.pairs",
	event = "VeryLazy",
	opts = {
		skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
		skip_ts = { "string" },
		skip_unbalanced = true,
		markdown = true,
	},
	config = function()
		local pairs = require("mini.pairs")
		pairs.setup()
	end,
}
