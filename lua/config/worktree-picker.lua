local git_worktree = require("git-worktree")

local M = {}

local function get_worktree_dir(item) return vim.fn.fnamemodify(item.item.path, ":t") end

function M.git_worktrees()
    Snacks.picker({
        enabled = true,
        title = "Git worktrees",
        layout = {
            preset = "default",
            preview = false,
        },
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

            local items = {}
            for idx, worktree in ipairs(worktrees) do
                ---@type snacks.picker.finder.Item
                local item = {
                    idx = idx,
                    text = Snacks.picker.util.text(worktree, { "branch", "commit", "path" }),
                    item = worktree,
                }
                table.insert(items, item)
            end

            return items
        end,
        format = function(item, picker)
            local a = Snacks.picker.util.align
            local worktree = item.item
            -- TODO: mark current worktree

            ---@type snacks.picker.Highlight[]
            local ret = {
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

                    local worktree_dir = get_worktree_dir(item)
                    git_worktree.switch_worktree(worktree_dir)
                    vim.notify("Switched worktree: " .. worktree_dir)
                end)
            end,
            delete = function(picker, item)
                return picker:norm(function()
                    picker:close()

                    local worktree_dir = get_worktree_dir(item)
                    git_worktree.delete_worktree(worktree_dir)
                    vim.notify("Deleted worktree: " .. worktree_dir)
                end)
            end,
        },
    })
end

return M
