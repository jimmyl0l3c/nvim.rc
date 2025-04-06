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
            automatic_installation = false,
        })

        local lspconfig = require("lspconfig")

        local config_opts = {
            capabilities = require("blink.cmp").get_lsp_capabilities(),
            on_attach = require("workspace-diagnostics").populate_workspace_diagnostics,
        }

        -- Setup language servers installed manually
        local servers_to_setup = { "phpactor", "csharp_ls" }

        for value in vim.iter(servers_to_setup) do
            lspconfig[value].setup(config_opts)
        end

        -- Setup language servers installed with Mason
        local mason_handlers = {
            function(server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup(config_opts)
            end,
        }

        for _, lang in pairs(require("lsp_overrides.init").lang) do
            if not lang.lsp_overrides then goto continue end

            for ls_name, ls_config in pairs(lang.lsp_overrides) do
                mason_handlers[ls_name] = function()
                    local opts = ls_config(config_opts)
                    require("lspconfig")[ls_name].setup(opts)
                end
            end

            ::continue::
        end

        require("mason-lspconfig").setup_handlers(mason_handlers)
    end,
}
