local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.deps"
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.deps`" | redraw')
    local clone_cmd = {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/nvim-mini/mini.deps",
        mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.deps | helptags ALL")
    vim.cmd('echo "Installed `mini.deps`" | redraw')
end

require("mini.deps").setup({ path = { package = path_package } })

vim.o.guicursor = ""
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
vim.g.mapleader = vim.keycode("<Space>")
vim.g.localleader = vim.keycode("<Space>")
vim.o.tabstop = 4
vim.o.shiftwidth = 4

local add = MiniDeps.add

-- ============================== packages ==============================
add({
    source = "neovim/nvim-lspconfig",
    depends = { "williamboman/mason.nvim" },
})

add({
    source = "nvim-treesitter/nvim-treesitter",
    hooks = { post_checkout = function() vim.cmd("TSUpdate") end },
})

add({
    source = "igorlfs/nvim-dap-view",
    depends = { "mfussenegger/nvim-dap", "theHamsta/nvim-dap-virtual-text" },
})

add("ibhagwan/fzf-lua")
add("stevearc/oil.nvim")
add("stevearc/conform.nvim")

-- ============================== keybinds ==============================
local map = function(suffix, cmd) vim.keymap.set("n", suffix, cmd) end
local nmap = function(suffix, cmd) vim.keymap.set("n", "<Leader>" .. suffix, cmd) end

nmap("ff", function() require("fzf-lua").files() end)

nmap("dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end)
nmap("db", function() require("dap").toggle_breakpoint() end)
nmap("dc", function() require("dap").continue() end)
-- nmap("da", function() require("dap").continue({ before = get_args }) end)
nmap("dC", function() require("dap").run_to_cursor() end)
nmap("dg", function() require("dap").goto_() end)
nmap("di", function() require("dap").step_into() end)
nmap("dj", function() require("dap").down() end)
nmap("dk", function() require("dap").up() end)
nmap("dl", function() require("dap").run_last() end)
nmap("do", function() require("dap").step_out() end)
nmap("dO", function() require("dap").step_over() end)
nmap("dP", function() require("dap").pause() end)
nmap("dr", function() require("dap").repl.toggle() end)
nmap("ds", function() require("dap").session() end)
nmap("dt", function() require("dap").terminate() end)
nmap("dw", function() require("dap.ui.widgets").hover() end)
nmap("dv", function() require("dap-view").toggle() end)

nmap("lf", function() require("conform").format({ lsp_fallback = true }) end)

map("-", "<cmd>Oil<cr>")

-- ============================== configs ==============================
vim.lsp.enable({
    "lua_ls",
    "clangd",
    "basedpyright",
    "tsserver",
})

vim.lsp.config("basedpyright", {
    -- capabilities = capabilities,
    settings = {
        basedpyright = {
            analysis = {
                typeCheckingMode = "basic",
            },
        },
    },
})

vim.diagnostic.config({
    virtual_text = {
        true,
        prefix = "●",
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.HINT] = "",
            [vim.diagnostic.severity.INFO] = "",
        },
    },
})

require("mason").setup()
require("nvim-treesitter").install({ "lua", "cpp" })

require("nvim-dap-virtual-text").setup()
local dap = require("dap")
local dv = require("dap-view")

dap.listeners.before.attach["dap-view-config"] = function() dv.open() end
dap.listeners.before.launch["dap-view-config"] = function() dv.open() end
dap.listeners.before.event_terminated["dap-view-config"] = function() dv.close(true) end
dap.listeners.before.event_exited["dap-view-config"] = function() dv.close(true) end

-- adapter config
dap.adapters.codelldb = {
    type = "executable",
    command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

    -- On windows you may have to uncomment this:
    -- detached = false,
}

-- language config
dap.configurations.cpp = {
    {
        name = "Launch file",
        type = "codelldb",
        request = "launch",
        program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
    },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

require("fzf-lua").setup({
    fzf_colors = { true },
})

require("oil").setup()
require("conform").setup({
    formatters_by_ft = {
        lua = { "stylua" },
        cpp = { "clang-format" },
        -- python = { "isort", "black" },
    },
})
