return {
  "pmizio/typescript-tools.nvim",
  event        = "VeryLazy",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts         = {
    complete_function_calls = true,
  },
  config       = function()
    require("typescript-tools").setup {}
  end
}
