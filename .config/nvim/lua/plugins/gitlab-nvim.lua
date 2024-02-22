return {
    "harrisoncramer/gitlab.nvim",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "stevearc/dressing.nvim",     -- Recommended but not required. Better UI for pickers.
        "nvim-tree/nvim-web-devicons" -- Recommended but not required. Icons in discussion tree.
    },
    enabled = true,
    build = function() require("gitlab.server").build(true) end, -- Builds the Go binary
    config = function()
        require("gitlab").setup()
        local gitlab = require("gitlab")
        local wk = require("which-key")

        wk.register({
            l = {
                c = { gitlab.create_mr, "create a merge request" },
                r = { gitlab.review, "review a merge request" },
                -- l = { "<cmd>Octo issue list <cr>", "list open issues on same repo" },
            },
        }, { prefix = "g" })


        -- vim.keymap.set("n", "glr", gitlab.review)
        -- vim.keymap.set("n", "gls", gitlab.summary)
        -- vim.keymap.set("n", "glA", gitlab.approve)
        -- vim.keymap.set("n", "glR", gitlab.revoke)
        -- vim.keymap.set("n", "glc", gitlab.create_comment)
        -- vim.keymap.set("v", "glc", gitlab.create_multiline_comment)
        -- vim.keymap.set("v", "glC", gitlab.create_comment_suggestion)
        -- vim.keymap.set("n", "glO", gitlab.create_mr)
        -- vim.keymap.set("n", "glm", gitlab.move_to_discussion_tree_from_diagnostic)
        -- vim.keymap.set("n", "gln", gitlab.create_note)
        -- vim.keymap.set("n", "gld", gitlab.toggle_discussions)
        -- vim.keymap.set("n", "glaa", gitlab.add_assignee)
        -- vim.keymap.set("n", "glad", gitlab.delete_assignee)
        -- vim.keymap.set("n", "glla", gitlab.add_label)
        -- vim.keymap.set("n", "glld", gitlab.delete_label)
        -- vim.keymap.set("n", "glra", gitlab.add_reviewer)
        -- vim.keymap.set("n", "glrd", gitlab.delete_reviewer)
        -- vim.keymap.set("n", "glp", gitlab.pipeline)
        -- vim.keymap.set("n", "glo", gitlab.open_in_browser)
        -- vim.keymap.set("n", "glM", gitlab.merge)
    end,

}
