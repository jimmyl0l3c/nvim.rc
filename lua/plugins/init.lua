return {
    {
        "eandrju/cellular-automaton.nvim",
        cmd = "CellularAutomaton",
        keys = { { "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>" } },
    },

    {
        "theprimeagen/vim-be-good",
        cmd = "VimBeGood",
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = { "VeryLazy" },
        opts = {},
    },

    {
        "ThePrimeagen/refactoring.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        cmd = "Refactor",
        config = function() require("refactoring").setup({}) end,
    },

    {
        "echasnovski/mini.surround",
        version = "*",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },

    {
        "echasnovski/mini.splitjoin",
        version = "*",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
    },

    {
        "brenoprata10/nvim-highlight-colors",
        opts = {
            render = "virtual",
            exclude_filetypes = { "lazy" },
            -- exclude_buftypes = { "nofile" },
        },
    },
}
