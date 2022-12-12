local fn = vim.fn
-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
    print "Installing packer close and reopen Neovim..."
    vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
    return
end

-- Have packer use a popup window
packer.init {
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
}


require("packer").startup(

    function(use)
        use "wbthomason/packer.nvim"

        use { "numToStr/Comment.nvim",
            config = function()
                require("Comment").setup()
            end
        }


        use { "rainbowhxch/beacon.nvim",
            config = function()

                require("beacon").setup()

            end
        }

        use "h3ndry/ReplaceWithRegister"
        use "tpope/vim-repeat"
        use "cohama/lexima.vim"

        use { "karb94/neoscroll.nvim",
            config = function() require('neoscroll').setup() end
        }

        use { "chentoast/marks.nvim",
            config = function()
                require "marks".setup {}
            end
        }

        use "h3ndry/tokyonight.nvim"
        use "neovim/nvim-lspconfig"
        use "andymass/vim-matchup"
        use "ggandor/lightspeed.nvim"
        use "tpope/vim-capslock"
        -- use "nathom/filetype.nvim"
        use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
        use "nvim-lua/plenary.nvim"

        use { "nvim-telescope/telescope.nvim",
            config = function()
                require("telescope").setup {
                    defaults = {
                        mappings = {
                            i = { ["<C-h>"] = "which_key" }
                        }
                    },
                    pickers = {},
                    extensions = {
                        fzf = {
                            override_generic_sorter = false,
                            override_file_sorter = true
                        },
                    }
                }

                require("telescope").load_extension("fzf")
            end
        }

        use "rafamadriz/friendly-snippets"
        use "tpope/vim-fugitive"

        use { "L3MON4D3/LuaSnip",
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load({
                    paths = { "./snippets/" },
                })
            end
        }

        use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }

        -- use {
        --     'declancm/cinnamon.nvim',
        --     config = function() require('cinnamon').setup() end
        -- }

        use "saadparwaiz1/cmp_luasnip"

        use { "hrsh7th/nvim-cmp",
            config = function()
                local capabilities = vim.lsp.protocol.make_client_capabilities()
                capabilities.textDocument.completion.completionItem.snippetSupport = true
                local nvim_lsp = require("lspconfig")
                local has_words_before = function()
                    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                    return col ~= 0 and
                        vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
                end

                local cmp = require "cmp"
                local lspkind = require("lspkind")
                local luasnip = require("luasnip")

                local runtime_path = vim.split(package.path, ";")
                table.insert(runtime_path, "lua/?.lua")
                table.insert(runtime_path, "lua/?/init.lua")

                local servers = {
                    "clangd",
                    "rust_analyzer",
                    "pyright",
                    "tsserver",
                    "html",
                    "cssls",
                    "emmet_ls",
                    "sumneko_lua",
                    "texlab",
                    "svelte",
                    "bashls",
                    "volar",
                    "ltex",
                    "omnisharp"
                }

                cmp.setup {
                    snippet = {
                        expand = function(args)
                            require "luasnip".lsp_expand(args.body)
                        end
                    },
                    mapping = {
                        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                        ["<C-f>"] = cmp.mapping.scroll_docs(4),
                        ["<C-Space>"] = cmp.mapping.complete({}),
                        ["<C-e>"] = cmp.mapping.close(),
                        ["<c-y>"] = cmp.mapping.confirm {
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = true
                        },
                        ["<C-n>"] = cmp.mapping(
                            function(fallback)
                                if cmp.visible() then
                                    cmp.select_next_item()
                                elseif luasnip.expand_or_jumpable() then
                                    luasnip.expand_or_jump()
                                elseif has_words_before() then
                                    cmp.complete()
                                else
                                    fallback()
                                end
                            end,
                            { "i", "s" }
                        ),
                        ["<C-p>"] = cmp.mapping(
                            function(fallback)
                                if cmp.visible() then
                                    cmp.select_prev_item()
                                elseif luasnip.jumpable(-1) then
                                    luasnip.jump(-1)
                                else
                                    fallback()
                                end
                            end,
                            { "i", "s" }
                        )
                    },
                    sources = {
                        -- {name = "gh_issues"},
                        { name = "luasnip" },
                        { name = "nvim_lsp" },
                        { name = "nvim_lua" },
                        { name = "cmp-cmdline" },
                        { name = "cmp-treesitter" },
                        { name = "calc" },
                        { name = "cmp-spell" },
                        { name = "path" },
                        { name = "rg" },
                        { name = "buffer" }
                    },
                    experimental = { ghost_text = true },
                    formatting = {
                        format = lspkind.cmp_format {
                            with_text = true,
                            menu = {
                                luasnip = "[SNIP]",
                                nvim_lsp = "[LSP]",
                                nvim_lua = "[API]",
                                calc = "[CALC]",
                                cmdline = "[CMD]",
                                spell = "[SPELL]",
                                path = "[PATH]",
                                rg = "[RG]",
                                buffer = "[BUFF]"
                            }
                        }
                    }
                }
                -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
                cmp.setup.cmdline('/', {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        { name = 'buffer' }
                    }
                })

                -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
                cmp.setup.cmdline('?', {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = {
                        { name = 'buffer' }
                    }
                })

                -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
                cmp.setup.cmdline(':', {
                    mapping = cmp.mapping.preset.cmdline(),
                    sources = cmp.config.sources({
                        { name = 'path' }
                    }, {
                        { name = 'cmdline' }
                    })
                })

                for _, lsp in ipairs(servers) do
                    if lsp == "sumneko_lua" then
                        require "lspconfig".sumneko_lua.setup {
                            settings = {
                                Lua = {
                                    runtime = { version = "LuaJIT", path = runtime_path },
                                    diagnostics = { globals = { "vim" } },
                                    workspace = { library = vim.api.nvim_get_runtime_file("", true) },
                                    telemetry = { enable = false }
                                }
                            }
                        }
                    elseif lsp == "omnisharp" then
                        local pid = vim.fn.getpid()
                        local omnisharp_bin = "/usr/bin/omnisharp"

                        require 'lspconfig'.omnisharp.setup({
                            handlers = {
                                ["textDocument/definition"] = require('omnisharp_extended').handler,
                            },
                            cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) },
                            capabilities = capabilities,
                        })
                    else
                        nvim_lsp[lsp].setup { capabilities = capabilities }
                    end
                end
            end
        }

        use "hrsh7th/cmp-nvim-lsp"

        use { "onsails/lspkind-nvim",
            config = function()
                require("lspkind").init(
                    {
                        preset = "codicons",
                        symbol_map = {
                            Text = "  ",
                            Method = "  ",
                            Function = "  ",
                            Constructor = "  ",
                            Field = "  ",
                            Variable = "  ",
                            Class = "  ",
                            Interface = "  ",
                            Module = "  ",
                            Property = "  ",
                            Unit = "  ",
                            Value = "  ",
                            Enum = "  ",
                            Keyword = "  ",
                            Snippet = "  ",
                            Color = "  ",
                            File = "  ",
                            Reference = "  ",
                            Folder = "  ",
                            EnumMember = "  ",
                            Constant = "  ",
                            Struct = "  ",
                            Event = "  ",
                            Operator = "  ",
                            TypeParameter = "  "
                        }
                    }
                )

            end
        }

        use "golang/vscode-go"
        use "nvim-lua/lsp_extensions.nvim"
        use "OrangeT/vim-csharp"
        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            config = function()
                require 'nvim-treesitter.configs'.setup({})
            end
        }

        use "nvim-treesitter/nvim-treesitter-textobjects"
        use { 'lewis6991/github_dark.nvim' }
        use "mhartington/formatter.nvim"
        use "norcalli/nvim-colorizer.lua"
        use { "lewis6991/gitsigns.nvim",
            config = function()

                require('gitsigns').setup {
                    signs                        = {
                        add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr',
                            linehl = 'GitSignsAddLn' },
                        change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr',
                            linehl = 'GitSignsChangeLn' },
                        delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr',
                            linehl = 'GitSignsDeleteLn' },
                        topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr',
                            linehl = 'GitSignsDeleteLn' },
                        changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr',
                            linehl = 'GitSignsChangeLn' },
                    },
                    signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
                    numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
                    linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
                    word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
                    watch_gitdir                 = {
                        interval = 1000,
                        follow_files = true
                    },
                    attach_to_untracked          = true,
                    current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                    current_line_blame_opts      = {
                        virt_text = true,
                        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                        delay = 1000,
                        ignore_whitespace = false,
                    },
                    current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                    sign_priority                = 6,
                    update_debounce              = 100,
                    status_formatter             = nil, -- Use default
                    max_file_length              = 40000,
                    preview_config               = {
                        -- Options passed to nvim_open_win
                        border = 'single',
                        style = 'minimal',
                        relative = 'cursor',
                        row = 0,
                        col = 1
                    },
                    yadm                         = {
                        enable = false
                    },

                    on_attach = function(bufnr)
                        local gs = package.loaded.gitsigns

                        local function map(mode, l, r, opts)
                            opts = opts or {}
                            opts.buffer = bufnr
                            vim.keymap.set(mode, l, r, opts)
                        end

                        -- Navigation
                        map('n', ']c', function()
                            if vim.wo.diff then return ']c' end
                            vim.schedule(function() gs.next_hunk() end)
                            return '<Ignore>'
                        end, { expr = true })

                        map('n', '[c', function()
                            if vim.wo.diff then return '[c' end
                            vim.schedule(function() gs.prev_hunk() end)
                            return '<Ignore>'
                        end, { expr = true })

                        -- Actions
                        map({ 'n', 'v' }, '<leader>ys', ':Gitsigns stage_hunk<CR>')
                        map({ 'n', 'v' }, '<leader>yr', ':Gitsigns reset_hunk<CR>')
                        map('n', '<leader>yS', gs.stage_buffer)
                        map('n', '<leader>yu', gs.undo_stage_hunk)
                        map('n', '<leader>yR', gs.reset_buffer)
                        map('n', '<leader>yp', gs.preview_hunk)
                        map('n', '<leader>yb', function() gs.blame_line { full = true } end)
                        map('n', '<leader>tb', gs.toggle_current_line_blame)
                        map('n', '<leader>yd', gs.diffthis)
                        map('n', '<leader>yD', function() gs.diffthis('~') end)
                        map('n', '<leader>td', gs.toggle_deleted)

                        -- Text object
                        map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
                    end
                }
            end
        }
        use "norcalli/nvim-terminal.lua"
        use "amadeus/vim-convert-color-to"
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

        use { "ray-x/cmp-treesitter",
        }

        use "hrsh7th/cmp-cmdline"
        use "hrsh7th/cmp-calc"
        use "f3fora/cmp-spell"
        use "lukas-reineke/cmp-rg"
        use "hrsh7th/cmp-buffer"
        use "hrsh7th/cmp-path"
        use "jlcrochet/vim-razor"
        use "nkakouros-original/numbers.nvim"
        use "windwp/nvim-ts-autotag"
        use { "folke/trouble.nvim",
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

        }

        use "kyazdani42/nvim-tree.lua"
        use "Hoffs/omnisharp-extended-lsp.nvim"
        use "github/copilot.vim"

        use {
            "kylechui/nvim-surround",
            config = function()
                require("nvim-surround").setup({
                    -- Configuration here, or leave empty to use defaults
                })
            end
        }

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

        use {
            'nvim-lualine/lualine.nvim',
            requires = { 'kyazdani42/nvim-web-devicons', opt = true },
            config = function()
                require('lualine').setup({
                    options = {
                        section_separators = { left = '', right = '' },
                        component_separators = { left = '', right = '' }
                    }
                })
            end
        }

        use {
            "f-person/git-blame.nvim",
            config = function()
                vim.g.gitblame_display_virtual_text = 0
                local git_blame = require('gitblame')

                require('lualine').setup({
                    sections = {
                        lualine_c = {
                            { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available }
                        }
                    }
                })
            end
        }
    end

)

require "terminal".setup()
