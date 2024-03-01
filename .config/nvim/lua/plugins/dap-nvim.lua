return {
    dependencies = {
        'mfussenegger/nvim-dap-python',
        'theHamsta/nvim-dap-virtual-text',
        'rcarriga/nvim-dap-ui',
        'jbyuki/one-small-step-for-vimkind',
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


        local wk = require("which-key")

        wk.register({
            d = {
                s = {
                    o = { dap.step_over, "debuger step over" },
                    i = { dap.step_into, "debuger step in to" },
                },
                c = { dap.continue, "debuger continue" },
                n = { dap.step_over, "debuger next" },
                N = { dap.step_into, "debuger Next" },
                p = { dap.step_out, "debuger Next" },
                d = { dap.toggle_breakpoint, "debuger Next" },
                r = { dap.repl.open, "open debuger repl " },
                l = { dap.run_last, "open debuger repl " },
                k = { widgets.hover, "open debuger repl " }
            }
        }, { prefix = "<leader>" })

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
                    return vim.fn.input('Path to dll', vim.fn.getcwd() .. '/ConsoleApp/bin/Debug/net8.0/ConsoleApp.dll',
                        'file')
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

        dap.configurations.lua = {
            {
                type = 'nlua',
                request = 'attach',
                name = "Attach to running Neovim instance",
            }
        }

        dap.adapters.nlua = function(callback, config)
            callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
        end
    end
}
