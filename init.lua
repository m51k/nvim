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
			-- base00 = "#000000",
			-- base01 = "#111111",
			-- base02 = "#333333",
			-- base03 = "#bbbbbb",
			-- base04 = "#dddddd",
			-- base05 = "#ffffff",
			-- base06 = "#ffffff",
			-- base07 = "#ffffff",
			-- base09 = "#ff2222",
			-- base08 = "#ff9922",
			-- base0A = "#ff22ff",
			-- base0B = "#22ff22",
			-- base0C = "#4444ff",
			-- base0D = "#22ffff",
			-- base0E = "#ffff22",
			-- base0F = "#999999",

			base00 = "#161616",
			base01 = "#262626",
			base02 = "#393939",
			base03 = "#525252",
			base04 = "#c1c7cd",
			base05 = "#dde1e6",
			base06 = "#f2f4f8",
			base07 = "#ffffff",
			base08 = "#fa4d56",
			base09 = "#ff932b",
			base0A = "#ff7eb6",
			base0B = "#42be65",
			base0C = "#78a9ff",
			base0D = "#3ddbd9",
			base0E = "#f1c21b",
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
-- later(function()
-- 	require("mini.completion").setup()
-- end)
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
