return {
    'kovetskiy/sxhkd-vim',
    "h3ndry/ReplaceWithRegister",
    "cohama/lexima.vim",
    'andymass/vim-matchup',
    "neovim/nvim-lspconfig",
    "romainl/vim-dichromatic",
    'nvim-tree/nvim-web-devicons',
    "Hoffs/omnisharp-extended-lsp.nvim",
    "nvim-lua/lsp_extensions.nvim",
    "mbbill/undotree",
    "OrangeT/vim-csharp",
    "nvim-treesitter/nvim-treesitter-context",
    { 'kevinhwang91/nvim-ufo',                    dependencies = 'kevinhwang91/promise-async' },
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "jlcrochet/vim-razor",
    "windwp/nvim-ts-autotag",
    "rafamadriz/friendly-snippets",
    "nathom/filetype.nvim",
    "Hoffs/omnisharp-extended-lsp.nvim",

    {
        "numToStr/Comment.nvim",
        config = function()
            require("Comment").setup()
        end
    },
    {
        'edluffy/hologram.nvim',
        config = function()
            require('hologram').setup {
                auto_display = true -- WIP automatic markdown image display, may be prone to breaking
            }
        end
    },

    {
        'projekt0n/github-nvim-theme',
        tag = 'v0.0.7',
        config = function()
            require('github-theme').setup({
                theme_style = "dark_default",
                dark_float = true
            })
        end
    },
    {
        'brenoprata10/nvim-highlight-colors',
        config = function()
            require('nvim-highlight-colors').setup {}
        end
    },

    {
        'anuvyklack/fold-preview.nvim',
        dependencies = 'anuvyklack/keymap-amend.nvim',
        config = function()
            require('fold-preview').setup({
                -- Your configuration goes here.
            })
        end
    },


    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
                highlight = {
                    enable = true,        -- false will disable the whole extension
                    additional_vim_regex_highlighting = false
                }
            }
        end
    },


    { 'lewis6991/github_dark.nvim' },
    "norcalli/nvim-colorizer.lua",
    "norcalli/nvim-terminal.lua",
    "amadeus/vim-convert-color-to",
    {
        "prettier/vim-prettier",
        ft = {
            "javascript",
            "typescript",
            "typescriptreact",
            "css",
            "less",
            "scss",
            "json",
            "graphql",
            "markdown",
            "vue",
            "svelte",
            "yaml",
            "html"
        },
        build = "yarn install"
    },

    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },


    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = {
            "tpope/vim-repeat",
            "tpope/vim-capslock",
            "tpope/vim-eunuch",
            "tpope/vim-fugitive",
            "tpope/vim-sensible",
            "tpope/vim-endwise",
            "monaqa/dial.nvim",
            -- "tpope/vim-speeddating",
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim"
        }
    },


    { "ellisonleao/gruvbox.nvim",  lazy = false },
}
