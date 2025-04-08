local blacklist_workspaces = {}
local blacklist_path_patterns = { "source/repos" }

local blacklisted_text = ""

local is_blacklisted = function(opts)
    local cwd = vim.fn.getcwd()

    for pattern in vim.iter(blacklist_path_patterns) do
        if string.match(cwd, pattern) then return true end
    end

    return vim.tbl_contains(blacklist_workspaces, opts.workspace)
end

return {
    "vyfor/cord.nvim",
    build = ":Cord update",
    event = { "VeryLazy" },
    opts = {
        editor = {
            tooltip = "Neovim btw.",
        },
        display = {
            swap_fields = true,
            swap_icons = true,
        },
        text = {
            workspace = function(opts)
                return is_blacklisted(opts) and "In a secret workspace" or ("In " .. opts.workspace)
            end,
            viewing = function(opts) return string.format("Viewing %s file", opts.filetype) end,
            editing = function(opts) return string.format("Editing %s file", opts.filetype) end,
            file_browser = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ("Browsing files in " .. opts.name)
            end,
            plugin_manager = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ("Managing plugins in " .. opts.name)
            end,
            lsp = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ("Configuring LSP in " .. opts.name)
            end,
            docs = function(opts) return is_blacklisted(opts) and blacklisted_text or ("Reading " .. opts.name) end,
            vcs = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ("Committing changes in " .. opts.name)
            end,
            notes = function(_) return "Taking notes" end,
            debug = function(_) return "Debugging" end,
            test = function(_) return "Testing" end,
            diagnostics = function(_) return "Fixing problems" end,
            games = function(opts) return is_blacklisted(opts) and blacklisted_text or ("Playing " .. opts.name) end,
            terminal = function(_) return "Running commands" end,
        },
    },
}
