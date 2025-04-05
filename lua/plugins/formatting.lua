function InstallFormatters() require("lsp").mason_install({ "prettierd" }) end

return {
    "stevearc/conform.nvim",
    dependencies = {
        "williamboman/mason.nvim",
    },
    event = { "BufReadPre", "BufNewFile" },
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>f",
            function()
                require("conform").format({
                    lsp_fallback = true,
                    async = true,
                    -- 500 ms timeout should be sufficient on linux
                    timeout_ms = 1500,
                })
            end,
            mode = { "n", "v" },
            desc = "Format buffer",
        },
    },
    -- This will provide type hinting with LuaLS
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
        -- Define your formatters
        formatters_by_ft = {
            lua = { "stylua" },
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
        -- Set default options
        default_format_opts = {
            lsp_format = "fallback",
        },
        -- Set up format-on-save
        -- format_on_save = { timeout_ms = 500 },
        -- Customize formatters
        formatters = {
            stylua = {
                prepend_args = {
                    "--config-path",
                    vim.fn.stdpath("config") .. "/ls_configs/stylua.toml",
                },
            },
        },
    },
}
