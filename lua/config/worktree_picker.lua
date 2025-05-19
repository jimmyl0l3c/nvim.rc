local git_worktree = require("git-worktree")

local function get_worktree_dir(item) return vim.fn.fnamemodify(item.item.path, ":t") end

local M = {
    enabled = true,
    title = "Git worktrees",
    preview = "git_log",

    layout = {
        preset = "default",
    },

    ---@type snacks.picker.win.Config
    win = {
        input = {
            keys = {
                ["<c-n>"] = { "create", mode = { "i", "n" } },
                ["<c-x>"] = { "delete", mode = { "i", "n" } },
            },
        },
    },

    ---@type snacks.picker.finder
    finder = function()
        local result = vim.system({ "git", "worktree", "list" }, { cwd = git_worktree.get_root() }):wait()

        if result.code ~= 0 then
            vim.notify("Git command failed: " .. result.stderr, vim.log.levels.ERROR)
            return {}
        end

        local worktrees = {}

        for line in result.stdout:gmatch("[^\r\n]+") do
            for path, commit, branch in line:gmatch("(.-)%s+(%w+)%s+(%b[])") do
                table.insert(worktrees, { path = path, commit = commit, branch = branch })
            end
        end

        local current_worktree = git_worktree.get_current_worktree_path()

        local items = {}
        for idx, worktree in ipairs(worktrees) do
            ---@type snacks.picker.finder.Item
            local item = {
                idx = idx,
                text = Snacks.picker.util.text(worktree, { "branch", "commit", "path" }),
                item = worktree,
                commit = worktree.commit,
                current = current_worktree ~= nil and worktree.path == current_worktree,
            }
            table.insert(items, item)
        end

        return items
    end,

    ---@type snacks.picker.format
    format = function(item, picker)
        local a = Snacks.picker.util.align
        local worktree = item.item

        ---@type snacks.picker.Highlight[]
        local ret = {
            item.current and { a("", 2), "SnacksPickerGitBranchCurrent" } or { a("", 2) },
            { a(worktree.branch, 20, { truncate = true }) },
            { " " },
            { picker.opts.icons.git.commit, "SnacksPickerGitCommit" },
            { a(worktree.commit, 8, { truncate = true }), "SnacksPickerGitCommit" },
            { " " },
        }

        local offset = Snacks.picker.highlight.offset(ret)
        local path = Snacks.picker.format.filename({ text = "", dir = true, file = worktree.path }, picker)
        Snacks.picker.highlight.fix_offset(path, offset)

        vim.list_extend(ret, path)

        return ret
    end,

    actions = {
        confirm = function(picker, item)
            return picker:norm(function()
                picker:close()

                if item ~= nil then
                    vim.notify("Switching worktree: " .. get_worktree_dir(item))
                    git_worktree.switch_worktree(item.item.path)
                else
                    local new_worktree = picker.finder.filter.pattern
                    vim.notify("Creating worktree: " .. new_worktree)
                    git_worktree.create_worktree(new_worktree, new_worktree)
                end
            end)
        end,
        delete = function(picker, item)
            return picker:norm(function()
                picker:close()

                if item.item.path == git_worktree.get_current_worktree_path() then
                    vim.notify("Cannot delete current worktree", vim.log.levels.ERROR)
                    return
                end

                vim.notify("Deleting worktree: " .. get_worktree_dir(item))
                git_worktree.delete_worktree(item.item.path)
            end)
        end,
        create = function(picker, _)
            return picker:norm(function()
                picker:close()

                local new_worktree = picker.finder.filter.pattern
                vim.notify("Creating new: " .. new_worktree)
                git_worktree.create_worktree(new_worktree, new_worktree)
            end)
        end,
    },
}

return M
