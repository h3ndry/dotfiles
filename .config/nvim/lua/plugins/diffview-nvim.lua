return {
  "sindrets/diffview.nvim",
  event  = "VeryLazy",
  config = function()
    vim.keymap.set("n", "<leader>gh", ":DiffviewFileHistory <CR>")
  end
}
