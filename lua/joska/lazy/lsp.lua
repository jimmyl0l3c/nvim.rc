function InstallFormatters()
    local registry = require("mason-registry")

    local packages = { 'prettierd' }
    for i = 1, #packages do
        local installed = registry.is_installed(packages[i]);
        if installed == false then
            registry.get_package(packages[i]):install()
        else
            print(string.format("%s is already installed!", packages[i]))
        end
    end
end

return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "tweekmonster/django-plus.vim",
        "artemave/workspace-diagnostics.nvim",
        "folke/neodev.nvim",
    },

    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("fidget").setup({})
        require("mason").setup()
        require("neodev").setup({})

        local workspace_diagnostics = require("workspace-diagnostics")

        -- InstallFormatters()

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "tsserver",
                "angularls",
                "cssls",
                "html",
                "jedi_language_server",
                "ruff_lsp",
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = workspace_diagnostics.populate_workspace_diagnostics,
                    })
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup({
                        capabilities = capabilities,
                        on_attach = workspace_diagnostics.populate_workspace_diagnostics,
                        settings = {
                            Lua = {
                                diagnostics = {
                                    globals = { "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        },
                    })
                end,

                ["jedi_language_server"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.jedi_language_server.setup({
                        capabilities = capabilities,
                        on_attach = workspace_diagnostics.populate_workspace_diagnostics,
                        settings = {},
                    })
                end,

                ["ruff_lsp"] = function()
                    local lspconfig = require("lspconfig")
                    local util = require('lspconfig.util')
                    lspconfig.ruff_lsp.setup({
                        capabilities = capabilities,
                        on_attach = workspace_diagnostics.populate_workspace_diagnostics,
                        single_file_support = false,
                        root_dir = function(fname)
                            local root_files = {
                                'pyproject.toml',
                                'setup.py',
                                'setup.cfg',
                                'requirements.txt',
                                'Pipfile',
                                'ruff.toml',
                            }
                            -- TODO: replace unpack with table.unpack when available
                            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
                        end,
                        init_options = {
                            settings = {
                                args = {},
                            }
                        },
                    })
                end,
                ["angularls"] = function()
                    local lspconfig = require("lspconfig")
                    local util = require('lspconfig.util')
                    lspconfig.angularls.setup({
                        capabilities = capabilities,
                        root_dir = function(fname)
                            local root_files = {
                                'angular.json',
                                'nx.json',
                            }
                            return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
                        end,
                    })
                end,
            }
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' }, -- For luasnip users.
            }, {
                { name = 'buffer' },
            })
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
