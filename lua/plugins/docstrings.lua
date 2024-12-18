return {
    "danymat/neogen",

    config = function()
        local neogen = require("neogen")

        neogen.setup({
            -- snippet_engine = "luasnip"
            languages = {
                python = {
                    template = {
                        annotation_convention = "reST"
                    }
                }
            }
        })

        vim.keymap.set("n", "<leader>nf", function()
            neogen.generate({ type = "func" })
        end)

        vim.keymap.set("n", "<leader>nc", function()
            neogen.generate({ type = "class" })
        end)
    end,

    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
}
