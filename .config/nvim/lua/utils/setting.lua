
-- Highlight on yank
vim.cmd  [[
  augroup YankHighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank()
  augroup end
]]

-- Save as sudo...
vim.api.nvim_exec([[
    cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!
]], false)


-- -- Use clipboard asynch
-- vim.api.nvim_exec([[
--       set clipboard=unnamedplus
-- ]], false)

-- auto save on FocusLost
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

	:set shada='1000,f1

    set tabstop=4
    set shiftwidth=4
    set expandtab
    set shiftwidth=0
    set report=0
    set path+=**
    set wildignore+=**/node_modules/**
    set shortmess+=c
    let g:netrw_liststyle=3

    let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
    set laststatus=0
    set fillchars=stl:\ 
    set statusline=\ 

    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

    :set splitright
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

    nnoremap <space>R :call Exec_on_term("normal")<CR>
    vnoremap <space>R :<c-u>call Exec_on_term("visual")<CR>


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
vim.o.updatetime = 300
vim.wo.signcolumn = "yes"
