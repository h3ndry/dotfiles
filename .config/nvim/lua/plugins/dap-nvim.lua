return {
  dependencies = {
    'mfussenegger/nvim-dap-python',
    'theHamsta/nvim-dap-virtual-text',
    'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',
    "mxsdev/nvim-dap-vscode-js"
  },
  'mfussenegger/nvim-dap',
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

    --         

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        -- 💀 Make sure to update this path to point to your installation
        args = { "/home/hendry/.local/bin/js-debug/src/dapDebugServer.js", "${port}" },
      }
    }

    require("dap-vscode-js").setup({
      node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
      debugger_path = "/home/hendry/workspace/vscode-js-debug", -- Path to vscode-js-debug installation.
      -- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
      adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }, -- which adapters to register in nvim-dap
      -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
      -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
      -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
    })


    for _, language in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require 'dap.utils'.pick_process,
          cwd = "${workspaceFolder}",
        }

      }
    end
  end
}
