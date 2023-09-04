return {
  "h3ndry/rest.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  config = function()
    require("rest-nvim").setup()

  end
}

