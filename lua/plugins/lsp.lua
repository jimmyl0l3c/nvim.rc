return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "saghen/blink.cmp",
        "j-hui/fidget.nvim",
        "artemave/workspace-diagnostics.nvim",
        "elkowar/yuck.vim",
    },

    config = function()
        require("fidget").setup({
            notification = {
                window = {
                    winblend = 0, -- Background color opacity in the notification window
                },
            },
        })

        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = { "lua_ls", "basedpyright", "ruff" },
            automatic_installation = false,
        })

        local workspace_diagnostics = require("workspace-diagnostics")
        local capabilities = require("blink.cmp").get_lsp_capabilities()

        local lspconfig = require("lspconfig")

        -- Setup language servers installed manually
        local serversToSetup = { "phpactor", "csharp_ls" }

        for _, value in ipairs(serversToSetup) do
            lspconfig[value].setup({
                capabilities = capabilities,
                on_attach = workspace_diagnostics.populate_workspace_diagnostics,
            })
        end

        -- Setup language servers installed with Mason
        require("mason-lspconfig").setup_handlers({
            function(server_name) -- default handler (optional)
                require("lspconfig")[server_name].setup({
                    capabilities = capabilities,
                    on_attach = workspace_diagnostics.populate_workspace_diagnostics,
                })
            end,

            ["basedpyright"] = function()
                require("lspconfig").basedpyright.setup({
                    capabilities = capabilities,
                    on_attach = workspace_diagnostics.populate_workspace_diagnostics,
                    settings = {
                        basedpyright = {
                            disableOrganizeImports = true,
                            analysis = {
                                autoImportCompletions = true,
                                autoSearchPaths = true,
                                diagnosticMode = "workspace",
                                useLibraryCodeForTypes = true,
                                typeCheckingMode = "standard",
                            },
                        },
                    },
                })
            end,

            ["ruff"] = function()
                local util = require("lspconfig.util")
                require("lspconfig").ruff.setup({
                    capabilities = capabilities,
                    on_attach = workspace_diagnostics.populate_workspace_diagnostics,
                    single_file_support = false,
                    root_dir = function(fname)
                        local root_files = {
                            "pyproject.toml",
                            "setup.py",
                            "setup.cfg",
                            "requirements.txt",
                            "Pipfile",
                            "ruff.toml",
                        }
                        return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
                    end,
                    init_options = {
                        settings = {
                            args = {},
                        },
                    },
                })
            end,
        })

        --    ["angularls"] = function()
        --        local lspconfig = require("lspconfig")
        --        local util = require('lspconfig.util')
        --        lspconfig.angularls.setup({
        --            capabilities = capabilities,
        --            root_dir = function(fname)
        --                local root_files = {
        --                    'angular.json',
        --                    'nx.json',
        --                }
        --                return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
        --            end,
        --        })
        --    end,

        --    vim.diagnostic.config({
        --        -- update_in_insert = true,
        --        float = {
        --            focusable = false,
        --            style = "minimal",
        --            border = "rounded",
        --            source = "always",
        --            header = "",
        --            prefix = "",
        --        },
        --    })
    end,
}
