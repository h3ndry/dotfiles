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
    use "saadparwaiz1/cmp_luasnip"
    use "rafamadriz/friendly-snippets"
    use "saadparwaiz1/cmp_luasnip"
    use "hrsh7th/nvim-cmp"
    use "hrsh7th/cmp-buffer"
    use "hrsh7th/cmp-path"
    use "hrsh7th/cmp-nvim-lsp"
    use "onsails/lspkind-nvim"
    use "golang/vscode-go"
    use "nvim-lua/lsp_extensions.nvim"
    use "OrangeT/vim-csharp"
    use { "nvim-treesitter/nvim-treesitter", branch = "0.5-compat" }
    use { "nvim-treesitter/nvim-treesitter-textobjects", branch = "0.5-compat", run = ":TSUpdate" }
    use "mhartington/formatter.nvim"
    use "norcalli/nvim-colorizer.lua"
    use "lewis6991/gitsigns.nvim"
    use "nvim-lua/plenary.nvim"
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


  end
)

require("Comment").setup()


local nvim_lsp = require("lspconfig")
local servers = {"clangd", "rust_analyzer", "pyright", "tsserver", "html", "cssls", "emmet_ls"}
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities
  }
end


require "luasnip".config.setup {}
require "marks".setup {}

require("telescope").load_extension("fzf")

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
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true
    }
  }
}

-- require('telescope').load_extension('fzy_native')

-- require'shade'.setup({
--   overlay_opacity = 50,
--   opacity_step = 1,
--   keys = {
--     brightness_up    = '<C-Up>',
--     brightness_down  = '<C-Down>',
--     toggle           = '<Leader>s',
--   }
-- })
--

require("lspkind").init(
  {
    -- default symbol map
    preset = "codicons",
    -- default: {}
    symbol_map = {
      Text = "",
      Method = "",
      Function = "",
      Constructor = "",
      Field = "ﰠ",
      Variable = "",
      Class = "ﴯ",
      Interface = "",
      Module = "",
      Property = "ﰠ",
      Unit = "塞",
      Value = "",
      Enum = "",
      Keyword = "",
      Snippet = "",
      Color = "",
      File = "",
      Reference = "",
      Folder = "",
      EnumMember = "",
      Constant = "",
      Struct = "פּ",
      Event = "",
      Operator = "",
      TypeParameter = ""
    }
  }
)
-- Highlight on yank
vim.api.nvim_exec(
  [[
    augroup YankHighlight
        autocmd!
        autocmd TextYankPost * silent! lua vim.highlight.on_yank()
    augroup end
    autocmd VimResized * only
]],
  false
)

-- Save as sudo...
vim.api.nvim_exec([[
    cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
]], false)

vim.api.nvim_exec([[
    au FocusLost * :wa
    au FocusLost * silent! wa
    au BufLeave * silent! wall
]], false)

vim.api.nvim_exec(
  [[
    set spelllang=en
    set complete+=kspell
    augroup markdownSpell
        autocmd!
        autocmd FileType markdown setlocal spell
        autocmd BufRead,BufNewFile *.md setlocal spell
    augroup END
]],
  false
)

vim.api.nvim_exec(
  [[
  augroup Terminal
    autocmd!
    autocmd TermOpen * startinsert
    autocmd TermOpen * :set nonumber norelativenumber
    autocmd TermOpen * nnoremap <buffer> <C-c> i<C-c>
  augroup end
]],
  false
)

vim.api.nvim_exec(
  [[
    set tabstop=4
    set shiftwidth=4
    set expandtab
    set shiftwidth=0
    set report=0
    set splitright
    set path+=**
    set wildignore+=**/node_modules/**
    set noswapfile
    set shortmess+=c
    set laststatus=1
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

    function! Exec_on_term(cmd)
      if a:cmd=="normal"
        exec "normal mk\"vyip"
      else
        exec "normal gv\"vy"
      endif
      if !exists("g:last_terminal_chan_id")
        vs
        terminal
        let g:last_terminal_chan_id = b:terminal_job_id
        wincmd p
      endif

      if getreg('"v') =~ "^\n"
        call chansend(g:last_terminal_chan_id, expand("%:p")."\n")
      else
        call chansend(g:last_terminal_chan_id, @v)
      endif
      exec "normal `k"
    endfunction


]],
  false
)

vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
vim.cmd [[colorscheme tokyonight]]
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_functions = true
vim.o.completeopt = "menu,menuone,noinsert"
vim.g.netrw_banner = 0
vim.o.inccommand = "nosplit"
vim.g.did_load_filetypes = 1
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.hidden = true
vim.o.breakindent = true
vim.o.wrap = false
-- vim.cmd [[set undofile]]
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.scrolloff = 1
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Plugings Configuration
-- local luasnip = require("luasnip")
local cmp = require "cmp"
local lspkind = require("lspkind")

-- luasnip.stup{}
-- nvim-cmp setup
cmp.setup {
    snippet = {
      expand = function(args)
        require'luasnip'.lsp_expand(args.body)
      end
    },


  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<c-y>"] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }
  },
  sources = {
    -- {name = "gh_issues"},
    {name = "nvim_lsp"},
    {name = "luasnip"},
    {name = "nvim_lua"},
    {name = "cmp-cmdline"},
    {name = "cmp-treesitter"},
    {name = "cmp-calc"},
    {name = "cmp-spell"},
    {name = "path"},
    {name = "buffer"}
  },
  experimental = {
    ghost_text = true
  },
  formatting = {
    format = lspkind.cmp_format {
      with_text = true,
      menu = {
        nvim_lsp = "[LSP]",
        nvim_lua = "[API]",
        calc = "[CALC]",
        cmdline = "[CMD]",
        spell = "[SPELL]",
        path = "[PATH]",
        luasnip = "[SNIP]",
        buffer = "[BUFF]",
      }
    }
  }
}

  cmp.setup.cmdline('?', {
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

require("nvim-treesitter.configs").setup {
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        -- Or you can define your own textobjects like this
        ["iF"] = {
          python = "(function_definition) @function",
          cpp = "(function_definition) @function",
          c = "(function_definition) @function",
          java = "(method_declaration) @function"
        }
      }
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner"
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner"
      }
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer"
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer"
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer"
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer"
      }
    }
  }
}

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
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      typescript = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      html = {
        -- prettier
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      rust = {
        -- Rustfmt
        function()
          return {
            exe = "rustfmt",
            args = {"--emit=stdout"},
            stdin = true
          }
        end
      },
      jsx = {
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      css = {
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      svelte = {
        function()
          return {
            exe = "prettier",
            args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--single-quote"},
            stdin = true
          }
        end
      },
      lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      },
      c = {
        -- clang-format
        function()
          return {
            exe = "clang-format",
            args = {"--style", "GNU"},
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
  css = {rgb_fn = true}, -- Enable parsing rgb(...) functions in css.
  html = {names = false} -- Disable parsing "names" like Blue or Gray
}

require("Comment").setup()

require("nvim-treesitter.configs").setup {
  ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true, -- false will disable the whole extension
    additional_vim_regex_highlighting = false
  }
}

require("gitsigns").setup {
  signs = {
    add = {hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn"},
    change = {hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn"},
    delete = {hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn"},
    topdelete = {hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn"},
    changedelete = {hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn"}
  },
  numhl = false,
  linehl = false,
  keymaps = {
    -- Default keymap options
    noremap = true,
    ["n ]c"] = {expr = true, '&diff ? \']c\' : \'<cmd>lua require"gitsigns.actions".next_hunk()<CR>\''},
    ["n [c"] = {expr = true, '&diff ? \'[c\' : \'<cmd>lua require"gitsigns.actions".prev_hunk()<CR>\''},
    ["n <leader>ys"] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ["v <leader>ys"] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ["n <leader>yu"] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ["n <leader>yr"] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ["v <leader>yr"] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ["n <leader>yR"] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ["n <leader>yp"] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ["n <leader>yb"] = '<cmd>lua require"gitsigns".blame_line(true)<CR>',
    -- Text objects
    ["o ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ["x ih"] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
  watch_index = {
    interval = 1000,
    follow_files = true
  },
  current_line_blame = false,
  current_line_blame_delay = 1000,
  current_line_blame_position = "eol",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  word_diff = false,
  use_decoration_api = true,
  use_internal_diff = true -- If luajit is present
}

local opts = {noremap = true, silent = true}

--Remap space as leader key
vim.api.nvim_set_keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window navigation movement
vim.api.nvim_set_keymap("n", "<leader>h", ":wincmd h<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>k", ":wincmd k<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>j", ":wincmd j<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>l", ":wincmd l<CR>", opts)

-- Line  Movement
vim.api.nvim_set_keymap("n", "<C-j>", ":t.<CR>", opts)
vim.api.nvim_set_keymap("n", "<C-k>", ":t-1<CR>", opts)
vim.api.nvim_set_keymap("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
vim.api.nvim_set_keymap("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- My greates remap yet
vim.api.nvim_set_keymap("i", "<C-l>", "<C-o>A", opts)
vim.api.nvim_set_keymap("i", "<C-e>", "<C-Right>", opts)
vim.api.nvim_set_keymap("i", "<C-i>", "<C-Right>", opts)
vim.api.nvim_set_keymap("n", "<Esc>", ":nohlsearch<CR>", opts)

vim.api.nvim_set_keymap("n", "[d", ":lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "]d", ":lua vim.lsp.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "gD", ":lua vim.lsp.buf.declaration()<CR>", opts)
vim.api.nvim_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts)
vim.api.nvim_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)
-- vim.api.nvim_set_keymap("n", "<C-k>", ":lua vim.lsp.buf.signature_help()<CR>", opts)

-- Sorce config file
vim.api.nvim_set_keymap("n", "<leader>s", ":so ~/.config/nvim/init.lua<CR>", opts)

-- Sorce config file
vim.api.nvim_set_keymap("n", "<leader>F", ":FormatWrite<CR>", opts)

-- Y yank until the end of line
-- vim.api.nvim_set_keymap("n", "Y", "y$", opts)

-- vim.api.nvim_set_keymap("n", "J", "mzJ`z`", opts)
-- vim.api.nvim_set_keymap("n", "n", "nzzzv", opts)
-- vim.api.nvim_set_keymap("n", "N", "Nzzzv", opts)

-- NEXT n PREV buffer
vim.api.nvim_set_keymap("n", "<leader>t", ":bel 15sp term://zsh<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>T", ":bel 15sp <CR>", opts)

-- This work better for me
vim.api.nvim_set_keymap("n", "<leader>e", ":Ex<CR>", opts)

--Remap for dealing with word wrap
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", {noremap = true, expr = true, silent = true})
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", {noremap = true, expr = true, silent = true})

-- Escape terminal
vim.api.nvim_set_keymap("t", "<C-\\><C-\\>", "<C-\\><C-n>", opts)
vim.api.nvim_set_keymap("t", "<C-\\>\\", "<C-\\><C-n>", opts)

-- alternative shorcuts without fzf
vim.api.nvim_set_keymap("n", "<leader>.", ":e<space>**/", opts)
vim.api.nvim_set_keymap("n", "<leader>sT", ":tjump *", opts)

-- -- buffer jump, useful
-- vim.api.nvim_set_keymap("n", "<leader>bb", ":buffer ", opts)
-- vim.api.nvim_set_keymap("n", "<leader>bv", ":vertical sbuffer ", opts)
-- vim.api.nvim_set_keymap("n", "<leader>bs", ":sbuffer ", opts)

-- -- My greates remap ever... I don't see the need of fzf
-- vim.api.nvim_set_keymap("n", "<leader>ff", ":find ", opts)
-- vim.api.nvim_set_keymap("n", "<leader>fv", ":vertical sfind ", opts)
-- vim.api.nvim_set_keymap("n", "<leader>fs", ":sfind ", opts)

-- nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
-- nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
-- nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
-- nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

vim.api.nvim_set_keymap("n", "<leader>f", ":lua require('telescope.builtin').find_files()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>F", ":lua require('telescope.builtin').buffers()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>g", ":lua require('telescope.builtin').live_grep()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>G", ":lua require('telescope.builtin').grep_string()<cr>", opts)

-- Managing buffers and Windows
vim.api.nvim_set_keymap("n", "<leader>bd", ":bdelete!<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>>", ":bn<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader><", ":bp<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>q", ":close<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>o", ":only<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>O", ":unhide<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>_", ":res<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>|", ":vert res<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>w", "<C-w>", opts)

vim.api.nvim_set_keymap("n", "<leader>R", ':call Exec_on_term("normal")<CR>', opts)
vim.api.nvim_set_keymap("n", "<leader>R", ':<c-u>call Exec_on_term("visual")<CR>', opts)

-- Random
vim.api.nvim_set_keymap("n", "<leader>;", ":", opts)

require'snippets'
