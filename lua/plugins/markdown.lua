return {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    lazy = true,
    ft = "markdown",
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {
        completions = { blink = { enabled = true } },
        checkbox = {
            unchecked = { icon = "󰄱" },
            checked = { icon = "", scope_highlight = "@markup.strikethrough" },
            custom = {
                important = {
                    raw = "[!]",
                    rendered = "",
                    highlight = "DiagnosticWarn",
                    scope_highlight = "@markup.bold",
                },
                cancelled = {
                    raw = "[~]",
                    rendered = "󰰱",
                    highlight = "DiagnosticError",
                    scope_highlight = "@markup.strikethrough",
                },
                followup = {
                    raw = "[>]",
                    rendered = "",
                    highlight = "DiagnosticWarn",
                    scope_highlight = "@markup.bold",
                },
            },
        },
    },
}
