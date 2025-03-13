return {
    {
        "tpope/vim-fugitive",
        keys = {
            { "<leader>gs", vim.cmd.Git },
            { "gu", "<cmd>diffget //2<CR>" },
            { "gh", "<cmd>diffget //3<CR>" },
        },
        config = function()
            local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

            local autocmd = vim.api.nvim_create_autocmd
            autocmd("BufWinEnter", {
                group = ThePrimeagen_Fugitive,
                pattern = "*",
                callback = function()
                    if vim.bo.ft ~= "fugitive" then return end

                    local bufnr = vim.api.nvim_get_current_buf()
                    local opts = { buffer = bufnr, remap = false }
                    vim.keymap.set("n", "<leader>p", function() vim.cmd.Git("push") end, opts)

                    -- rebase always
                    vim.keymap.set("n", "<leader>P", function() vim.cmd.Git({ "pull", "--rebase" }) end, opts)

                    -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                    -- needed if i did not set the branch up correctly
                    vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts)
                end,
            })
        end,
    },

    {
        "lewis6991/gitsigns.nvim",
        event = { "VeryLazy" },
        opts = {
            current_line_blame_opts = {
                delay = 0,
            },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map("n", "]c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end)

                map("n", "[c", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end)

                -- Actions
                map("n", "<leader>hs", gitsigns.stage_hunk)
                map("n", "<leader>hr", gitsigns.reset_hunk)
                map("v", "<leader>hs", function() gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
                map("v", "<leader>hr", function() gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end)
                map("n", "<leader>hS", gitsigns.stage_buffer)
                map("n", "<leader>hu", gitsigns.undo_stage_hunk)
                map("n", "<leader>hR", gitsigns.reset_buffer)
                map("n", "<leader>hp", function()
                    gitsigns.toggle_deleted()
                    gitsigns.toggle_linehl()
                    gitsigns.toggle_numhl()
                end)
                map("n", "<leader>hb", function() gitsigns.blame_line({ full = true }) end)
                map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
                map("n", "<leader>td", gitsigns.toggle_deleted)
            end,
        },
    },
}
