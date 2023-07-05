-- Lua
return {
    "gbprod/substitute.nvim",
    config = function()
        require("substitute").setup({
            yank_substituted_text = true,
            on_substitute = require("yanky.integration").substitute(),
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        })

        -- Lua
        vim.keymap.set("n", "gr", require('substitute').operator, { noremap = true })
        vim.keymap.set("n", "grr", require('substitute').line, { noremap = true })
        vim.keymap.set("n", "grR", require('substitute').eol, { noremap = true })
        vim.keymap.set("x", "gr", require('substitute').visual, { noremap = true })
    end
}
