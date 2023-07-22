return {
    "sindrets/diffview.nvim",
    config = function()
        local opts = { noremap = true, silent = true }
        vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory <CR>", opts)
    end
}
