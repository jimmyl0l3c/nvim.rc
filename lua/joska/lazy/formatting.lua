return {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        local conform = require("conform")
        conform.setup({
            formatters_by_ft = {
                -- lua = { "stylua" },
                -- svelte = { { "prettierd", "prettier" } },
                javascript = { "prettierd" },
                typescript = { "prettierd" },
                -- javascriptreact = { { "prettierd", "prettier" } },
                -- typescriptreact = { { "prettierd", "prettier" } },
                json = { "prettierd" },
                markdown = { "prettierd" },
                html = { "prettierd" },
                -- html = { "htmlbeautifier" },
                -- bash = { "beautysh" },
                -- proto = { "buf" },
                -- rust = { "rustfmt" },
                -- yaml = { "yamlfix" },
                yaml = { "prettierd" },
                -- toml = { "taplo" },
                css = { "prettierd" },
                scss = { "prettierd" },
                php = { "php-cs-fixer" },
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>f", function()
            conform.format({
                lsp_fallback = true,
                async = false,
                -- 500 ms timeout should be sufficient on linux
                timeout_ms = 1500,
            })
        end, { desc = "Format file or range (in visual mode)" })
    end,
}
