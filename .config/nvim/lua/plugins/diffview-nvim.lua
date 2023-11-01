return {
    "sindrets/diffview.nvim",
    event  = "VeryLazy",
    config = function()
        -- vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory <CR>")
        local wk = require("which-key")
        wk.register({
            g = {
                name = "file",                                               -- optional group name
                H = { "<cmd>DiffviewFileHistory <cr>", "View Git history" }, -- create a binding with label
            },
        }, { prefix = "<leader>" })
    end
}
