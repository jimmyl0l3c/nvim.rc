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

    for stub in vim.iter(stubs) do
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

return {
    ---@class lsp_conf.Language
    setup = {
        mason_packages = { "basedpyright", "ruff" },
        install = py_install_missing_stubs,
    },
    python_stubs_path = python_stubs_path,
}
