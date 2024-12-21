return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		-- "hrsh7th/cmp-nvim-lsp",
		"saghen/blink.cmp"
	},
	config = function()
		local lspconfig = require("lspconfig")
		-- local cmp = require("cmp_nvim_lsp")
		local blink = require("blink.cmp")

		local keymap = vim.keymap -- for conciseness

		vim.api.nvim_create_autocmd({ 'LspProgress' }, {
			callback = function(context)
				vim.notify(vim.inspect(context))
				-- or vim.print(context) if you want something less invasive
			end,
		})

		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
			end,
		})

		-- local capabilities = cmp.default_capabilities()
		local capabilities = blink.get_lsp_capabilities()

		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})

		-- lspconfig.clangd.setup({
		-- 	capabilities = capabilities,
		-- })
	end,
}
