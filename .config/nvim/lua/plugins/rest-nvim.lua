return {
  "h3ndry/rest.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("rest-nvim").setup()
    vim.keymap.set('n', '<space>R', ":lua require('rest-nvim').run()<CR>")
  end
}

