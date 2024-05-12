return {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    },
    config = function()
        require("aerial").setup({
            -- TODO: Add keymaps for AerialNext/Prev
            --   on_attach = function(bufnr)
            --       -- Jump forwards/backwards with '{' and '}'
            --       vim.keymap.set("n", "{", ":AerialPrev<CR>", { buffer = bufnr })
            --       vim.keymap.set("n", "}", ":AerialNext<CR>", { buffer = bufnr })
            --   end,
        })

        vim.keymap.set("n", "<leader>pa", ":AerialToggle!<CR>")
    end
}
