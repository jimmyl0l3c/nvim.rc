return {
    "danymat/neogen",
    opts = {
        -- snippet_engine = "luasnip"
        languages = {
            python = {
                template = {
                    annotation_convention = "reST",
                },
            },
        },
    },
    keys = {
        { "<leader>nf", "<CMD>Neogen func<CR>" },
        { "<leader>nc", "<CMD>Neogen class<CR>" },
    },
}
