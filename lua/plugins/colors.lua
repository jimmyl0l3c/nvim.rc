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

                    TelescopeBorder = { fg = "highlight_high", bg = "none" },
                    TelescopeNormal = { bg = "none" },
                    TelescopePromptNormal = { bg = "base" },
                    TelescopeResultsNormal = { fg = "subtle", bg = "none" },
                    TelescopeSelection = { fg = "text", bg = "none" },
                    TelescopeSelectionCaret = { fg = "rose", bg = "rose" },
                },
            })

            vim.cmd("colorscheme rose-pine")

            ColorMyPencils()
        end,
    },
}
