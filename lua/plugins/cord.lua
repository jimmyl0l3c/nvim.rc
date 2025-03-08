local blacklist_workspaces = {  }
local blacklist_path_patterns = { "source/repos" }

local blacklisted_text = ''

local is_blacklisted = function(opts)
    local cwd = vim.fn.getcwd()

    for _, pattern in ipairs(blacklist_path_patterns) do
        if string.match(cwd, pattern) then
            return true
        end
    end

    return vim.tbl_contains(blacklist_workspaces, opts.workspace)
end

return {
    'vyfor/cord.nvim',
    build = ':Cord update',
    opts = {
        editor = {
            tooltip = "Neovim btw."
        },
        display = {
            swap_fields = true,
            swap_icons = true
        },
        text = {
            workspace = function(opts)
                return is_blacklisted(opts) and 'In a secret workspace' or ('In ' .. opts.workspace)
            end,
            viewing = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Viewing ' .. opts.filename)
            end,
            editing = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Editing ' .. opts.filename)
            end,
            file_browser = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Browsing files in ' .. opts.name)
            end,
            plugin_manager = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Managing plugins in ' .. opts.name)
            end,
            lsp = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Configuring LSP in ' .. opts.name)
            end,
            docs = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Reading ' .. opts.name)
            end,
            vcs = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Committing changes in ' .. opts.name)
            end,
            notes = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Taking notes in ' .. opts.name)
            end,
            debug = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Debugging in ' .. opts.name)
            end,
            test = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Testing in ' .. opts.name)
            end,
            diagnostics = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Fixing problems in ' .. opts.name)
            end,
            games = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Playing ' .. opts.name)
            end,
            terminal = function(opts)
                return is_blacklisted(opts) and blacklisted_text or ('Running commands in ' .. opts.name)
            end,
        }
    }
}
