return {
    'brenoprata10/nvim-highlight-colors',
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        vim.o.termguicolors = true

        require("nvim-highlight-colors").setup({})
    end,
}
