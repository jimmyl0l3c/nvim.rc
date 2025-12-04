function ToggleCursor()
    local cursor_hl = vim.api.nvim_get_hl(0, { name = "Cursor" })

    if cursor_hl.blend == 100 then
        vim.cmd("hi Cursor blend=0")
        vim.cmd("hi lCursor blend=0")
        vim.opt.guicursor:remove({ "a:Cursor/lCursor" })
        return
    end

    vim.opt.termguicolors = true
    vim.cmd("hi Cursor blend=100")
    vim.cmd("hi lCursor blend=100")
    vim.opt.guicursor:append({ "a:Cursor/lCursor" })
end

vim.api.nvim_create_user_command("ToggleCursor", ToggleCursor, { desc = "Toggle cursor visibility" })

vim.keymap.set("n", "<leader>tc", ToggleCursor, { desc = "Toggle cursor visibility" })

return {
    {
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
    },

    { "tjdevries/present.nvim", cmd = "PresentStart" },
}
