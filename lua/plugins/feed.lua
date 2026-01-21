return {
    "neo451/feed.nvim",
    cmd = "Feed",
    ---@module 'feed'
    ---@type feed.config
    opts = {
        feeds = {
            "https://neovim.io/news.xml",
            "https://github.com/neovim/neovim/tags.atom",
            "https://github.com/GloriousEggroll/proton-ge-custom/releases.atom",
            "https://blog.python.org/feeds/posts/default?alt=rss",
            "https://www.djangoproject.com/rss/weblog/",
        },
    },
}
