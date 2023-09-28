return {
  "tpope/vim-fugitive",
  dependencies = {
    "shumphrey/fugitive-gitlab.vim",
    "tpope/vim-rhubarb"
  },



-- alias grba='git rebase --abort'
-- alias grbc='git rebase --continue'

  event = "VeryLazy",
  config = function()
    vim.keymap.set("n", "<leader>gc", ":Git commit -v <CR>")
    vim.keymap.set("n", "<leader>gC", ":Git commit --amend --no-edit <CR>")
    vim.keymap.set("n", "<leader>gS", ":Git stash")
    -- vim.keymap.set("n", "<leader>gSa", ":Git stash apply")
    vim.keymap.set("n", "<leader>G", ":Git ")
    vim.keymap.set("n", "<leader>ga", ":Git add --update <CR> ")
    vim.keymap.set("n", "<leader>gp", ":Git pull --rebase  <CR>")
    vim.keymap.set("n", "<leader>gP", ":Git push -u <CR>")
    vim.keymap.set("n", "<leader>gd", ":Gvdiffsplit! <CR>")
    vim.keymap.set("n", "<leader>gw", ":Gwrite! <CR>")
    vim.keymap.set("n", "<leader>grc", ":Git rebase --continue <CR>")
    vim.keymap.set("n", "<leader>gra", ":Git rebase --abort <CR>")
    vim.keymap.set("n", "<leader>gmt", ":Git mergetool <CR>")

    -- vim.keymap.set("n", "<leader>gdh", ":Ghdiffsplit <CR>")
  end
}
