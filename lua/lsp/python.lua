local python_stubs_path = vim.fn.stdpath("data") .. "/py-stubs/"

local function py_install_missing_stubs()
    if not vim.uv.fs_stat(python_stubs_path) then vim.fn.mkdir(python_stubs_path, "p") end

    local stubs = {
        { pypi_name = "django-types", lib_name = "django-stubs" },
        { pypi_name = "djangorestframework-types", lib_name = "rest_framework-stubs" },
    }

    local installed_stubs = vim.tbl_map(
        function(value) return vim.fn.fnamemodify(value, ":t") end,
        vim.fn.glob(python_stubs_path .. "/*", false, true)
    )

    local pyright_pip = vim.fn.stdpath("data") .. "/mason/packages/basedpyright/venv/bin/pip3"

    if not vim.uv.fs_stat(pyright_pip) then vim.notify("Cannot install stubs, pyright venv not found") end

    for _, stub in ipairs(stubs) do
        if not vim.tbl_contains(installed_stubs, stub.lib_name) then
            vim.notify("Installing " .. stub.pypi_name)

            vim.fn.system({
                pyright_pip,
                "install",
                stub.pypi_name,
                "--target",
                python_stubs_path,
            })
        end
    end
end

---@class lsp_conf.Language
return {
    mason_packages = { "basedpyright", "ruff" },
    install = py_install_missing_stubs,
    lsp_configs = {
        basedpyright = function(opts)
            return {
                capabilities = opts.capabilities,
                on_attach = opts.on_attach,
                settings = {
                    basedpyright = {
                        disableOrganizeImports = true,
                        analysis = {
                            autoImportCompletions = true,
                            autoSearchPaths = true,
                            diagnosticMode = "workspace",
                            useLibraryCodeForTypes = true,
                            typeCheckingMode = "standard",
                            stubPath = python_stubs_path,
                        },
                    },
                },
            }
        end,

        ruff = function(opts)
            local util = require("lspconfig.util")
            return {
                capabilities = opts.capabilities,
                on_attach = opts.on_attach,
                single_file_support = false,
                root_dir = function(fname)
                    local root_files = {
                        "pyproject.toml",
                        "setup.py",
                        "setup.cfg",
                        "requirements.txt",
                        "Pipfile",
                        "ruff.toml",
                        "manage.py",
                    }
                    return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
                end,
                init_options = {
                    settings = {
                        configuration = vim.fn.stdpath("config") .. "/install/ruff.toml",
                        configurationPreference = "filesystemFirst",
                    },
                },
            }
        end,
    },
}
