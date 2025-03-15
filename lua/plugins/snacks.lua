return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        picker = { enabled = false },
        quickfile = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },

        ---@class snacks.words.Config
        words = { enabled = true }, -- TODO: add keymap for jumps

        ---@class snacks.dim.Config
        dim = {}, -- TODO: map a keybind (Snacks.dim())

        ---@class snacks.notifier.Config
        notifier = { enabled = true }, -- TODO: replace LSP progression?

        ---@class snacks.indent.Config
        indent = { enabled = true },

        ---@class snacks.dashboard.Config
        dashboard = { enabled = true },

        ---@class snacks.bigfile.Config
        bigfile = {
            enabled = true,
            size = 1.5 * 1024 * 1024, -- 1.5MB
            line_length = 1000, -- average line length (useful for minified files)
            -- Enable or disable features when big file detected
            ---@param ctx {buf: number, ft:string}
            setup = function(ctx)
                if vim.fn.exists(":NoMatchParen") ~= 0 then vim.cmd([[NoMatchParen]]) end
                Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
                vim.b.minianimate_disable = true
                vim.schedule(function()
                    if vim.api.nvim_buf_is_valid(ctx.buf) then vim.bo[ctx.buf].syntax = ctx.ft end
                end)
            end,
        },

        ---@class snacks.input.Config
        input = { enabled = true },

        ---@class snacks.scope.Config
        scope = {
            enabled = true,
            treesitter = {
                ---@type string[]|{enabled?:boolean}
                blocks = { enabled = true },
            },
        },

        styles = {
            input = {
                relative = "cursor",
            },
        },
    },
}
