return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        { "antosha417/nvim-lsp-file-operations", config = true },
        { "folke/neodev.nvim", opts = {} },
    },
    config = function()
        local lspconfig = require("lspconfig")
        local mason_lspconfig = require("mason-lspconfig")
        local cmp_nvim_lsp = require("cmp_nvim_lsp")

        local keymap = vim.keymap -- for conciseness

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

        local capabilities = cmp_nvim_lsp.default_capabilities()
        local robotframework_ls_restarted = false
        local cwd = vim.fn.getcwd()

        -- 1. find venv folder in current dir or 1 level deeper (venv/ or proj/venv)
        local function find_venv(start_path) -- Finds the venv folder required for LSP
            -- Check current directory (if venv folder is at root)
            local venv_path = start_path .. "/venv"
            if vim.fn.isdirectory(venv_path) == 1 then
                return venv_path
            end
            -- Check one level deeper (e.g if venv is in proj/venv)
            local handle = vim.loop.fs_scandir(start_path)
            if handle then
                while true do
                    local name, type = vim.loop.fs_scandir_next(handle)
                    if not name then break end
                    if type == "directory" then
                        venv_path = start_path .. "/" .. name .. "/venv"
                        if vim.fn.isdirectory(venv_path) == 1 then
                            return venv_path
                        end
                    end
                end
            end

            return nil
        end

        mason_lspconfig.setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({
                    capabilities = capabilities,
                })
            end,
            ["lua_ls"] = function()
                lspconfig["lua_ls"].setup({
                    capabilities = capabilities,
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                        },
                    },
                })
            end,
            ["robotframework_ls"] = function()
                lspconfig["robotframework_ls"].setup({
                    capabilities = capabilities,
                    settings = {
                        robot = {
                            python = {
                                executable = cwd.."/venv/bin/python3"
                            } ,
                        },
                    },
                    on_init = function(client)
                        if not robotframework_ls_restarted then -- Only proceed if we haven't restarted yet
                            local venv_path = find_venv(cwd)
                            if venv_path then
                                print("Venv folder found: " .. venv_path)
                                vim.env.VIRTUAL_ENV = venv_path
                                vim.env.PATH = venv_path .. "/bin:" .. vim.env.PATH

                                -- Set the flag to true
                                robotframework_ls_restarted = true

                                vim.schedule(function()
                                    vim.cmd('LspRestart robotframework_ls')
                                    print("robotframework_ls restarted with new venv settings")
                                end)
                            else
                                print("No venv folder found in or one level below current directory: " .. cwd)
                            end
                        end
                        return true
                    end,
                })
            end,
        })
    end,
}
