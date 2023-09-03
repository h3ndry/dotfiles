return {
  'nvim-telescope/telescope.nvim',
  -- event        = "VeryLazy",
  dependencies = { 'nvim-lua/plenary.nvim' },
  config       = function()
    require("telescope").setup ( {} )

    -- require("telescope").load_extension("fzf")


    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>f', builtin.find_files, {})
    vim.keymap.set('n', '<leader>bf', builtin.buffers, {})
    vim.keymap.set('n', '<leader>rg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>rr', builtin.grep_string, {})
    vim.keymap.set('n', '<leader>re', builtin.registers, {})
    vim.keymap.set("n", "<leader>gb", builtin.git_branches)
    vim.keymap.set("n", "<leader>gs", builtin.git_status)
    vim.keymap.set("n", "<leader>m", builtin.marks)
    vim.keymap.set("n", "<leader>gm", builtin.git_commits)
  end
}
