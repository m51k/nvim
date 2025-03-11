local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
end
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later
now(function()
	vim.g.mapleader = vim.keycode("<space>")
	vim.g.maplocalleader = vim.keycode("<cr>")
	vim.wo.number = true
	vim.o.tabstop = 8
	vim.o.softtabstop = 8
	vim.o.shiftwidth = 8
	vim.o.cursorline = true
	vim.o.relativenumber = true
	vim.o.ignorecase = true
	vim.o.smartcase = true
	vim.o.guicursor = ""
	-- vim.g.netrw_banner = 0
	vim.o.background = "dark"
	vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"
end)
now(function()
	local palette = {
		base00 = "#303030",
		base01 = "#3a3a3a",
		base02 = "#4e4e4e",
		base03 = "#6c6c6c",
		base04 = "#8a8a8a",
		base05 = "#c6c6c6",
		base06 = "#c6c6c6",
		base07 = "#eeeeee",
		base08 = "#ff4ea3",
		base09 = "#ff8700",
		base0A = "#ffd700",
		base0B = "#a1db00",
		base0C = "#00d7af",
		base0D = "#5fafd7",
		base0E = "#d18aff",
		base0F = "#ef2929",
	}
	local tomorrow = {
		base00 = "#181818",
		base01 = "#282828",
		base02 = "#383838",
		base03 = "#585858",
		base04 = "#b8b8b8",
		base05 = "#d8d8d8",
		base06 = "#e8e8e8",
		base07 = "#f8f8f8",
		base08 = "#ab4642",
		base09 = "#dc9656",
		base0A = "#f7ca88",
		base0B = "#a1b56c",
		base0C = "#86c1b9",
		base0D = "#7cafc2",
		base0E = "#ba8baf",
		base0F = "#a16946",
	}
	require("mini.base16").setup({ palette = palette })
	-- require("mini.hues").setup({ foreground = "#c6c6c6", background = "#303030" })

	-- add({ source = "folke/tokyonight.nvim" })
	-- require("tokyonight").setup({
	-- 	vim.cmd("colorscheme tokyonight-night")
	-- })
end)
now(function() require("mini.starter").setup() end)
now(function() require("mini.surround").setup() end)
later(function() require("mini.pick").setup() end)
later(function() require("mini.files").setup() end)
later(function() require("mini.ai").setup() end)
later(function() require("mini.pairs").setup() end)
later(function() require("mini.icons").setup() end)
-- later(function() require("mini.statusline").setup() end)
later(function() require("mini.bracketed").setup() end)
later(function() require("mini.ai").setup() end)
-- later(function() require("mini.notify").setup() end)
later(function() require("mini.comment").setup() end)
later(function()
	require("mini.indentscope").setup({
		draw = {
			animation = function() return 0 end,
		},
	})
end)
later(function() require("mini.move").setup() end)
later(function() require("mini.diff").setup() end)
later(function()
	require("mini.hipatterns").setup({
		highlighters = {
			-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
			fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
			hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
			todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
			note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

			-- Highlight hex color strings (`#rrggbb`) using that color
			hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
		},
	})
end)
later(function()
	require("mini.completion").setup({
		-- dont want this to show up unless intentionally
		delay = { completion = 10 ^ 3.301, info = 10 ^ 3.301, signature = 10 ^ 3.301 },
	})
end)
later(function() require("mini.trailspace").setup() end)
later(function() require("mini.surround").setup() end)
later(function() require("mini.extra").setup() end)
later(function()
	add({ source = "stevearc/conform.nvim" })
	require("conform").setup({
		formatters_by_ft = {
			c = { "clang-format" },
			lua = { "stylua" },
		},
	})
end)
later(function()
	add({
		source = "nvim-treesitter/nvim-treesitter",
		-- depends = { "nvim-treesitter/nvim-ts-autotag" },
		hooks = {
			post_checkout = function() vim.cmd("TSUpdate") end,
		},
	})
	require("nvim-treesitter.configs").setup({
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
		-- god save me i dont want to make webapps
		-- enable autotagging (w/ nvim-ts-autotag plugin)
		-- autotag = { enable = true },
	})
end)
now(function()
	-- lsp
	add({ source = "neovim/nvim-lspconfig" })
	local lua_settings = {
		Lua = {
			diagnostics = {
				globals = { "vim", "MiniDeps" },
			},
		},
	}
	local lspconfig = require("lspconfig")
	lspconfig.lua_ls.setup({ settings = lua_settings })
	lspconfig.clangd.setup({})
end)
now(function()
	-- picker
	vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "find file" })
	vim.keymap.set("n", "<leader>fs", "<cmd>Pick grep<cr>", { desc = "find string" })
	vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "find buffer" })
	vim.keymap.set("n", "<leader>fd", "<cmd>Pick diagnostic scope='all'", { desc = "find diagnostic" })

	-- explorer
	vim.keymap.set("n", "<leader>ed", "<cmd>lua MiniFiles.open()<cr>", { desc = "explore" })

	-- formatter
	local format_cmd = "<cmd>lua require('conform').format({ lsp_fallback = true })<cr>"
	vim.keymap.set("n", "<leader>bf", format_cmd, { desc = "format" })

	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			-- lsp
			vim.keymap.set("n", "grn", "<cmd>lua vim.lsp.buf.rename()<cr>", { desc = "refactor" })
			vim.keymap.set("n", "gra", "<cmd>lua vim.lsp.buf.code_action()<cr>", { desc = "actions" })
			vim.keymap.set("n", "grr", "<cmd>lua vim.lsp.buf.references()<cr>", { desc = "references" })
			vim.keymap.set(
				"i",
				"<C-s>",
				"<cmd>lua vim.lsp.buf.signature_help()<cr>",
				{ desc = "signatures" }
			)
			vim.keymap.set(
				"n",
				"<leader>lj",
				"<Cmd>lua vim.diagnostic.goto_next()<cr>",
				{ desc = "next diagnostic" }
			)
			vim.keymap.set(
				"n",
				"<leader>lk",
				"<Cmd>lua vim.diagnostic.goto_prev()<cr>",
				{ desc = "prev diagnostic" }
			)
		end,
	})
end)
