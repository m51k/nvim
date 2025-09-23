return {
    "neovim/nvim-lspconfig",
    config = function()
        vim.lsp.enable({
            "lua_ls",
            "clangd",
            "pyright",
            "tsserver",
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
    end,
}
