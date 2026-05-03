return {
  'stevearc/aerial.nvim',
  opts = {
    layout = {
      width = 80,
      min_width = 80,
    },
  },
  -- Optional dependencies
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    {
      '<leader>ae',
      function()
        require('utils.sidebar').close_others 'aerial'
        vim.cmd [[ AerialToggle ]]
      end,
      desc = 'Aerial Toggle',
    },
  },
}
