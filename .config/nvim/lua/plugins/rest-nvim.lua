return {
    -- "h3ndry/rest.nvim",
    "rest-nvim/rest.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        require("rest-nvim").setup({
            encode_url = false,

        })
        vim.keymap.set('n', '<space>R', ":lua require('rest-nvim').run() <CR>")
    end
}
