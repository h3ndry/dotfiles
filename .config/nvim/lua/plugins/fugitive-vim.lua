return {
    "tpope/vim-fugitive",
    config = function()
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<leader>gc", ":Git commit -v <CR>", opts)
        vim.keymap.set("n", "<leader>gC", ":Git commit --amend --no-edit <CR>", opts)
        vim.keymap.set("n", "<leader>gS", ":Git stash", opts)
        vim.keymap.set("n", "<leader>gSa", ":Git stash apply", opts)
        vim.keymap.set("n", "<leader>G", ":Git ", opts)
        vim.keymap.set("n", "<leader>ga", ":Git add --update <CR> ", opts)
        vim.keymap.set("n", "<leader>gp", ":Git pull <CR>", opts)
        vim.keymap.set("n", "<leader>gP", ":Git push <CR>", opts)
        vim.keymap.set("n", "<leader>gm", ":Git merge ", opts)
    end
}
