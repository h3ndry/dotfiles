return {
  'stevearc/overseer.nvim',
  opts = {
    strategy = {
      'terminal',
      auto_scroll = true,
    },
    height = 15,
    task_list = {
      max_height = { 40, 0.5 },
      height = 15,
      direction = 'bottom',
    },
  },
  keys = {
    {
      '<leader>or',
      function()
        vim.cmd [[OverseerRun]]
      end,
      desc = '[OR] Oversee Run',
    },
    {
      '<leader>ot',
      function()
        vim.cmd [[OverseerToggle]]
      end,
      desc = '[OT] Oversee Toggle',
    },
  },
}
