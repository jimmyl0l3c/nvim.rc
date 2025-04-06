local obsidian_vaults_path = vim.fn.expand("~") .. "/obsidian-vaults"

return {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    -- ft = "markdown",
    event = {
        "BufReadPre " .. obsidian_vaults_path .. "/*.md",
        "BufNewFile " .. obsidian_vaults_path .. "/*.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "personal",
                path = obsidian_vaults_path .. "/personal",
            },
            {
                name = "work",
                path = obsidian_vaults_path .. "/work",
            },
        },

        ui = { enable = false },
    },
}
