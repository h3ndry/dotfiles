local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

--Enable completion triggered by <c-x><c-o>
buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

-- Mappings.
local opts = { noremap=true, silent=true }

-- See `:help vim.lsp.*` for documentation on any of the below functions
buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)


--Remap space as leader key
vim.api.nvim_set_keymap('', '<Space>', '<Nop>', opts)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Window navigation movement
vim.api.nvim_set_keymap('n', '<leader>h', ':wincmd h<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>k', ':wincmd k<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>j', ':wincmd j<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>l', ':wincmd l<CR>', opts)

-- Line  Movement
vim.api.nvim_set_keymap('n', '<C-j>', ':t.<CR>', opts)
vim.api.nvim_set_keymap('n', '<C-k>', ':t-1<CR>', opts)
vim.api.nvim_set_keymap('v', '<C-j>', ":m '>+1<CR>gv=gv", opts)
vim.api.nvim_set_keymap('v', '<C-k>', ":m '<-2<CR>gv=gv", opts)

-- Sorce config file
vim.api.nvim_set_keymap('v', '<leader>s', ":so ~/.config/nvim/init.lua<CR>", opts)

-- Y yank until the end of line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- NEXT n PREV buffer
vim.api.nvim_set_keymap('n', '<leader>n', ":bn<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>N', ":bp<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>t', ":bel 10sp term://zsh<CR>", opts)
vim.api.nvim_set_keymap('n', '<leader>T', ":bel 10sp<CR>", opts)

-- Escape terminal
vim.api.nvim_set_keymap('t', '<C-\\><C-\\>', '<C-\\><C-n>', { noremap = true })
vim.api.nvim_set_keymap('t', '<C-\\>\\', '<C-\\><C-n>', { noremap = true })

-- alternative shorcuts without fzf
vim.api.nvim_set_keymap('n', '<leader>,', ':buffer *', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>.', ':e<space>**/', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>sT', ':tjump *', { noremap = true })

-- Managing buffers
vim.api.nvim_set_keymap('n', '<leader>bd', ':bdelete<CR>', { noremap = true, silent = true })

-- Random
vim.api.nvim_set_keymap('n', '<leader>;', ':', { noremap = true, silent = false })


require'nvim-treesitter.configs'.setup {
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
          java = "(method_declaration) @function",
        },
      },
    },
  },
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
  },
}

require'nvim-treesitter.configs'.setup {
  textobjects = {
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
}
