require "utils.jst_plugins"
require("Comment").setup()
require "lspconfig".sumneko_lua.setup {}
-- require "luasnip".config.setup {}
require "marks".setup {}
-- require "vim-csharp".setup {}
require("telescope").load_extension("fzf")
require "utils.setting"
require "utils.keymap"
require "snippets"

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true



local nvim_lsp = require("lspconfig")

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
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
    "angularls",
    -- "omnisharp"
}

-- luasnip.stup{}
-- nvim-cmp setup
cmp.setup {
    snippet = {
        expand = function(args)
            require "luasnip".lsp_expand(args.body)
        end
    },
    mapping = {
        -- ["<C-p>"] = cmp.mapping.select_prev_item(),
        -- ["<C-n>"] = cmp.mapping.select_next_item(),
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
        -- {name = "rg"},
        { name = "buffer" }
    },
    experimental = {
        ghost_text = true
    },
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
                -- rg = "[RG]",
                buffer = "[BUFF]"
            }
        }
    }
}

require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["<C-h>"] = "which_key"
            }
        }
    },
    pickers = {},
    extensions = {
        fzf = {
            override_generic_sorter = false,
            override_file_sorter = true
        },
        bookmarks = {
            -- Available: 'brave', 'buku', 'chrome', 'edge', 'safari', 'firefox'
            selected_browser = "brave"
        }
    }
}

require("telescope").load_extension("fzf")
require("telescope").load_extension("bookmarks")

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
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = "LuaJIT",
                        -- Setup your lua path
                        path = runtime_path
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { "vim" }
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true)
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {
                        enable = false
                    }
                }
            }
        }
    else
        nvim_lsp[lsp].setup {
            capabilities = capabilities
            -- on_attach = function(client)
            -- [[ other on_attach code ]]
            -- require 'illuminate'.on_attach(client)
            -- end,
        }
    end
end

local pid = vim.fn.getpid()
local omnisharp_bin = "/usr/bin/omnisharp"

require 'lspconfig'.omnisharp.setup({
    handlers = {
        ["textDocument/definition"] = require('omnisharp_extended').handler,
    },
    cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) },
    capabilities = capabilities,
    -- filetypes = { "cs", "vb", "cshtml" }
    -- rest of your settings
})


require("lspkind").init(
    {
    -- default symbol map
    preset = "codicons",
    -- default: {}
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


-- require("nvim-treesitter.configs").setup {
--     textobjects = {
--         select = {
--             enable = true,
--             -- Automatically jump forward to textobj, similar to targets.vim
--             lookahead = true,
--             keymaps = {
--                 -- You can use the capture groups defined in textobjects.scm
--                 ["af"] = "@function.outer",
--                 ["if"] = "@function.inner",
--                 ["ac"] = "@class.outer",
--                 ["ic"] = "@class.inner",
--                 -- Or you can define your own textobjects like this
--                 -- ["iF"] = {
--                 --     python = "(function_definition) @function",
--                 --     cpp = "(function_definition) @function",
--                 --     c = "(function_definition) @function",
--                 --     java = "(method_declaration) @function"
--                 -- }
--             }
--         },
--         swap = {
--             enable = true,
--             swap_next = {
--                 ["<leader>a"] = "@parameter.inner"
--             },
--             swap_previous = {
--                 ["<leader>A"] = "@parameter.inner"
--             }
--         },
--         move = {
--             enable = true,
--             set_jumps = true, -- whether to set jumps in the jumplist
--             goto_next_start = {
-- --                 ["]m"] = "@function.outer",
--                 ["]]"] = "@class.outer"
--             },
--             goto_next_end = {
--                 ["]M"] = "@function.outer",
--                 ["]["] = "@class.outer"
--             },
--             goto_previous_start = {
--                 ["[m"] = "@function.outer",
--                 ["[["] = "@class.outer"
--             },
--             goto_previous_end = {
--                 ["[M"] = "@function.outer",
--                 ["[]"] = "@class.outer"
--             }
--         }
--     }
-- }

-- Formater setting
require("formatter").setup(
    {
    logging = false,
    filetype = {
        javascript = {
            -- prettier
            function()
                return {
                    exe = "prettier",
                    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
                    stdin = true
                }
            end
        },
        typescript = {
            -- prettier
            function()
                return {
                    exe = "prettier",
                    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
                    stdin = true
                }
            end
        },
        html = {
            -- prettier
            function()
                return {
                    exe = "prettier",
                    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
                    stdin = true
                }
            end
        },
        rust = {
            -- Rustfmt
            function()
                return {
                    exe = "rustfmt",
                    args = { "--emit=stdout" },
                    stdin = true
                }
            end
        },
        jsx = {
            function()
                return {
                    exe = "prettier",
                    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
                    stdin = true
                }
            end
        },
        css = {
            function()
                return {
                    exe = "prettier",
                    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
                    stdin = true
                }
            end
        },
        svelte = {
            function()
                return {
                    exe = "prettier",
                    args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote" },
                    stdin = true
                }
            end
        },
        lua = {
            -- luafmt
            function()
                return {
                    exe = "luafmt",
                    args = { "--indent-count", 2, "--stdin" },
                    stdin = true
                }
            end
        },
        c = {
            -- clang-format
            function()
                return {
                    exe = "clang-format",
                    args = { "--style", "GNU" },
                    stdin = true,
                    cwd = vim.fn.expand("%:p:h") -- Run clang-format in cwd of the file.
                }
            end
        },
        cpp = {
            -- clang-format
            function()
                return {
                    exe = "clang-format",
                    args = {},
                    stdin = true,
                    cwd = vim.fn.expand("%:p:h") -- Run clang-format in cwd of the file.
                }
            end
        }
    }
}
)

-- Use the `default_options` as the second parameter, which uses
require "colorizer".setup {
    "*", -- Highlight all files, but customize some others.
    css = { rgb_fn = true }, -- Enable parsing rgb(...) functions in css.
    html = { names = false } -- Disable parsing "names" like Blue or Gray
}

require("Comment").setup()

require("nvim-treesitter.configs").setup {
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true, -- false will disable the whole extension
        additional_vim_regex_highlighting = false
    }
}

require('gitsigns').setup {
    signs                        = {
        add          = { hl = 'GitSignsAdd', text = '│', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
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

-- require 'nvim-tree'.setup {
--     view = {
--         width = 50,
--         mappings = {
--             custom_only = false,
--             list = {
--                 { key = { "<CR>", "o" }, action = "edit_in_place", mode = "n" },
--             },
--         },
--     },
--     git = {
--         enable = false,
--     },
--     actions = {
--         open_file = {
--             quit_on_open = false
--         }
--     }
-- }
-- --       𥉉  ﮏ   ﰸ  
--
local signs = { Error = "", Warn = "", Hint = "", Info = "" }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require("trouble").setup {
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
}

