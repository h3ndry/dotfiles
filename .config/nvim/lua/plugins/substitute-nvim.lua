-- Lua
return {
  "gbprod/substitute.nvim",
  event  = "VeryLazy",
  config = function()
    require("substitute").setup()
    vim.keymap.set("n", "gs", require('substitute').operator, { noremap = true })
    vim.keymap.set("n", "gss", require('substitute').line, { noremap = true })
    vim.keymap.set("n", "gsR", require('substitute').eol, { noremap = true })
    vim.keymap.set("x", "gs", require('substitute').visual, { noremap = true })
  end
}
