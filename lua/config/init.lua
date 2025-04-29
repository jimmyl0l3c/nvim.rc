-- Neovim version this config is tested on
local expected_nvim_version = "0.11.1"

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

---@type vim.Version
local current_nvim_version = vim.version()

if not vim.version.eq(expected_nvim_version, current_nvim_version) then
    vim.notify(
        string.format(
            "Invalid neovim version: %d.%d.%d, expected: %s",
            current_nvim_version.major,
            current_nvim_version.minor,
            current_nvim_version.patch,
            expected_nvim_version
        ),
        "warn"
    )
end

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local clean_whitespace = augroup("CleanWhitespace", {})
local lsp_keymap_group = augroup("LspKeymaps", {})

autocmd("TextYankPost", {
    group = augroup("HighlightYank", { clear = true }),
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

--- Show notification with new keybind and do nothing
---@param new_bind string new keybind to do required action
---@param action_name string action name
local function replaced_keybind(new_bind, action_name)
    vim.notify(string.format('%s: use "%s" instead', action_name, new_bind), "error")
end

autocmd("LspAttach", {
    group = lsp_keymap_group,
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)

        -- Replaced keybinds to be removed in the future (when I get used to the new ones)
        vim.keymap.set("n", "gr", function() replaced_keybind("grr", "go_to_references") end, opts)
        vim.keymap.set("n", "<leader>vrr", function() replaced_keybind("grr", "go_to_references") end, opts)
        vim.keymap.set("n", "gi", function() replaced_keybind("gri", "go_to_implementation") end, opts)
        vim.keymap.set("n", "<leader>vca", function() replaced_keybind("gra", "code_action") end, opts)
        vim.keymap.set("n", "<leader>vrn", function() replaced_keybind("grn", "lsp_rename") end, opts)
        vim.keymap.set({ "n", "v" }, "<leader>c", function() replaced_keybind("gc", "comment_code") end)

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

        vim.keymap.set("n", "<leader>vi", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)
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
