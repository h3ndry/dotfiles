return {
    -- "mbbill/undotree",
    "tpope/vim-repeat",
    "tpope/vim-endwise",
    "tpope/vim-eunuch",
    "tpope/vim-capslock",
    "tpope/vim-dotenv",
    "andymass/vim-matchup",
    "cohama/lexima.vim",
    "kovetskiy/sxhkd-vim",
    "b0o/schemastore.nvim",
    "nathom/filetype.nvim",
    "nvim-lua/plenary.nvim",
    "neovim/nvim-lspconfig",
    "nvim-tree/nvim-web-devicons",
    "norcalli/nvim-colorizer.lua",
    "amadeus/vim-convert-color-to",
    "nvim-lua/lsp_extensions.nvim",
    -- "Bekaboo/dropbar.nvim", "tpope/vim-dotenv",
    "Hoffs/omnisharp-extended-lsp.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    {
        "tiagovla/tokyodark.nvim",
        opts = {
            transparent_background = true
            -- custom options here
        },
        config = function(_, opts)
            require("tokyodark").setup(opts) -- calling setup is optional
            vim.cmd [[colorscheme tokyodark]]
        end,
    },
    { "rebelot/kanagawa.nvim",                    lazy = false },
    "MunifTanjim/nui.nvim",
    "stevearc/dressing.nvim",
}
