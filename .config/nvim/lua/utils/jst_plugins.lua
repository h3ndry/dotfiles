-- It all start here
require("packer").startup(
  function(use)
    use "wbthomason/packer.nvim"
    use "numToStr/Comment.nvim"
    use "h3ndry/ReplaceWithRegister"
    use "tpope/vim-repeat"
    use "cohama/lexima.vim"
    use "chentau/marks.nvim"
    use "tpope/vim-surround"
    use "h3ndry/tokyonight.nvim"
    use "neovim/nvim-lspconfig"
    use "ggandor/lightspeed.nvim"
    use "andymass/vim-matchup"
    use "tpope/vim-capslock"
    use "nathom/filetype.nvim"
    use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
    use "nvim-lua/plenary.nvim"
    use "nvim-telescope/telescope.nvim"
    use "L3MON4D3/LuaSnip"
    use "rafamadriz/friendly-snippets"
    use "saadparwaiz1/cmp_luasnip"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-nvim-lsp"
    use "onsails/lspkind-nvim"
    use "golang/vscode-go"
    use "nvim-lua/lsp_extensions.nvim"
    use "OrangeT/vim-csharp"
    use {"nvim-treesitter/nvim-treesitter", branch = "0.5-compat"}
    use {"nvim-treesitter/nvim-treesitter-textobjects", branch = "0.5-compat", run = ":TSUpdate"}
    use "mhartington/formatter.nvim"
    use "norcalli/nvim-colorizer.lua"
    use "lewis6991/gitsigns.nvim"
    use "norcalli/nvim-terminal.lua"
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
    -- use "RRethy/vim-illuminate"
  end
)

require "terminal".setup()
