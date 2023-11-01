return {
    "tpope/vim-fugitive",
    dependencies = {
        "shumphrey/fugitive-gitlab.vim",
        "tpope/vim-rhubarb"
    },
    event = "VeryLazy",
    config = function()
        local wk = require("which-key")
        wk.register({
            g = {
                c  = { "<cmd>Git commit -v <cr>", "commit git changes" },
                C  = { "<cmd>Git commit --amend --no-edit <CR> <cr>", "commit git changes without edit" },
                l  = { "<cmd>Octo issue list <cr>", "list open issues on same repo" },
                S  = { "<cmd>Git stash <cr>", "stash git changes" },
                a  = { "<cmd>Git add --update <cr>", "git add updated changes" },
                A  = { "<cmd>Git add --all <cr>", "git add all changes" },
                p  = { "<cmd>Git pull --rebase <cr>", "Git pull and rebase" },
                P  = { "<cmd>Git push -u <cr>", "Git push to remote on the current branch" },
                d  = { "<cmd>Gvdiffsplit! <cr>", "Show git changes in a diff view, merge" },
                w  = { "<cmd>Gwrite! <cr>", "Write git diff changees" },
                rc = { "<cmd>Git rebase --continue <cr>", "git rebase continue" },
                ra = { "<cmd>Git rebase --abort <cr>", "git rebase abort" },
                mt = { "<cmd>Git mergetool <cr>", "git mergetool" },
            },
        }, { prefix = "<leader>" })
    end
}
