return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
  end,
  opts = {
    triggers_blacklist = {
      -- list of mode / prefixes that should never be hooked by WhichKey
      -- this is mostly relevant for keymaps that start with a native binding
      i = { "v", "v" },
      -- v = { "j", "k" },
      -- c = { "w", "k" },
      -- n = { "v", "v" },
    },
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
}
