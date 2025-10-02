return {
    "Vigemus/iron.nvim",
    config = function()
        local view = require("iron.view")
        local common = require("iron.fts.common")

        require("iron.core").setup({
            config = {
                scratch_repl = true, -- Whether a repl should be discarded or not
                repl_definition = {
                    sh = {
                        -- Can be a table or a function that returns a table
                        command = { "zsh" },
                    },
                    python = {
                        command = { "ipython", "--no-autoindent" },
                        format = common.bracketed_paste_python,
                        block_dividers = { "# %%", "#%%" },
                        env = { PYTHON_BASIC_REPL = "1" }, --this is needed for python3.13 and up.
                    },
                },
                repl_filetype = function(bufnr, ft) return ft end,
                dap_integration = true,
                repl_open_cmd = {
                    view.split.rightbelow("%30"), -- cmd_1: open a repl below
                    view.split.vertical.rightbelow("%40"), -- cmd_2: open a repl to the right
                },
            },
            -- Iron doesn't set keymaps by default anymore.
            keymaps = {
                -- use tmux-like split keymap
                toggle_repl_with_cmd_1 = '<space>r"',
                toggle_repl_with_cmd_2 = "<space>r%",

                -- TODO: set remaining keymaps

                restart_repl = "<space>rR", -- calls `IronRestart` to restart the repl
                -- send_motion = "<space>sc",
                visual_send = "<space>rv",
                send_file = "<space>rf",
                send_line = "<space>rl",
                -- send_paragraph = "<space>sp",
                -- send_until_cursor = "<space>su",
                -- send_mark = "<space>sm",
                -- send_code_block = "<space>sb",
                -- send_code_block_and_move = "<space>sn",
                -- mark_motion = "<space>mc",
                -- mark_visual = "<space>mc",
                -- remove_mark = "<space>md",
                -- cr = "<space>s<cr>",
                -- interrupt = "<space>s<space>",
                exit = "<space>rQ",
                clear = "<space>rC",
            },
            -- If the highlight is on, you can change how it looks
            -- For the available options, check nvim_set_hl
            highlight = {
                italic = true,
            },
            ignore_blank_lines = true,
        })
    end,
}
