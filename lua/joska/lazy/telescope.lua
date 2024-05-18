return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
    },

    config = function()
        local fb_actions = require("telescope").extensions.file_browser.actions
        require('telescope').setup({
            defaults = {
                file_ignore_patterns = {
                    "venv",
                    "__pycache__",
                    ".git",
                    "node_modules",
                },
            },
            extensions = {
                file_browser = {
                    grouped = true,
                    files = true,
                    add_dirs = true,
                    auto_depth = true,
                    -- theme = "ivy",
                    -- disables netrw and use telescope-file-browser in its place
                    hijack_netrw = true,
                    mappings = {
                        ["i"] = {
                            ["<bs>"] = false,
                        },
                        ["n"] = {
                            ["-"] = fb_actions.backspace,
                            ["%"] = fb_actions.create, -- TODO: always create file
                            ["d"] = fb_actions.create, -- TODO: always create dir
                            ["D"] = fb_actions.remove,
                            ["r"] = false,
                            ["R"] = fb_actions.rename,
                        },
                    },
                },
            },
        })

        require("telescope").load_extension("file_browser")

        vim.keymap.set("n", "<space>pv", function()
            require("telescope").extensions.file_browser.file_browser({
                path = "%:p:h",
                select_buffer = true,
            })
        end)

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
        vim.keymap.set('n', '<C-p>', builtin.git_files, {})
        vim.keymap.set('n', '<leader>pws', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>pWs', function()
            local word = vim.fn.expand("<cWORD>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set('n', '<leader>ps', function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})
    end
}
