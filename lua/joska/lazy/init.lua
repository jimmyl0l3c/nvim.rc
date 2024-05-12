return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },
    "eandrju/cellular-automaton.nvim",
    "theprimeagen/vim-be-good",
    {
        "lewis6991/gitsigns.nvim",
        event = { "VeryLazy" },
        config = function()
            require("gitsigns").setup({})
        end
    },
    {
        "RRethy/vim-illuminate",
        event = { "VeryLazy" },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "VeryLazy" },
        config = function()
            require("ibl").setup({})
        end
    },
}
