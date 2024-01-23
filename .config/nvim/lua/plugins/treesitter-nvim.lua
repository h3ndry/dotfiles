return {
    'nvim-treesitter/nvim-treesitter',
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    commit       = "f197a15b",
    build = ':TSUpdate',
    config = function()
        require("nvim-treesitter.configs").setup {
            ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
            highlight = {
                enable = true,        -- false will disable the whole extension
                additional_vim_regex_highlighting = false
            },
            indent = {
                enable = true
            },

            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>", -- set to `false` to disable one of the mappings
                    node_incremental = "C-space>",
                    scope_incremental = "false",
                    node_decremental = "<bs>",
                },
            },
            textobjects = {
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                    },
                    -- You can choose the select mode (default is charwise 'v')
                    selection_modes = {
                        ['@parameter.outer'] = 'v', -- charwise
                        ['@function.outer'] = 'V',  -- linewise
                        ['@class.outer'] = '<c-v>', -- blockwise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding xor succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    include_surrounding_whitespace = true,
                },
            },

        }
    end
}
