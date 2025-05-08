return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "artemave/workspace-diagnostics.nvim",
        "elkowar/yuck.vim",
        "j-hui/fidget.nvim",
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
        require("mason-lspconfig").setup({ ensure_installed = {} })

        -- vim.lsp.config("*", {
        --     on_attach = function(client, bufnr)
        --         vim.notify("on_attach client=" .. client.name .. ", buffer=" .. bufnr)
        --         require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
        --     end,
        -- })

        local lsp_configs = require("lsp_config")

        for name, config in pairs(lsp_configs) do
            -- vim.notify("would configure '" .. name .. "' with config " .. vim.inspect(config))
            vim.lsp.config(name, config)
        end

        -- Enable language servers installed manually
        vim.lsp.enable({ "phpactor", "csharp_ls" })
    end,
}
