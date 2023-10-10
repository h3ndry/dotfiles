return {
    'ThePrimeagen/harpoon',
    dependencies = {
        'nvim-lua/plenary.nvim',
    },
    event        = "VeryLazy",
    config       = function()
        vim.keymap.set("n", "<leader>t", ":lua require('harpoon.term').gotoTerminal(1) <CR> ")
        vim.keymap.set("n", "<leader>T", ":lua require('harpoon.term').gotoTerminal(2) <CR> ")
        vim.keymap.set("n", "<leader>ha", ":lua require('harpoon.mark').add_file() <CR> ")
        vim.keymap.set("n", "<leader>hq", ":lua require('harpoon.ui').nav_file(1) <CR>")
        vim.keymap.set("n", "<leader>hw", ":lua require('harpoon.ui').nav_file(2) <CR>")
        vim.keymap.set("n", "<leader>he", ":lua require('harpoon.ui').nav_file(3) <CR>")
        vim.keymap.set("n", "<leader>hr", ":lua require('harpoon.ui').nav_file(4) <CR>")
        vim.keymap.set("n", "<leader>hm", ":lua require('harpoon.ui').toggle_quick_menu()  <CR>")
        vim.keymap.set("n", "<leader>hn", ":lua require('harpoon.ui').nav_next() <CR>")
        vim.keymap.set("n", "<leader>hp", ":lua require('harpoon.ui').nav_prev()  <CR>")
    end
}
