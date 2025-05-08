return {
    settings = {
        basedpyright = {
            disableOrganizeImports = true,
            analysis = {
                autoImportCompletions = true,
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
                typeCheckingMode = "standard",
                stubPath = require("lsp_setup.python").python_stubs_path,
            },
        },
    },
}
