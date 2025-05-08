---@class vim.lsp.Config
return {
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "ruff.toml",
        "manage.py",
    },
    init_options = {
        settings = {
            configuration = vim.fn.stdpath("config") .. "/ls_configs/ruff.toml",
            configurationPreference = "filesystemFirst",
        },
    },
}
