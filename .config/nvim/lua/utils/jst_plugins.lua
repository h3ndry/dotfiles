-- It all start here
require("packer").startup(
    function(use)
        use "wbthomason/packer.nvim"
        use "numToStr/Comment.nvim"
        use "h3ndry/ReplaceWithRegister"
        use "tpope/vim-repeat"
        use "cohama/lexima.vim"
        -- use "chentau/marks.nvim"
        use "chentoast/marks.nvim"
        use "danilamihailov/beacon.nvim"
        use "h3ndry/tokyonight.nvim"
        use "neovim/nvim-lspconfig"
        use "andymass/vim-matchup"
        use "ggandor/lightspeed.nvim"
        use "tpope/vim-capslock"
        -- use "nathom/filetype.nvim"
        use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
        use "nvim-lua/plenary.nvim"
        use "nvim-telescope/telescope.nvim"
        use "rafamadriz/friendly-snippets"
        use "tpope/vim-fugitive"

        use "L3MON4D3/LuaSnip"
        use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }
        use {
            'declancm/cinnamon.nvim',
            config = function() require('cinnamon').setup() end
        }
        -- use 'sunjon/shade.nvim'

        use "saadparwaiz1/cmp_luasnip"
        use "hrsh7th/nvim-cmp"
        use "hrsh7th/cmp-nvim-lsp"
        use "onsails/lspkind-nvim"
        use "golang/vscode-go"
        use "nvim-lua/lsp_extensions.nvim"
        use "OrangeT/vim-csharp"
        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate'
        }
        use "nvim-treesitter/nvim-treesitter-textobjects"
        use { 'lewis6991/github_dark.nvim' }
        use "mhartington/formatter.nvim"
        use "norcalli/nvim-colorizer.lua"
        use "lewis6991/gitsigns.nvim"
        use "norcalli/nvim-terminal.lua"
        use "amadeus/vim-convert-color-to"
        use "dhruvmanila/telescope-bookmarks.nvim"
        use {
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
            run = "yarn install"
        }
        use "ray-x/cmp-treesitter"
        use "hrsh7th/cmp-cmdline"
        use "hrsh7th/cmp-calc"
        use "f3fora/cmp-spell"
        use "lukas-reineke/cmp-rg"
        use "hrsh7th/cmp-buffer"
        use "hrsh7th/cmp-path"
        use "jlcrochet/vim-razor"
        use "nkakouros-original/numbers.nvim"
        use "windwp/nvim-ts-autotag"
        -- use "kyazdani42/nvim-web-devicons"
        -- use "OrangeT/vim-csharp"
        use "folke/trouble.nvim"
        use "kyazdani42/nvim-tree.lua"
        use "Hoffs/omnisharp-extended-lsp.nvim"
        use "kovetskiy/sxhkd-vim"

        use "github/copilot.vim"
        use({
            "kylechui/nvim-surround",
            config = function()
                require("nvim-surround").setup({
                    -- Configuration here, or leave empty to use defaults
                })
            end
        })
        use({
            "gbprod/yanky.nvim",
            config = function()
                require("yanky").setup({
                    -- your configuration comes here
                    -- or leave it empty to use the default settings
                    -- refer to the configuration section below
                })
            end
        })
    end
)

require "terminal".setup()
