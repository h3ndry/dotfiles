return {
    'ofirgall/open.nvim',
    event = "VeryLazy",
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
        require('open').setup {
        }

        vim.keymap.set('n', '<leader>O', require('open').open_cword)
    end
}
