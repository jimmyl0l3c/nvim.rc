return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
    },

    config = function()
        require("telescope").setup({
            defaults = {
                file_ignore_patterns = {
                    "venv",
                    ".venv",
                    "__pycache__",
                    ".git",
                    "node_modules",
                },
            },
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_cursor(),
                },
            },
        })

        require("telescope").load_extension("ui-select")

        local builtin = require("telescope.builtin")

        vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
        vim.keymap.set("n", "<C-p>", builtin.git_files, {})
        vim.keymap.set("n", "<leader>pws", function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set("n", "<leader>pWs", function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set("n", "<leader>ps", function() builtin.grep_string({ search = vim.fn.input("Grep > ") }) end)
        vim.keymap.set("n", "<leader>vh", builtin.help_tags, {})

        vim.keymap.set("n", "<leader>pc", builtin.git_commits, {})
        vim.keymap.set("n", "<leader>pb", builtin.git_branches, {})

        -- TODO: consider keymaps for quickfix, autocommands, loclist and lsp pickers
    end,
}
