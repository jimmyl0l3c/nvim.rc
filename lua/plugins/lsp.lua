return {
    "neovim/nvim-lspconfig",
    version = "*",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "artemave/workspace-diagnostics.nvim",
        "elkowar/yuck.vim",
        "rhaiscript/vim-rhai",
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
            vim.lsp.config(name, config)
        end

        -- Enable language servers installed manually
        vim.lsp.enable({ "phpactor", "csharp_ls" })

        -- Enable SetupLsp command
        local lsp_setup = require("lsp_setup")
        vim.api.nvim_create_user_command("SetupLsp", function(opts) lsp_setup.setup(opts.fargs[1]) end, {
            desc = "Install language server with its dependencies if missing",
            nargs = 1,
            complete = function(ArgLead, CmdLine, CursorPos) return vim.tbl_keys(lsp_setup.lang) end,
        })
    end,
}
