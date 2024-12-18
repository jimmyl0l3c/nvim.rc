return {
    'echasnovski/mini.comment',
    version = '*',
    config = function()
        require("mini.comment").setup({
            options = {
                ignore_blank_line = true
            },
            mappings = {
                comment = "<leader>c",
                comment_line = "<leader>c",
                comment_visual = "<leader>c",
                textobject = "<leader>c",
            }
        })
    end
}
