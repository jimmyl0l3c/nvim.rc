function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

vim.api.nvim_create_user_command("ColorMyPencils", ColorMyPencils, {})

return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            local reference_color = "highlight_low"

            require("rose-pine").setup({
                disable_background = true,
                highlight_groups = {
                    LspReferenceRead = { bg = reference_color },
                    LspReferenceWrite = { bg = reference_color },
                    LspReferenceText = { bg = reference_color },

                    SnacksPickerBorder = { fg = "highlight_high", bg = "none" },
                    FloatTitle = { bg = "none" },
                },
            })

            vim.cmd("colorscheme rose-pine")

            ColorMyPencils()
        end,
    },
}
