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
    ---@type snacks.Config
    opts = {
        quickfile = { enabled = false },
        scroll = { enabled = false },
        statuscolumn = { enabled = false },

        ---@class snacks.profiler.Config
        profiler = {},
        ---@class snacks.dim.Config
        dim = {},
        ---@class snacks.picker.Config
        picker = {
            enabled = true,
            layouts = {
                ---@class snacks.picker.layout.Config
                default = {
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
                            {
                                win = "list",
                                title = " Results ",
                                title_pos = "center",
                                border = "rounded",
                            },
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
            sources = {
                select = {
                    config = function(opts)
                        if vim.bo.filetype == "python" then
                            -- Increase score of basedpyright
                            opts.sort = function(a, b)
                                local client_a = vim.lsp.get_client_by_id(a.item.ctx.client_id)
                                local client_b = vim.lsp.get_client_by_id(b.item.ctx.client_id)

                                if client_a == nil or client_b == nil then return a.score > b.score end

                                local score_a = a.score or 0
                                local score_b = b.score or 0

                                if client_a.name == "basedpyright" then score_a = score_a + 10 end
                                if client_b.name == "basedpyright" then score_b = score_b + 10 end

                                return score_a > score_b
                            end
                            if opts.items ~= nil then table.sort(opts.items, opts.sort) end
                        end
                        return opts
                    end,
                },
            },
        },
        ---@class snacks.words.Config
        words = { enabled = true },
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
            "<leader>pg",
            function() Snacks.picker.grep() end,
            desc = "Live grep project",
        },
        {
            "<leader>pf",
            function() require("snacks").picker.files({ exclude = file_ignore_patterns }) end,
            desc = "Find files",
        },
        { "<C-p>", function() Snacks.picker.git_files() end, desc = "Find git files" },
        { "<leader>vh", function() Snacks.picker.help() end, desc = "Find help pages" },
        { "<leader>pc", function() Snacks.picker.git_log() end, desc = "Find git commits" },
        { "<leader>pb", function() Snacks.picker.git_branches() end, desc = "Find git branches" },
        {
            "<leader>pws",
            function()
                local word = vim.fn.expand("<cword>")
                Snacks.picker.grep({ search = word, live = false })
            end,
            desc = "Find cword",
        },
        {
            "<leader>pWs",
            function()
                local word = vim.fn.expand("<cWORD>")
                Snacks.picker.grep({ search = word, live = false })
            end,
            desc = "Find cWORD",
        },
        { "<M-n>", function() Snacks.words.jump(1, true) end, desc = "Jump to next reference" },
        { "<M-p>", function() Snacks.words.jump(-1, true) end, desc = "Jump to previous reference" },
        { "<leader>Ps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Bufer" },
        { "db", function() Snacks.bufdelete.delete() end },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Toggle mappins
                Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ts")
                Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>tw")
                Snacks.toggle.treesitter():map("<leader>tT")
                Snacks.toggle.dim():map("<M-d>")

                -- Toggle the profiler
                Snacks.toggle.profiler():map("<leader>Pp")
                -- Toggle the profiler highlights
                Snacks.toggle.profiler_highlights():map("<leader>Ph")
            end,
        })
    end,
}
