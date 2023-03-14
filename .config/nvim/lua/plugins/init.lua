return {
        'kovetskiy/sxhkd-vim',
        "h3ndry/ReplaceWithRegister",
        "tpope/vim-repeat",
        "cohama/lexima.vim",
        'eandrju/cellular-automaton.nvim',
        'andymass/vim-matchup',
        "h3ndry/tokyonight.nvim",
        "neovim/nvim-lspconfig",
        "romainl/vim-dichromatic",
        'nvim-tree/nvim-web-devicons',
        "hrsh7th/cmp-nvim-lsp",
        "Hoffs/omnisharp-extended-lsp.nvim",
        "tpope/vim-capslock",
        "nvim-lua/plenary.nvim",
        "saadparwaiz1/cmp_luasnip",
        "nvim-lua/lsp_extensions.nvim",
        "mbbill/undotree",
        "tpope/vim-eunuch",
        "OrangeT/vim-csharp",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-calc",
        "f3fora/cmp-spell",
        { 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' },
        { 'kevinhwang91/nvim-ufo', dependencies = 'kevinhwang91/promise-async' },
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "lukas-reineke/cmp-rg",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "jlcrochet/vim-razor",
        "nkakouros-original/numbers.nvim",
        "windwp/nvim-ts-autotag",
        "f-person/git-blame.nvim",
        "rafamadriz/friendly-snippets",
        "tpope/vim-fugitive",
        "kyazdani42/nvim-tree.lua",
        "Hoffs/omnisharp-extended-lsp.nvim",
        "github/copilot.vim",

        {
            "numToStr/Comment.nvim",
            config = function()
                require("Comment").setup()
            end
        },


        {
            "rainbowhxch/beacon.nvim",
            config = function()
                require("beacon").setup()
            end
        },

        {
            "chentoast/marks.nvim",
            config = function()
                require "marks".setup {}
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
            lazy = false,
            tag = 'v0.0.7',
            config = function()
                require('github-theme').setup({
                    theme_style = "dark_default",
                    -- dark_float = true
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
            "folke/trouble.nvim",
            config = function()
                require("trouble").setup {
                    signs = {
                        -- icons / text used for a diagnostic
                        error = "",
                        warning = "",
                        hint = "",
                        information = "",
                        other = " "
                    },
                }
            end
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
            "gbprod/yanky.nvim",
            config = function()
                require("yanky").setup({
                    -- your configuration comes here
                    -- or leave it empty to use the default settings
                    -- refer to the configuration section below
                })
            end
        },

        {
            'nvim-lualine/lualine.nvim',
            config = function()
                vim.o.laststatus = 3
                require('lualine').setup({
                    options = {
                        section_separators = { left = '', right = '' },
                        component_separators = { left = '', right = '' }
                    },
                    sections = {
                        lualine_c = { { 'filename', path = 1 } }
                    }
                })
            end
        }

    }

