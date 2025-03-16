local path_package = vim.fn.stdpath("data") .. "/site"
local mini_path = path_package .. "/pack/deps/start/mini.deps"
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.deps`" | redraw')
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
    vim.o.relativenumber = true
    vim.o.tabstop = 4
    vim.o.shiftwidth = 0
    vim.o.expandtab = true
    vim.o.cursorline = true
    vim.o.ignorecase = true
    vim.o.smartcase = true
    vim.o.guicursor = ""
    -- vim.g.netrw_banner = 0
    vim.o.background = "dark"
    vim.g.netrw_bufsettings = "noma nomod nu nobl nowrap ro"
end)
later(function()
    add({ source = "ibhagwan/fzf-lua" })
    require("fzf-lua").setup({
        file_icons = false,
        fzf_colors = true,
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
later(function()
    add({ source = "echasnovski/mini.pairs" })
    require("mini.pairs").setup()
end)
-- later(function()
--     add({ source = "echasnovski/mini.completion })
-- 	   require("mini.completion").setup({
--         -- dont want this to show up unless intentionally
--         delay = { completion = 10 ^ 3.301, info = 10 ^ 3.301, signature = 10 ^ 3.301 },
-- 	})
-- end)
-- later(function()
--     add({ source = "echasnovski/mini.surround })
--     require("mini.surround").setup()
-- end)
now(function()
    -- picker
    vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>")
    vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<cr>")
    vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua grep<cr>")
    vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua lsp_document_diagnostics<cr>")
    vim.keymap.set("n", "<leader>fD", "<cmd>FzfLua lsp_workspace_diagnostics<cr>")

    -- explorer
    vim.keymap.set("n", "<leader>e", "<cmd>Ex<cr>")

    -- buffer nav
    vim.keymap.set("n", "]b", "<cmd>bnext<cr>")
    vim.keymap.set("n", "[b", "<cmd>bprevious<cr>")

    -- trim whitespace
    function TrimWS()
        local save = vim.fn.winsaveview()
        vim.cmd([[keeppatterns %s/\s\+$//e]])
        vim.fn.winrestview(save)
    end
    vim.keymap.set("n", "<leader>tw", TrimWS)

    -- lsp
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
            -- remove this when it becomes default
            vim.keymap.set("n", "grn", "<cmd>lua vim.lsp.buf.rename()<cr>")
            vim.keymap.set("n", "gra", "<cmd>lua vim.lsp.buf.code_action()<cr>")
            vim.keymap.set("n", "grr", "<cmd>lua vim.lsp.buf.references()<cr>")
            vim.keymap.set("i", "<C-s>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
            -- lspconfig does this by default
            -- vim.keymap.set("n", "]d", "<Cmd>lua vim.diagnostic.goto_next()<cr>")
            -- vim.keymap.set("n", "[d", "<Cmd>lua vim.diagnostic.goto_prev()<cr>")
        end,
    })
end)
