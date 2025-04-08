local obsidian_vaults_path = vim.fn.expand("~") .. "/obsidian-vaults"

-- set locale to fix day of the week
os.setlocale("C")

return {
    -- "epwalsh/obsidian.nvim",
    "obsidian-nvim/obsidian.nvim",
    -- version = "*",
    lazy = true,
    -- ft = "markdown",
    event = {
        "BufReadPre " .. obsidian_vaults_path .. "/*.md",
        "BufNewFile " .. obsidian_vaults_path .. "/*.md",
    },
    cmd = {
        "ObsidianWorkspace",
        "ObsidianNew",
        "ObsidianToday",
        "ObsidianYesterday",
        "ObsidianTomorrow",
        "ObsidianDailies",
        "ObsidianQuickSwitch",
    },
    keys = {
        { "<leader>po", "<cmd>ObsidianQuickSwitch<CR>", desc = "Obsidian quick switch" },
        -- TODO: add keybind for yesterday, today, tomorrow or just ObsidianDailies?
        -- TODO: add keybind to paste image
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "personal",
                path = obsidian_vaults_path .. "/personal",
            },
            {
                name = "work",
                path = obsidian_vaults_path .. "/work",
            },
        },

        daily_notes = {
            folder = "daily",
            date_format = "%Y-%m-%d-%a",
            alias_format = "%Y-%m-%d %A",
        },

        picker = {
            name = "snacks.pick",
            note_mappings = {
                insert_link = "<C-l>",
            },
            tag_mappings = {
                -- Add tag(s) to current note.
                tag_note = "<C-x>",
                -- Insert a tag at the current location.
                insert_tag = "<C-l>",
            },
        },

        -- Optional, customize how note IDs are generated given an optional title.
        ---@param title string|?
        ---@return string
        note_id_func = function(title)
            -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            -- In this case a note with the title 'My new note' will be given an ID that looks
            -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
            local suffix = ""
            if title ~= nil then
                -- If title is given, transform it into valid file name.
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                for _ = 1, 4 do
                    suffix = suffix .. string.char(math.random(65, 90))
                end
            end
            return tostring(os.time()) .. "-" .. suffix
        end,

        ui = { enable = false },
    },
}
