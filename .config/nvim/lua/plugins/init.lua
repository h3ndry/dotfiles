return {
    'kovetskiy/sxhkd-vim',
    "h3ndry/ReplaceWithRegister",
    "cohama/lexima.vim",
    'andymass/vim-matchup',
    "tpope/vim-repeat",
    "tpope/vim-capslock",
    "tpope/vim-eunuch",
    "tpope/vim-sensible",
    "tpope/vim-endwise",
    "nvim-lua/plenary.nvim",
    "amadeus/vim-convert-color-to",
    "neovim/nvim-lspconfig",
    "norcalli/nvim-colorizer.lua",
    "norcalli/nvim-terminal.lua",
    "romainl/vim-dichromatic",
    'nvim-tree/nvim-web-devicons',
    "Hoffs/omnisharp-extended-lsp.nvim",
    "nvim-lua/lsp_extensions.nvim",
    "mbbill/undotree",
    "OrangeT/vim-csharp",
    "nvim-treesitter/nvim-treesitter-context",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },


    "jlcrochet/vim-razor",
    "windwp/nvim-ts-autotag",
    "rafamadriz/friendly-snippets",
    "nathom/filetype.nvim",
    "Hoffs/omnisharp-extended-lsp.nvim",


    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },


    { "ellisonleao/gruvbox.nvim", lazy = false },
}
