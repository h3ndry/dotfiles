return {
    dependencies = {
        'mfussenegger/nvim-dap-python',
        'mfussenegger/nvim-dap',
        'theHamsta/nvim-dap-virtual-text'
    },
    'rcarriga/nvim-dap-ui',
    config = function()
        require("dapui").setup()
        require("nvim-dap-virtual-text").setup()

        local dap, dapui = require("dap"), require("dapui")
        local widgets = require('dap.ui.widgets')

        vim.keymap.set("n", "<F5>", dap.continue)
        vim.keymap.set("n", "<F10>", dap.step_over)
        vim.keymap.set("n", "<F11>", dap.step_into)
        vim.keymap.set("n", "<F12>", dap.step_out)
        vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
        vim.keymap.set("n", "<Leader>B", dap.set_breakpoint)
        vim.keymap.set("n", "<Leader>lp", dap.set_breakpoint)
        vim.keymap.set("n", "<Leader>dr", dap.repl.open)
        vim.keymap.set("n", "<Leader>dl", dap.run_last)
        vim.keymap.set("n", "<Leader>dK", widgets.hover)
        vim.keymap.set('n', '<leader>d?', function()
            widgets.centered_float(widgets.scopes)
        end)

        -- vim.keymap.set('n', '<leader>di', function() require "dap.ui.widgets".hover() end)
        -- vim.keymap.set('n', '<leader>dh', function() require "dap".toggle_breakpoint() end)
        -- vim.keymap.set('n', '<leader>dH', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
        -- vim.keymap.set({ 'n', 't' }, '<A-k>', function() require "dap".step_out() end)
        -- vim.keymap.set({ 'n', 't' }, "<A-l>", function() require "dap".step_into() end)
        -- vim.keymap.set({ 'n', 't' }, '<A-j>', function() require "dap".step_over() end)
        -- vim.keymap.set({ 'n', 't' }, '<A-h>', function() require "dap".continue() end)
        -- vim.keymap.set('n', '<leader>dn', function() require "dap".run_to_cursor() end)
        -- vim.keymap.set('n', '<leader>dc', function() require "dap".terminate() end)
        -- vim.keymap.set('n', '<leader>dR', function() require "dap".clear_breakpoints() end)
        -- vim.keymap.set('n', '<leader>de', function() require "dap".set_exception_breakpoints({ "all" }) end)
        -- vim.keymap.set('n', '<leader>da', function() require "debugHelper".attach() end)
        -- vim.keymap.set('n', '<leader>dA', function() require "debugHelper".attachToRemote() end)
        -- vim.keymap.set('n', '<leader>di', function() require "dap.ui.widgets".hover() end)
        -- vim.keymap.set('n', '<leader>dk', ':lua require"dap".up()<CR>zz')
        -- vim.keymap.set('n', '<leader>dj', ':lua require"dap".down()<CR>zz')
        -- vim.keymap.set('n', '<leader>dr',
        --     ':lua require"dap".repl.toggle({}, "vsplit")<CR><C-w>l')
        -- vim.keymap.set('n', '<leader>du', ':lua require"dapui".toggle()<CR>')

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

        dap.configurations.javascript = {
            {
                type = "pwa-node",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                cwd = "${workspaceFolder}",
            },
        }


        dap.adapters.firefox = {
            type = 'executable',
            command = 'node',
            args = { '/home/hendry/.npm/dist/adapter.bundle.js' },
        }

        dap.configurations.typescript = {
            {
                name = 'Debug with Firefox',
                type = 'firefox',
                request = 'launch',
                reAttach = true,
                url = 'http://localhost:3000',
                webRoot = '${workspaceFolder}',
                firefoxExecutable = '/usr/bin/firefox'
            }
        }

    end
}
