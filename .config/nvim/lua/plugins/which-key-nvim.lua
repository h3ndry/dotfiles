return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
    end,
    opts = {
        triggers_blacklist = {
            -- list of mode / prefixes that should never be hooked by WhichKey
            -- this is mostly relevant for keymaps that start with a native binding
            i = { "j", "k" },
            v = { "j", "k" },
            c = { "w" },
            n = { "v", "v" },
        }
    }
}
