local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.deps"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.deps`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.deps",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.deps | helptags ALL")
	vim.cmd('echo "Installed `mini.deps`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	vim.g.mapleader = " "
	vim.g.maplocalleader = "\\"
	vim.wo.number = true
	vim.wo.relativenumber = true
	vim.o.tabstop = 4
	vim.o.softtabstop = 0
	vim.o.cursorline = true
	vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
end)

later(add({ source = "echasnovski/mini.base16" }))
later(add({ source = "echasnovski/mini.pick" }))
later(add({ source = "echasnovski/mini.pairs" }))
later(add({ source = "neovim/nvim-lspconfig" }))
later(add({ source = "nvim-treesitter/nvim-treesitter" }))

now(function()
	require("mini.base16").setup({
		palette = {
			base00 = "#161616",
			base01 = "#262626",
			base02 = "#393939",
			base03 = "#525252",
			base04 = "#c1c8cd",
			base05 = "#dde1e6",
			base06 = "#f2f4f8",
			base07 = "#ffffff",
			base08 = "#fa4d56",
			base09 = "#ff932b",
			base0A = "#f1c21b",
			base0B = "#42be65",
			base0C = "#3ddbd9",
			base0D = "#78a9ff",
			base0E = "#be95ff",
			base0F = "#a2a9b0",
		},
	})
end)
later(function()
	require("mini.pick").setup({
		vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "find file" }),
		vim.keymap.set("n", "<leader>fs", "<cmd>Pick grep<cr>", { desc = "find file" }),
		vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "find file" }),
	})
end)
later(function()
	require("mini.pairs").setup()
end)
later(function()
	require("nvim-treesitter.configs").setup({
		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,

		-- Automatically install missing parsers when entering buffer
		-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
		auto_install = true,

		-- List of parsers to ignore installing (or "all")
		ignore_install = {},

		highlight = { enable = true },

		-- enable indentation
		indent = { enable = true },

		-- enable autotagging (w/ nvim-ts-autotag plugin)
		autotag = { enable = true },

		modules = {},

		-- ensure these language parsers are installed
		ensure_installed = {
			"json",
			"javascript",
			"typescript",
			"html",
			"css",
			"markdown",
			"bash",
			"lua",
			"dockerfile",
			"gitignore",
			"c",
			"php",
			"rust",
		},
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "<C-space>",
				node_incremental = "<C-space>",
				scope_incremental = false,
				node_decremental = "<bs>",
			},
		},
	})
end)
now(function()
	vim.api.nvim_create_autocmd({ "LspProgress" }, {
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
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

			opts.desc = "Restart LSP"
			vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
		end,
	})
	require("lspconfig").lua_ls.setup({
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim", "MiniDeps" },
				},
			},
		},
	})
end)
