return {
    "sindrets/diffview.nvim",
    config = function()
        vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory <CR>")
    end
}
