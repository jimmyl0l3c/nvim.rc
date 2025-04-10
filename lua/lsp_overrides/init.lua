---@class lsp_conf.Language
---@field mason_packages? table<string> packages to be installed using Mason
---@field install? fun() called to install the LS or its dependencies (called after installing Mason packages)
---@field lsp_overrides? table<string, fun(opts: table): table>

local M = {
    lang = {
        ---@class lsp_conf.Language
        python = require("lsp_overrides.python"),

        ---@class lsp_conf.Language
        go = { mason_packages = { "gopls", "goimports" } },

        ---@class lsp_conf.Language
        lua = { mason_packages = { "lua-language-server", "stylua" } },
    },
}

--- Install packages using Mason if missing
---@param package_names table<string>
function M.mason_install(package_names)
    local registry = require("mason-registry")

    for package in vim.iter(package_names) do
        if not registry.is_installed(package) then
            vim.notify("Installing " .. package)
            registry.get_package(package):install()
        end
    end
end

--- Setup LSP for specified language
---@param language_name string
function M.setup(language_name)
    ---@class lsp_conf.Language
    local language = M.lang[language_name]

    if language == nil then
        vim.notify("Language config not found: " .. language_name)
        return
    end

    M.mason_install(language.mason_packages)

    if language.install ~= nil then language.install() end
end

vim.api.nvim_create_user_command("SetupLsp", function(opts) M.setup(opts.fargs[1]) end, {
    desc = "Install language server with its dependencies if missing",
    nargs = 1,
    complete = function(ArgLead, CmdLine, CursorPos) return vim.tbl_keys(M.lang) end,
})

return M
