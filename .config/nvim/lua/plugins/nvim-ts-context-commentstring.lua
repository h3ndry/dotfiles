return {
    'JoosepAlviste/nvim-ts-context-commentstring',
    dependencies = {
        'nvim-treesitter/nvim-treesitter',
    },
    config = function()
        require('nvim-treesitter.configs').setup {
            -- Install the parsers for the languages you want to comment in
            -- Here are the supported languages:
            ensure_installed = { 'tsx' },

            context_commentstring = {
                enable = true,
            },
        }
    end

}
