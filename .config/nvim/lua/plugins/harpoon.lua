return {
    'ThePrimeagen/harpoon',
    dependencies = {
        'nvim-lua/plenary.nvim',
         'https://gitlab.com/davvid/harpoon-term.nvim'
    },
    event        = "VeryLazy",
    branch       = "harpoon2",
    config       = function()
        local harpoon = require("harpoon")
        harpoon:setup()
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

        vim.keymap.set("n", "<leader>t", ":lua require('harpoon_term').goto_terminal(1)  <CR> ")
        vim.keymap.set("n", "<leader>T", ":lua require('harpoon_term').goto_terminal(2)  <CR> ")
        --
    end
}
