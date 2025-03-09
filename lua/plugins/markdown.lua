return {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
        'nvim-tree/nvim-web-devicons'
    },
    lazy = true,
    ft = "markdown",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
    config = function()
        require('render-markdown').setup({
            completions = { lsp = { enabled = true } },
        })
    end
}
