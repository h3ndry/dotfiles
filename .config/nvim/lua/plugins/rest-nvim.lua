return {
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local rest_nvim = require("rest-nvim")
        local wk = require("which-key")
        rest_nvim.setup({
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
        wk.register({
            R = { rest_nvim.run, "call the current line in curl" }
        }, {
            prefix = "<leader>",
        })
    end
}
