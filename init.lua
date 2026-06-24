---@diagnostic disable: missing-fields, undefined-field

vim.g.mapleader = vim.keycode("<Space>")
vim.g.localleader = vim.keycode("<Space>")
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true

-- clipboard tool: xclip/xsel/win32yank
vim.opt.clipboard = "unnamedplus"

vim.opt.undofile = true
vim.opt.signcolumn = "yes"
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
vim.opt.inccommand = "split"

vim.opt.cursorline = true
-- vim.o.guicursor = ""

vim.opt.hlsearch = true

vim.opt.breakindent = true

vim.opt.wrap = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.textwidth = 80

-- completion
vim.opt.completeopt = { "menuone", "noselect", "popup", "fuzzy" }
vim.opt.pumheight = 10

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
        },
    },
    virtual_text = true,
})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- colorscheme
vim.pack.add({ "https://github.com/bluz71/vim-moonfly-colors" }, { confirm = false })
vim.cmd.colorscheme("moonfly")

-- lsp
vim.pack.add({
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
}, { confirm = false })

local lsp_servers = {
    lua_ls = {
        Lua = { workspace = { library = vim.api.nvim_get_runtime_file("lua", true) } },
    },
    clangd = {},
    rust_analyzer = {},
    gopls = {},
    ts_ls = {},
    basedpyright = {},
}

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
    ensure_installed = vim.tbl_keys(lsp_servers),
})

for server, config in pairs(lsp_servers) do
    vim.lsp.config(server, {
        settings = config,

        on_attach = function(client, bufnr)
            if client:supports_method("textDocument/completion") then
                vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
            end

            vim.keymap.set("n", "grd", vim.lsp.buf.definition, { buffer = bufnr, desc = "vim.lsp.buf.definition()" })

            vim.keymap.set("n", "grf", vim.lsp.buf.format, { buffer = bufnr, desc = "vim.lsp.buf.format()" })
        end,
    })
end

-- snippet placeholder navigation
vim.keymap.set({ "i", "s" }, "<C-k>", function()
    if vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
    end
end, { desc = "Snippet jump forward" })

vim.keymap.set({ "i", "s" }, "<C-j>", function()
    if vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
    end
end, { desc = "Snippet jump backward" })

-- debugger
vim.pack.add({
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    -- "https://github.com/igorlfs/nvim-dap-view",
    "https://github.com/MironPascalCaseFan/debugmaster.nvim",
}, { confirm = false })

require("nvim-dap-virtual-text").setup()
local dap = require("dap")
local dm = require("debugmaster")
-- local dv = require("dap-view")

-- dm.plugins.cursor_hl.enabled = false

vim.keymap.set({ "n", "v" }, "<leader>d", dm.mode.toggle, { nowait = true })
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- dap.listeners.before.attach["dap-view-config"] = function() dv.open() end
-- dap.listeners.before.launch["dap-view-config"] = function() dv.open() end
-- dap.listeners.before.event_terminated["dap-view-config"] = function() dv.close(true) end
-- dap.listeners.before.event_exited["dap-view-config"] = function() dv.close(true) end

-- adapter config
dap.adapters.codelldb = {
    type = "executable",
    command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"

    -- On windows you may have to uncomment this:
    -- detached = false,
    detached = vim.fn.has("win32") == 0,
}
dap.adapters.delve = function(callback, config)
    if config.mode == "remote" and config.request == "attach" then
        callback({
            type = "server",
            host = config.host or "127.0.0.1",
            port = config.port or "38697",
        })
    else
        callback({
            type = "server",
            port = "${port}",
            executable = {
                command = "dlv",
                args = { "dap", "-l", "127.0.0.1:${port}", "--log", "--log-output=dap" },
                detached = vim.fn.has("win32") == 0,
            },
        })
    end
end
dap.adapters["pwa-node"] = {
    type = "server",
    host = "127.0.0.1",
    port = "${port}",
    executable = {
        command = "node",
        args = {
            vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
            "${port}",
            "127.0.0.1",
        },
        detached = vim.fn.has("win32") == 0,
    },
}

-- language config
for _, language in ipairs({ "cpp", "c", "rust" }) do
    dap.configurations[language] = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {
        type = "delve",
        name = "Debug",
        request = "launch",
        program = "${file}",
    },
    {
        type = "delve",
        name = "Debug test", -- configuration for debugging test files
        request = "launch",
        mode = "test",
        program = "${file}",
    },
    -- works with go.mod packages and sub packages
    {
        type = "delve",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}",
    },
}
for _, language in ipairs({ "typescript", "javascript" }) do
    dap.configurations[language] = {
        {
            type = "pwa-node",
            request = "attach",
            name = "Attach",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
        },
    }
end

-- vim.keymap.set("n", "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "[D]ebug set [B]reakpoint (condition)" })
-- vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "[D]ebug toggle [B]reakpoint" })
-- vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "[D]ebug [C]ontinue" })
-- -- vim.keymap.set("n", "<leader>da", function() require("dap").continue({ before = get_args }) end, { desc = "[D]ebug [A]rguments" })
-- vim.keymap.set("n", "<leader>dC", function() require("dap").run_to_cursor() end, { desc = "[D]ebug run to [C]ursor" })
-- vim.keymap.set("n", "<leader>dg", function() require("dap").goto_() end, { desc = "[D]ebug [G]oto" })
-- vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "[D]ebug step [I]nto" })
-- vim.keymap.set("n", "<leader>dj", function() require("dap").down() end, { desc = "[D]ebug [J](down)" })
-- vim.keymap.set("n", "<leader>dk", function() require("dap").up() end, { desc = "[D]ebug [K](up)" })
-- vim.keymap.set("n", "<leader>dl", function() require("dap").run_last() end, { desc = "[D]ebug run [L]ast" })
-- vim.keymap.set("n", "<leader>do", function() require("dap").step_out() end, { desc = "[D]ebug step [O]ut" })
-- vim.keymap.set("n", "<leader>dO", function() require("dap").step_over() end, { desc = "[D]ebug step [O]ver" })
-- vim.keymap.set("n", "<leader>dP", function() require("dap").pause() end, { desc = "[D]ebug [P]ause" })
-- vim.keymap.set("n", "<leader>dr", function() require("dap").repl.toggle() end, { desc = "[D]ebug [R]EPL toggle" })
-- vim.keymap.set("n", "<leader>ds", function() require("dap").session() end, { desc = "[D]ebug [S]ession" })
-- vim.keymap.set("n", "<leader>dt", function() require("dap").terminate() end, { desc = "[D]ebug [T]erminate" })
-- vim.keymap.set("n", "<leader>dw", function() require("dap.ui.widgets").hover() end, { desc = "[D]ebug [W]idgets hover" })
-- vim.keymap.set("n", "<leader>dv", function() require("dap-view").toggle() end, { desc = "[D]ebug [V]iew toggle" })

-- fuzzy finder
-- vim.pack.add({ "https://github.com/ibhagwan/fzf-lua.git" }, { confirm = false })
-- require("fzf-lua").setup({ fzf_colors = { true }})
--
-- vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", { desc = "[F]ind [F]ile", })

vim.pack.add({ "https://github.com/folke/snacks.nvim" }, { confirm = false })

require("snacks").setup({
    bigfile = { enabled = true },
    indent = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },
    statuscolumn = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    bufdelete = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    toggle = { enabled = true },
})

-- picker
vim.keymap.set("n", "<leader><leader>", function() Snacks.picker.smart() end, { desc = "Smart Smart Find" })
vim.keymap.set("n", "<leader>e", function() Snacks.explorer() end, { desc = "Snacks Explorer" })
vim.keymap.set("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Snacks Find Buffer" })
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Snacks Find Files" })

-- words: jump between LSP references under cursor
vim.keymap.set({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Next Reference" })
vim.keymap.set({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Prev Reference" })

-- notifier: review notification history
vim.keymap.set("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Notification History" })
vim.keymap.set("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Dismiss All Notifications" })

-- git
vim.keymap.set("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Git Status" })
vim.keymap.set("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Git Branches" })
vim.keymap.set("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Git Log" })
vim.keymap.set("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Git Log File" })
vim.keymap.set("n", "<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Git Log Line" })
vim.keymap.set("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Git Diff (Hunks)" })
vim.keymap.set("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Git Stash" })

vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse" })

-- mini.nvim
vim.pack.add({ "https://github.com/echasnovski/mini.nvim" }, { confirm = false })

require("mini.ai").setup()
require("mini.surround").setup()
require("mini.pairs").setup()

require("mini.diff").setup()
-- default operators: `gh` apply hunk, `gH` reset hunk, `gh` is also a hunk textobject
vim.keymap.set(
    "n",
    "<leader>go",
    function() require("mini.diff").toggle_overlay(0) end,
    { desc = "Toggle Diff Overlay" }
)

require("mini.git").setup()

vim.keymap.set(
    { "n", "x" },
    "<leader>gc",
    function() require("mini.git").show_at_cursor() end,
    { desc = "Git Show At Cursor (blame/commit)" }
)

-- sidekick
vim.pack.add({ "https://github.com/folke/sidekick.nvim" }, { confirm = false })

require("sidekick").setup({
    cli = {
        mux = {
            backend = "tmux",
            enabled = true,
        },
    },
})

vim.keymap.set("n", "<tab>", function()
    if not require("sidekick").nes_jump_or_apply() then return "<Tab>" end
end, { expr = true, desc = "Goto/Apply Next Edit Suggestion" })

vim.keymap.set(
    { "n", "t", "i", "x" },
    "<c-.>",
    function() require("sidekick.cli").focus() end,
    { desc = "Sidekick Focus" }
)

vim.keymap.set("n", "<leader>aa", function() require("sidekick.cli").toggle() end, { desc = "Sidekick Toggle CLI" })
vim.keymap.set("n", "<leader>as", function() require("sidekick.cli").select() end, { desc = "Select CLI" })
vim.keymap.set("n", "<leader>ad", function() require("sidekick.cli").close() end, { desc = "Detach a CLI Session" })
vim.keymap.set(
    { "x", "n" },
    "<leader>at",
    function() require("sidekick.cli").send({ msg = "{this}" }) end,
    { desc = "Send This" }
)
vim.keymap.set(
    "n",
    "<leader>af",
    function() require("sidekick.cli").send({ msg = "{file}" }) end,
    { desc = "Send File" }
)
vim.keymap.set(
    "x",
    "<leader>av",
    function() require("sidekick.cli").send({ msg = "{selection}" }) end,
    { desc = "Send Visual Selection" }
)
vim.keymap.set(
    { "n", "x" },
    "<leader>ap",
    function() require("sidekick.cli").prompt() end,
    { desc = "Sidekick Select Prompt" }
)
vim.keymap.set(
    "n",
    "<leader>ac",
    function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
    { desc = "Sidekick Toggle Claude" }
)

-- whichkey
vim.pack.add({ "https://github.com/folke/which-key.nvim" }, { confirm = false })

require("which-key").setup({
    spec = {
        { "<leader>f", group = "[F]ind" },
        { "<leader>d", group = "[D]ebug" },
        { "<leader>a", group = "[A]I/Sidekick" },
    },
})

-- vim.pack.update()
