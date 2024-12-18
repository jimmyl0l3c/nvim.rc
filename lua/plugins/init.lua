return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },

    "eandrju/cellular-automaton.nvim",
    "theprimeagen/vim-be-good",

    {
        "RRethy/vim-illuminate",
        event = { "VeryLazy" },
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "VeryLazy" },
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {},
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {},
    }
}
