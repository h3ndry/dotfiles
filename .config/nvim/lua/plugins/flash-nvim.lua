return {
  "folke/flash.nvim",
  event = "VeryLazy",
  ---@type Flash.Config
  opts = {
    multi_window = false,
    highlight = {
      backdrop = false,
      matches = false,
    },
    modes = {
      char = {
        enabled  = false,
        highlight = { backdrop = false, matches = false }
      }
    }
  },
  keys = {
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash Treesitter Search",
    },
  },
}
