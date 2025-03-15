local file_ignore_patterns = {
    "venv*",
    ".venv*",
    "__pycache__",
    ".git",
    "node_modules",
}

return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
        quickfile = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },

        ---@class snacks.dim.Config
        dim = {}, -- TODO: map a keybind (Snacks.dim())

        ---@class snacks.picker.Config
        picker = {
            enabled = true,
            ---@class snacks.picker.layout.Config
            layout = {
                reverse = true,
                ---@class snacks.layout.Box
                layout = {
                    box = "horizontal",
                    backdrop = false,
                    width = 0.8,
                    height = 0.9,
                    border = "none",
                    {
                        box = "vertical",
                        { win = "list", title = " Results ", title_pos = "center", border = "rounded" },
                        {
                            win = "input",
                            height = 1,
                            border = "rounded",
                            title = "{title} {live} {flags}",
                            title_pos = "center",
                        },
                    },
                    {
                        win = "preview",
                        title = "{preview:Preview}",
                        width = 0.45,
                        border = "rounded",
                        title_pos = "center",
                    },
                },
            },
        },
        ---@class snacks.words.Config
        words = { enabled = true }, -- TODO: add keymap for jumps
        ---@class snacks.notifier.Config
        notifier = { enabled = true },
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
                blocks = { enabled = true },
            },
        },

        styles = {
            input = {
                relative = "cursor",
            },
        },
    },
    keys = {
        {
            "<leader>ps",
            function()
                Snacks.picker.grep({
                    search = vim.fn.input("Grep > "),
                    live = false,
                })
            end,
            desc = "Grep project (not live)",
        },
        {
            "<leader>pf",
            function() require("snacks").picker.files({ exclude = file_ignore_patterns }) end,
            desc = "Find files",
        },
        { "<C-p>", function() Snacks.picker.git_files() end, desc = "Find git files" },
        { "<leader>vh", function() Snacks.picker.help() end, {} },
        { "<leader>pc", function() Snacks.picker.git_log() end, {} },
        { "<leader>pb", function() Snacks.picker.git_branches() end, {} },
        {
            "<leader>pws",
            function()
                local word = vim.fn.expand("<cword>")
                Snacks.picker.grep({ search = word, live = false })
            end,
        },
        {
            "<leader>pWs",
            function()
                local word = vim.fn.expand("<cWORD>")
                Snacks.picker.grep({ search = word, live = false })
            end,
        },
    },
}
