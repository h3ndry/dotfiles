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
        vim.keymap.set('n', '<leader>f', builtin.find_files, {})
        vim.keymap.set('n', '<leader>ls', builtin.buffers, {})
        vim.keymap.set('n', '<leader>rg', extensions.live_grep_args.live_grep_args, {})
        vim.keymap.set('n', '<leader>rr', builtin.grep_string, {})
        vim.keymap.set('n', '<leader>re', builtin.registers, {})
        vim.keymap.set("n", "<leader>gb", builtin.git_branches)
        vim.keymap.set("n", "<leader>gs", builtin.git_status)
        vim.keymap.set("n", "<leader>m", builtin.marks)
        vim.keymap.set('n', '<leader>u', extensions.undo.undo, {})
        -- vim.keymap.set("n", "<leader>gm", builtin.git_commits)
    end
}
