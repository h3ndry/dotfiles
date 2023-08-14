return {
  dependencies = {
    'mfussenegger/nvim-dap-python',
    'theHamsta/nvim-dap-virtual-text',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
  },
  'mfussenegger/nvim-dap',
  event        = "VeryLazy",
  config = function()
    require("nvim-dap-virtual-text").setup()

    local dap, widgets = require("dap"), require('dap.ui.widgets')

    dap.defaults.fallback.terminal_win_cmd = '20split new'
    vim.fn.sign_define('DapBreakpoint',
      { text = '', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected',
      { text = '', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped',
      { text = '', texthl = '', linehl = '', numhl = '' })

    vim.keymap.set("n", "<F5>", dap.continue)
    vim.keymap.set("n", "<F10>", dap.step_over)
    vim.keymap.set("n", "<F11>", dap.step_into)
    vim.keymap.set("n", "<F12>", dap.step_out)
    vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
    vim.keymap.set("n", "<Leader>B", dap.set_breakpoint)
    -- vim.keymap.set("n", "<Leader>lp", dap.set_breakpoint)
    vim.keymap.set("n", "<Leader>dr", dap.repl.open)
    vim.keymap.set("n", "<Leader>dl", dap.run_last)
    vim.keymap.set("n", "<Leader>dk", widgets.hover)
    vim.keymap.set('n', '<leader>d?', function()
      widgets.centered_float(widgets.scopes)
    end)


    dap.adapters.coreclr = {
      type = 'executable',
      command = '/usr/bin/netcoredbg',
      args = { '--interpreter=vscode' }
    }

    dap.configurations.cs = {
      {
        type = "coreclr",
        name = "launch - netcoredbg",
        request = "launch",
        stopAtEntry = false,
        preLaunchTask = "build",
        program = function()
          return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/api/bin/Debug/net7.0/api.dll', 'file')
        end,
      }
    }

    --         
  end
}
