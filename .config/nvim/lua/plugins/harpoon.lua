return {
    'ThePrimeagen/harpoon',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    event        = "VeryLazy",
    branch       = "harpoon2",
    config       = function()
        local harpoon = require("harpoon")

        -- REQUIRED
        harpoon:setup()
        -- REQUIRED

        vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
        vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

        vim.keymap.set("n", "<leader>hq", function() harpoon:list():select(1) end)
        vim.keymap.set("n", "<leader>hw", function() harpoon:list():select(2) end)
        vim.keymap.set("n", "<leader>he", function() harpoon:list():select(3) end)
        vim.keymap.set("n", "<leader>hr", function() harpoon:list():select(4) end)

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
        vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)


        -- vim.keymap.set("n", "<leader>t", function() harpoon:term()::go end)
        -- vim.keymap.set("n", "<leader>t", function() harpoon:list():next() end)

        vim.keymap.set("n", "<leader>t", ":lua require('harpoon.term').gotoTerminal(1) <CR> ")
        vim.keymap.set("n", "<leader>T", ":lua require('harpoon.term').gotoTerminal(2) <CR> ")
        --
        -- vim.keymap.set("n", "<leader>ha", ":lua require('harpoon.mark').add_file() <CR> ")
        -- vim.keymap.set("n", "<leader>hq", ":lua require('harpoon.ui').nav_file(1) <CR>")
        -- vim.keymap.set("n", "<leader>hw", ":lua require('harpoon.ui').nav_file(2) <CR>")
        -- vim.keymap.set("n", "<leader>he", ":lua require('harpoon.ui').nav_file(3) <CR>")
        -- vim.keymap.set("n", "<leader>hr", ":lua require('harpoon.ui').nav_file(4) <CR>")
        -- vim.keymap.set("n", "<leader>hm", ":lua require('harpoon.ui').toggle_quick_menu()  <CR>")
        -- vim.keymap.set("n", "<leader>hn", ":lua require('harpoon.ui').nav_next() <CR>")
        -- vim.keymap.set("n", "<leader>hp", ":lua require('harpoon.ui').nav_prev()  <CR>")
    end
}
