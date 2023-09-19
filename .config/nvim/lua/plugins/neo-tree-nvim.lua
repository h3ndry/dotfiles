return {
    "nvim-neo-tree/neo-tree.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 2000, -- make sure to load this before all the other start plugins
    branch = "v3.x",
    dependencies = {
    "nvim-neo-tree/neo-tree.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            hijack_netrw_behavior = "open_current",
            window = {
                position = "current",
            }
        })
    end,
}
