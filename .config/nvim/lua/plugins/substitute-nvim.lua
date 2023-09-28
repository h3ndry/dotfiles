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

    --- experimentin which one is faster
    vim.keymap.set("n", "<c-s>", require('substitute').operator, { noremap = true })
    vim.keymap.set("n", "<c-s>l", require('substitute').line, { noremap = true })
    vim.keymap.set("n", "<c-s>L", require('substitute').eol, { noremap = true })
    vim.keymap.set("x", "<c-s>", require('substitute').visual, { noremap = true })

    -- another experimet
    vim.keymap.set("n", "<c-s>s", require('substitute').line, { noremap = true })
    vim.keymap.set("n", "<c-s>S", require('substitute').eol, { noremap = true })


  end
}
