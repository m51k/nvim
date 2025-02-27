local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
	vim.cmd('echo "Installing `mini.nvim`" | redraw')
	local clone_cmd = {
		"git",
		"clone",
		"--filter=blob:none",
		-- Uncomment next line to use 'stable' branch
		-- '--branch', 'stable',
		"https://github.com/echasnovski/mini.nvim",
		mini_path,
	}
	vim.fn.system(clone_cmd)
	vim.cmd("packadd mini.nvim | helptags ALL")
end
require("mini.deps").setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

now(function()
	vim.g.mapleader = " "
	vim.g.maplocalleader = "\\"
	vim.wo.number = true
	vim.wo.relativenumber = true
	vim.o.tabstop = 8
	vim.o.softtabstop = 0
	vim.o.cursorline = true
	vim.o.showmode = false
	vim.o.background = "dark"
	vim.g.netrw_bufsettings = "noma nomod nu rnu nobl nowrap ro"
end)

later(add({ source = "neovim/nvim-lspconfig" }))
later(add({
	source = "nvim-treesitter/nvim-treesitter",
	-- depends = { "nvim-treesitter/nvim-ts-autotag" },
	hooks = {
		post_checkout = function()
			vim.cmd("TSUpdate")
		end,
	},
}))

now(function()
	require("mini.base16").setup({
		palette = {
			base00 = "#1A1B26",
			base01 = "#16161E",
			base02 = "#2F3549",
			base03 = "#444B6A",
			base04 = "#787C99",
			base05 = "#A9B1D6",
			base06 = "#CBCCD1",
			base07 = "#D5D6DB",
			base08 = "#C0CAF5",
			base09 = "#A9B1D6",
			base0A = "#0DB9D7",
			base0B = "#9ECE6A",
			base0C = "#B4F9F8",
			base0D = "#2AC3DE",
			base0E = "#BB9AF7",
			base0F = "#F7768E",
		},
	})
end)
now(function()
	require("mini.starter").setup()
end)
later(function()
	require("mini.pick").setup({
		vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "find file" }),
		vim.keymap.set("n", "<leader>fs", "<cmd>Pick grep<cr>", { desc = "find string" }),
		vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "find buffer" }),
	})
end)
later(function()
	require("mini.files").setup({
		-- vim.keymap.set("n", "<leader>op", "<cmd>Pick files<cr>", { desc = "find file" }),
		vim.keymap.set("n", "<leader>e", function()
			if not require("mini.files").close() then
				require("mini.files").open()
			end
		end, { desc = "explore" }),
	})
end)
later(function()
	require("mini.pairs").setup()
end)
later(function()
	require("mini.icons").setup()
end)
later(function()
	require("mini.statusline").setup()
end)
later(function()
	require("mini.bracketed").setup()
end)
-- later(function()
-- 	require("mini.ai").setup()
-- end)
later(function()
	require("mini.notify").setup()
end)
later(function()
	require("mini.comment").setup()
end)
later(function()
	require("mini.indentscope").setup({
		draw = {
			animation = function()
				return 0
			end,
		},
	})
end)
later(function()
	require("mini.move").setup()
end)
later(function()
	require("mini.diff").setup()
end)
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
-- uncomment for completion
--
later(function()
	require("mini.completion").setup({
		-- dont want this to show up unless intentionally
		delay = { completion = 10 ^ 3.301, info = 10 ^ 3.301, signature = 10 ^ 3.301 },
	})
end)
later(function()
    require("mini.trailspace").setup()
end)
later(function()
    require("mini.surround").setup()
end)
later(function()
	require("mini.extra").setup()
end)
later(function()
	require("nvim-treesitter.configs").setup({
		auto_install = true,
		highlight = { enable = true },
		indent = { enable = true },
		-- enable autotagging (w/ nvim-ts-autotag plugin)
		-- autotag = { enable = true },
		ensure_installed = {
			"bash",
			"c",
			"css",
			"dockerfile",
			"gitignore",
			"html",
			"javascript",
			"lua",
			"markdown",
			"rust",
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
			local opts = { buffer = ev.buf, silent = true }

			opts.desc = "Show documentation for what is under cursor"
			vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

			opts.desc = "Restart LSP"
			vim.keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
		end,
	})
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

	vim.keymap.set("n", "<leader>ld", function()
		vim.lsp.buf.definition()
	end, { desc = "goto definition" })
	vim.keymap.set("n", "<leader>lr", function()
		vim.lsp.buf.rename()
	end, { desc = "lsp refactor" })
	vim.keymap.set("n", "<leader>la", function()
		vim.lsp.buf.code_action()
	end, { desc = "lsp actions" })
	vim.keymap.set("n", "<leader>le", function()
		require("mini.extra").pickers.diagnostic({ scope = "current" })
	end, { desc = "lsp errors" })
end)
