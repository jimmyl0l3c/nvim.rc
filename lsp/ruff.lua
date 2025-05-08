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
    settings = {
        single_file_support = false,
    },
    init_options = {
        settings = {
            configuration = vim.fn.stdpath("config") .. "/ls_configs/ruff.toml",
            configurationPreference = "filesystemFirst",
        },
    },
}
