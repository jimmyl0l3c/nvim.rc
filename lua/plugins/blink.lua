local default_sources = { "lsp", "path", "snippets", "buffer" }

return {
    {
        "saghen/blink.compat",
        version = "*",
        lazy = true,
        opts = {},
    },

    {
        "saghen/blink.cmp",
        lazy = false, -- lazy loading handled internally
        -- optional: provides snippets for the snippet source
        dependencies = {
            "rafamadriz/friendly-snippets",
            "moyiz/blink-emoji.nvim",
        },
        -- TODO: add LuaSnip

        -- use a release tag to download pre-built binaries
        version = "*",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' for mappings similar to built-in completion
            -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
            -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
            -- see the "default configuration" section below for full documentation on how to define
            -- your own keymap.
            keymap = { preset = "default" },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            completion = {
                ghost_text = { enabled = true },
            },

            -- default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, via `opts_extend`
            sources = {
                default = { "emoji", unpack(default_sources) },
                per_filetype = {
                    lua = { "lazydev", unpack(default_sources) },
                    markdown = {
                        "emoji",
                        "obsidian",
                        "obsidian_new",
                        "obsidian_tags",
                        unpack(default_sources),
                    },
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        fallbacks = { "lsp" },
                    },

                    emoji = {
                        module = "blink-emoji",
                        score_offset = 15, -- Tune by preference
                        opts = { insert = true }, -- Insert emoji (default) or complete its name
                        should_show_items = function()
                            return vim.tbl_contains(
                                -- Enable emoji completion only for git commits and markdown.
                                -- By default, enabled for all file-types.
                                { "gitcommit", "markdown" },
                                vim.o.filetype
                            )
                        end,
                    },

                    obsidian = {
                        name = "obsidian",
                        module = "blink.compat.source",
                    },
                    obsidian_new = {
                        name = "obsidian_new",
                        module = "blink.compat.source",
                    },
                    obsidian_tags = {
                        name = "obsidian_tags",
                        module = "blink.compat.source",
                    },
                },
            },

            -- experimental signature help support
            signature = { enabled = true },
        },
        -- allows extending the enabled_providers array elsewhere in your config
        -- without having to redefine it
        opts_extend = { "sources.completion.enabled_providers" },
    },
}
