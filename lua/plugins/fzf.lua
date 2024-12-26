return {
	"ibhagwan/fzf-lua",
	dependencies = {
		"echanovski/mini.icons",
	},
	config = function()
		local fzf = require("fzf-lua")
		fzf.setup({
			vim.keymap.set("n", "<leader>ff", require("fzf-lua").files, { desc = "Fzf Files" }),
			vim.keymap.set("n", "<leader>fb", require("fzf-lua").buffers, { desc = "Fzf Buffers" }),
			vim.keymap.set("n", "<leader>fs", require("fzf-lua").grep, { desc = "Fzf Strings" }),
		})
	end,
}
