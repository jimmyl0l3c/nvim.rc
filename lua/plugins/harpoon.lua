return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("harpoon"):setup() end,
    keys = {
        { "<leader>a", function() require("harpoon"):list():add() end, desc = "Add to Harpoon" },
        {
            "<C-e>",
            function()
                local harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "Toggle quick harpoon menu",
        },

        { "<C-h>", function() require("harpoon"):list():select(1) end, desc = "1st harpoon" },
        { "<C-t>", function() require("harpoon"):list():select(2) end, desc = "2nd harpoon" },
        { "<C-n>", function() require("harpoon"):list():select(3) end, desc = "3rd harpoon" },
        { "<C-s>", function() require("harpoon"):list():select(4) end, desc = "4th harpoon" },

        -- Toggle previous & next buffers stored within Harpoon list
        { "<C-S-P>", function() require("harpoon"):list():prev() end, desc = "Next harpoon" },
        { "<C-S-N>", function() require("harpoon"):list():next() end, desc = "Previous harpoon" },
    },
}
