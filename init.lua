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

require("mini.deps").setup({ path = { package = path_package } })

local add = MiniDeps.add

add({ source = "ibhagwan/fzf-lua" })
add({ source = "bluz71/vim-moonfly-colors" })
add({ source = "neovim/nvim-lspconfig" })
add({
    source = "nvim-treesitter/nvim-treesitter",
    checkout = "master",
    monitor = "main",
    hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
})
add({
    source = "mfussenegger/nvim-dap",
    depends = { "igorlfs/nvim-dap-view", "theHamsta/nvim-dap-virtual-text" },
})

vim.o.guicursor = ""
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.g.mapleader = vim.keycode("<Space>")
vim.cmd("colorscheme moonfly")

vim.lsp.enable({
    "lua_ls",
    "clangd",
})
vim.diagnostic.config({ virtual_text = true })

require("nvim-treesitter.configs").setup({
    highlight = { enable = true },
})
require("fzf-lua").setup({
    fzf_colors = { true },
})

local dap = require("dap")
local dv = require("dap-view")

dap.listeners.before.attach["dap-view-config"] = function() dv.open() end
dap.listeners.before.launch["dap-view-config"] = function() dv.open() end
dap.listeners.before.event_terminated["dap-view-config"] = function() dv.close(true) end
dap.listeners.before.event_exited["dap-view-config"] = function() dv.close(true) end
-- TODO: nvim-dap config

-- fzf-lua keys
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<cr>")

-- nvim-dap keys
-- TODO
