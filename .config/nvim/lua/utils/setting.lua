local function trim_trailing_whitespaces()
  if vim.bo.modifiable == true
      and vim.bo.filetype ~= 'TelescopePrompt'
      and vim.bo.filetype ~= 'neo-tree-popup' then
    local view = vim.fn.winsaveview()
    vim.cmd [[keep %s/\s\+$//e]]
    -- vim.cmd [[%s#\($\n\s*\)\+\%$##]]
    vim.cmd "update"
    vim.fn.winrestview(view)
  end
end


local function term_config()
  if vim.bo.buftype == 'terminal' then
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.cmd [[ startinsert ]]
  else
    -- vim.wo.number = true
    -- vim.wo.relativenumber = true
    trim_trailing_whitespaces()
  end
end



-- Super cool, works perfect.... I am proud of myself
local group_1 = vim.api.nvim_create_augroup("hide-numbers", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    if vim.bo.buftype == 'terminal'
      or vim.bo.filetype == 'markdown'
      or vim.bo.filetype == 'neo-tree' then
      vim.wo.number = false
      vim.wo.relativenumber = false
      vim.o.wrap = true
      vim.o.textwidth = 80
      -- vim.cmd [[ startinsert ]]
    else
      vim.wo.number = true
      vim.wo.relativenumber = true
      vim.o.wrap = false
      trim_trailing_whitespaces()
    end
  end,
  group = group_1
})

vim.api.nvim_create_autocmd(
  "TermOpen", { callback = term_config, group = group_1 }
)

local group_2 = vim.api.nvim_create_augroup("auto-save", { clear = true })

vim.api.nvim_create_autocmd(
  "FocusLost", { callback = trim_trailing_whitespaces, group = group_2 }
)

-- Highlight on yank
vim.cmd [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- Save as sudo...
vim.cmd([[
    cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
]])


vim.cmd(
  [[
    set spelllang=en
    set complete+=kspell
    augroup markdownSpell
        autocmd!
        autocmd FileType markdown setlocal spell
        autocmd BufRead,BufNewFile *.md setlocal spell
        autocmd FileType gitcommit setlocal spell
        autocmd FileType gitcommit setlocal complete+=kspell
    augroup END
]])



vim.cmd(
  [[
	set shada='1000,f1
    set path+=**
    set wildignore+=**/node_modules/**
    set shortmess+=c
    let g:netrw_liststyle=3
    set splitright
    " set noshowmode
    set clipboard+=unnamedplus

    highlight! CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080
    highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
    highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
    highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
    highlight! CmpItemKindInterface guibg=NONE guifg=#9CDCFE
    highlight! CmpItemKindText guibg=NONE guifg=#9CDCFE
    highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
    highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
    highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
    highlight! CmpItemKindProperty guibg=NONE guifg=#D4D4D4
    highlight! CmpItemKindUnit guibg=NONE guifg=#D4D4D4

]]
)

vim.o.termguicolors = true
vim.cmd [[colorscheme gruvbox]]
-- vim.cmd [[colorscheme github_dark_default]]
-- vim.cmd [[set background=light]]
vim.o.completeopt = "menu,menuone,noinsert"
vim.g.netrw_banner = 0
vim.o.inccommand = "nosplit"
-- vim.g.did_load_filetypes = 1
vim.o.hidden = true
vim.o.breakindent = true
vim.o.wrap = false
vim.cmd [[set undofile]]
vim.o.ignorecase = true
vim.o.smartcase = true
vim.wo.signcolumn = "yes"
vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.errorbells = false
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.incsearch = true
vim.o.laststatus = 0
vim.opt.termguicolors = true
vim.o.pumheight = 8
vim.opt.scrolloff = 2
vim.opt.signcolumn = "yes"
-- vim.opt.isfname:append("@-@")
-- vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- Give more space for displaying messages.
-- vim.opt.cmdheight = 1

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 50
-- Don't pass messages to |ins-completion-menu|.
vim.opt.shortmess:append("c")
-- vim.opt.colorcolumn = "80"
vim.g.mapleader = " "

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
  vim.lsp.handlers.hover,
  { border = 'rounded' }
)

vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
  vim.lsp.handlers.signature_help,
  { border = 'rounded' }
)

vim.diagnostic.config {
  float = { source = "always",  border = "rounded"  },
  signs = false,
  severity_sort = true,
}
