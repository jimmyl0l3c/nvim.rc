return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "j-hui/fidget.nvim",
        "artemave/workspace-diagnostics.nvim",
        "elkowar/yuck.vim",
    },

    config = function()
        require("fidget").setup({
            notification = {
                window = {
                    -- Background color opacity in the notification window
                    winblend = 0,
                },
            },
        })

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {},
        })

        local lspconfig = require("lspconfig")

        local config_opts = {
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            on_attach = require("workspace-diagnostics").populate_workspace_diagnostics,
        }

        -- Setup language servers installed manually
        -- TODO: do not use lspconfig.setup
        local servers_to_setup = { "phpactor", "csharp_ls" }

        for value in vim.iter(servers_to_setup) do
            lspconfig[value].setup(config_opts)
        end
    end,
}
