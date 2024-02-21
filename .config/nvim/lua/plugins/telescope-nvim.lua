return {
    'nvim-telescope/telescope.nvim',
    event        = "VeryLazy",
    dependencies = {
        'nvim-lua/plenary.nvim',
        "debugloop/telescope-undo.nvim",
        "nvim-telescope/telescope-live-grep-args.nvim"
    },
    config       = function()
        require("telescope").setup {
            defaults = {
                mappings = {
                    i = { ["<C-h>"] = "which_key" }
                }
            },
            pickers = {},
            extensions = {
                fzf = {
                    override_generic_sorter = true,
                    override_file_sorter = true
                },
            }
        }
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("undo")

        local builtin = require('telescope.builtin')
        local extensions = require('telescope').extensions
        local wk = require("which-key")

        wk.register({
            f = { builtin.find_files, "search files in project" },
            u = { extensions.undo.undo, "seach undo three" },
            r = {
                r = { builtin.grep_string, "search current word in project" },
                g = { extensions.live_grep_args.live_grep_args, "live grep inside the project" }
            },
            l = {
                s = { builtin.buffers, "list open buffers" }
            },
            g = {
                b = { builtin.git_branches, "show git branch" },
                s = { builtin.git_status, "show git status" },
                S = { builtin.git_stash, "stash git channges" },
                m = {}
            }
        }, { prefix = "<leader>" })
    end
}
