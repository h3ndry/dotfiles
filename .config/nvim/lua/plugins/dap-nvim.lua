return {
    dependencies = {
        'mfussenegger/nvim-dap-python',
        'theHamsta/nvim-dap-virtual-text',
        'rcarriga/nvim-dap-ui',
        'theHamsta/nvim-dap-virtual-text',
    },
    'mfussenegger/nvim-dap',
    event  = "VeryLazy",
    config = function()
        require("nvim-dap-virtual-text").setup()

        local dap, widgets = require("dap"), require('dap.ui.widgets')

        --         
        dap.defaults.fallback.terminal_win_cmd = '20split new'
        vim.fn.sign_define('DapBreakpoint',
            { text = '●', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapBreakpointRejected',
            { text = '', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapStopped',
            { text = '', texthl = '', linehl = '', numhl = '' })

        vim.keymap.set("n", "<Leader>dc", dap.continue)
        vim.keymap.set("n", "<Leader>dso", dap.step_over)
        vim.keymap.set("n", "<Leader>dn", dap.step_over)
        vim.keymap.set("n", "<Leader>dsi", dap.step_into)
        vim.keymap.set("n", "<Leader>dN", dap.step_into)
        vim.keymap.set("n", "<Leader>dp", dap.step_out)
        vim.keymap.set("n", "<Leader>dd", dap.toggle_breakpoint)
        vim.keymap.set("n", "<Leader>dr", dap.repl.open)
        vim.keymap.set("n", "<Leader>dl", dap.run_last)
        vim.keymap.set("n", "<Leader>dk", widgets.hover)
        vim.keymap.set("n", "<leader>d?", function()
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
                    return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/ConsoleApp/bin/Debug/net8.0/ConsoleApp.dll', 'file')
                end,
            }
        }

        dap.adapters.lldb = {
            type = 'executable',
            command = '', -- adjust as needed, must be absolute path
            name = 'lldb'
        }

        dap.adapters.codelldb = {
            type = 'server',
            port = "${port}",
            executable = {
                -- CHANGE THIS to your path!
                command = '/usr/bin/codelldb',
                args = { "--port", "${port}" },
                -- On windows you may have to uncomment this:
                -- detached = false,
            }
        }

        dap.configurations.rust = {
            {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/target/debug/', 'file')
                end,
                cwd = '${workspaceFolder}',
                stopOnEntry = false,
            },
        }
    end
}
