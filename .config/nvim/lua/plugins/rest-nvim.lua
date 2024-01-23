return {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("rest-nvim").setup({
            result = {
                show_statistics = {
                    {
                        "time_total",
                        title = "Total Time: ",
                        type = "time",
                    },
                }
            }
        })
        vim.keymap.set('n', '<space>R', ":lua require('rest-nvim').run() <CR>")
    end
}
