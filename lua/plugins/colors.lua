function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            local referenceColor = "highlight_low"

            require("rose-pine").setup({
                disable_background = true,
                highlight_groups = {
                    LspReferenceRead = { bg = referenceColor },
                    LspReferenceWrite = { bg = referenceColor },
                    LspReferenceText = { bg = referenceColor },

                    SnacksPickerBorder = { fg = "highlight_high", bg = "none" },
                    FloatTitle = { bg = "none" },
                },
            })

            vim.cmd("colorscheme rose-pine")

            ColorMyPencils()
        end,
    },
}
