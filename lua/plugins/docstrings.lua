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
    cmd = "Neogen",
    keys = {
        { "<leader>nf", "<CMD>Neogen func<CR>" },
        { "<leader>nc", "<CMD>Neogen class<CR>" },
        { "<leader>nt", "<CMD>Neogen type<CR>" },
        { "<leader>nF", "<CMD>Neogen file<CR>" },
    },
}
