return {
    {
        "nvim-lua/plenary.nvim",
        name = "plenary",
    },

    {
        "eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
        keys = { { "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>" } },
    },

    { "theprimeagen/vim-be-good", cmd = "VimBeGood" },

    {
        "RRethy/vim-illuminate",
        event = { "VeryLazy" },
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "VeryLazy" },
        opts = {},
    },
}
