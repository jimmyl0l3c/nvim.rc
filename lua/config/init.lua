-- profile nvim startup
if vim.env.PROF then
    local snacks = vim.fn.stdpath("data") .. "/lazy/snacks.nvim"
    vim.opt.rtp:append(snacks)
    require("snacks.profiler").startup({
        startup = {
            event = "VimEnter", -- stop profiler on this event. Defaults to `VimEnter`
            -- event = "UIEnter",
            -- event = "VeryLazy",
        },
    })
end

-- Setup some globals for debugging (lazy-loaded)
_G.dd = function(...) Snacks.debug.inspect(...) end
_G.bt = function() Snacks.debug.backtrace() end
vim.print = _G.dd -- Override print to use snacks for `:=` command

require("config.set")
require("config.remap")

require("config.lazy_init")

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local yank_group = augroup("HighlightYank", {})
local clean_whitespace = augroup("CleanWhitespace", {})
local lsp_keymap_group = augroup("LspKeymaps", {})

autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = clean_whitespace,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

local function deprecate_keybind(new_bind, func)
    vim.notify('Use "' .. new_bind .. '" instead', "warn")
    func()
end

autocmd("LspAttach", {
    group = lsp_keymap_group,
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

        vim.keymap.set("n", "gr", function() deprecate_keybind("grr", vim.lsp.buf.references) end, opts)
        vim.keymap.set("n", "gi", function() deprecate_keybind("gri", vim.lsp.buf.implementation) end, opts)
        vim.keymap.set("n", "<leader>vca", function() deprecate_keybind("gra", vim.lsp.buf.code_action) end, opts)
        vim.keymap.set("n", "<leader>vrn", function() deprecate_keybind("grn", vim.lsp.buf.rename) end, opts)

        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>voi", function()
            vim.lsp.buf.code_action({
                apply = true,
                filter = function(x) return x.kind == "source.organizeImports.ruff" end,
            })
        end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts) -- TODO: remove in favor of <C-s>?

        vim.keymap.set("n", "<leader>vt", function()
            local current_config = vim.diagnostic.config()
            vim.diagnostic.config({
                virtual_lines = not (current_config or false).virtual_lines,
                virtual_text = not (current_config or false).virtual_text,
            })
        end)
    end,
})

vim.diagnostic.config({ virtual_text = true })
