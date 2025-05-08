local function load_configs_in_dir(dir)
    local path = vim.fn.stdpath("config") .. "/lua/" .. dir
    local files = vim.fn.glob(path .. "/*.lua", true, true)

    local configs = {}

    for _, file in ipairs(files) do
        -- Skip init.lua
        if not file:match("init%.lua$") then
            local ls_name = vim.fn.fnamemodify(file, ":t:r")
            local module_name = dir .. "." .. ls_name

            configs[ls_name] = require(module_name)
        end
    end

    return configs
end

return load_configs_in_dir("lsp_config")
