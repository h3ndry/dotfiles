-- Lua
return {
  "gbprod/substitute.nvim",
  event  = "VeryLazy",
  config = function()
    require("substitute").setup()
    vim.keymap.set("n", "gr", require('substitute').operator, { noremap = true })
    vim.keymap.set("n", "grr", require('substitute').line, { noremap = true })
    vim.keymap.set("n", "grR", require('substitute').eol, { noremap = true })
    vim.keymap.set("x", "gr", require('substitute').visual, { noremap = true })
  end
}
