return {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim', 'kevinhwang91/promise-async' },
    config = function()
        require("telescope").setup {
            defaults = {
                mappings = {
                    i = { ["<C-h>"] = "which_key" }
                }
            },
            pickers = {},
            extensions = {
                fzf = {
                    override_generic_sorter = false,
                    override_file_sorter = true
                },
            }
        }

        require("telescope").load_extension("fzf")

        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<leader>f", require('telescope.builtin').find_files, opts)
        vim.keymap.set("n", "<leader>b", require('telescope.builtin').buffers, opts)
        vim.keymap.set("n", "<leader>rg", require('telescope.builtin').live_grep, opts)
        vim.keymap.set("n", "<leader>rr", require('telescope.builtin').grep_string, opts)
        vim.keymap.set("n", "<leader>re", require('telescope.builtin').registers, opts)
        vim.keymap.set("n", "<leader>gb", require('telescope.builtin').git_branches, opts)
        vim.keymap.set("n", "<leader>gs", require('telescope.builtin').git_status, opts)
        vim.keymap.set("n", "<leader>m", require('telescope.builtin').marks, opts)
        vim.keymap.set("n", "<leader>gm", require('telescope.builtin').git_commits, opts)
    end
}

--
--
-- {
--     "nvim-telescope/telescope.nvim",
--     config = function()
--         require('telescope').setup {
--             defaults = {
--                 -- Default configuration for telescope goes here:
--                 -- config_key = value,
--                 mappings = {
--                     i = {
--                         -- map actions.which_key to <C-h> (default: <C-/>)
--                         -- actions.which_key shows the mappings for your picker,
--                         -- e.g. git_{create, delete, ...}_branch for the git_branches picker
--                         ["<C-h>"] = "which_key"
--                     }
--                 }
--             },
--             pickers = {
--                 -- Default configuration for builtin pickers goes here:
--                 -- picker_name = {
--                 --   picker_config_key = value,
--                 --   ...
--                 -- }
--                 -- Now the picker_config_key will be applied every time you call this
--                 -- builtin picker
--             },
--             extensions = {
--                 -- Your extension configuration goes here:
--                 -- extension_name = {
--                 --   extension_config_key = value,
--                 -- }
--                 -- please take a look at the readme of the extension you want to configure
--             }
--         }
--     end
-- }
