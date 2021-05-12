syntax on

set guicursor=
set relativenumber
set nohlsearch
set hidden
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set noswapfile
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8
set completeopt=menuone,noinsert,noselect


"" Highly Expirimental, for vim folding
"augroup vimrc
"  au BufReadPre * setlocal foldmethod=indent
"  au BufWinEnter * if &fdm == 'indent' | setlocal foldmethod=manual | endif
"augroup END

" set foldcolumn=2

augroup remember_folds
  autocmd!
  autocmd BufWinLeave * silent! mkview
  autocmd BufWinEnter * silent! loadview
augroup END

" vnoremap . :norm.<CR>
" Check speeling for the following documents
"
set colorcolumn=72
augroup remember_folds
        autocmd!
        autocmd FileType markdown setlocal spell
        autocmd FileType mail setlocal spell
        autocmd BufRead,BufNewFile *.md setlocal spell
        autocmd BufRead,BufNewFile *.tex setlocal spell
        autocmd BufRead,BufNewFile *.txt setlocal spell
augroup END

"" Give more space for displaying messages.
" set cmdheight=2

"" Having Having updatetime (default is 4000 ms = 4 s) leads to noticeable
"" delays and Having user experience.
set updatetime=50

"" Don't pass messages to |ins-completion-menu|.
"set shortmess+=c
" highlight ColorColumn ctermbg=0 guibg=lightgrey

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dense-analysis/ale'
Plug 'gruvbox-community/gruvbox'
Plug 'tpope/vim-repeat'
Plug 'vim-airline/vim-airline'
Plug 'cohama/lexima.vim'
Plug 'evanleck/vim-svelte'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'junegunn/limelight.vim'
Plug 'junegunn/goyo.vim'
Plug 'machakann/vim-sandwich'
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

call plug#end()

" let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_material_better_performance = 1
runtime macros/sandwich/keymap/surround.vim

if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'

let g:ale_fixers = {
\   'javascript': ['prettier'],
\   'css': ['prettier'],
\}

colorscheme gruvbox
set background=dark
let g:ale_disable_lsp = 1
let g:ale_sign_column_always = 1

" "   ~always keep the signcolumn open!!
" set signcolumn=yes
" augroup LanguageClient_config
"   autocmd!
"   (autocmd) User LanguageClientStarted setlocal signcolumn=yes
"   #autocmd User LanguageClientStopped setlocal signcolumn=yes#
" augroup END


"if executable('rg')
"    let g:rg_derive_root='true'
"endif

"let loaded_matchparen = 1
let mapleader = " "

let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 25
let g:netrw_localrmdir='rm -r'


"nnoremap <leader>ps :lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For >")})<CR>
"nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>s :so ~/.config/nvim/init.vim<CR>
nnoremap <leader>e :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>n :bn<CR>
nnoremap <leader>N :bp<CR>
nnoremap <leader>p :FZF<CR>
nnoremap <leader>l :ls<CR>
nnoremap <leader>b :Ex<CR>

nnoremap <leader>` :bel 10sp term://zsh<CR>
nnoremap <leader>j :bel 10sp<CR>
nnoremap <leader>f :Prettier<CR>


nnoremap <leader>\l :Limelight.8<CR>
nnoremap <leader>\L :Limelight!<CR>

nnoremap <leader>\g :Goyo<CR>

nnoremap <leader>~ :vsp term://zsh<CR>

" autocmd TerminalOpen * set nonu

" nmap <C-P> :FZF<CR>
nmap ]g :ALENextWrap<CR>
nmap [g :ALEPreviousWrap<CR>
nmap ]G :ALELast
nmap [G :ALEFirst
" silent! nmap <C-P> :GFiles<CR>

let g:fzf_action = {
  \ 'ctrl-n': 'argadd',
  \ 'ctrl-e': 'edit',
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-j': 'vsplit' }

command! -nargs=0 Prettier :CocCommand prettier.formatFile


"" Vim with me
"nnoremap <leader>vwm :colorscheme gruvbox<bar>:set background=dark<CR>
"nmap <leader>vtm :highlight Pmenu ctermbg=gray guibg=gray

"vnoremap X "_d
"inoremap <C-c> <esc>

"command! -nargs=0 Prettier :CocCommand prettier.formatFile
"inoremap <silent><expr> <C-space> coc#refresh()

if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also https://sunaku.github.io/vim-256color-bce.html
    set t_ut=
endif

" highlight Normal ctermbg=none guibg=none
" highlight SignColumn ctermbg=none guibg=none
" highlight LineNr ctermbg=none guibg=none

"Split teminal on right side
:set splitright
" send paragraph under curso to terminal
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

nnoremap <F6> :call Exec_on_term("normal")<CR>
vnoremap <F6> :<c-u>call Exec_on_term("visual")<CR>

let g:airline#extensions#ale#enabled = 1
" let g:ale_sign_column_always = 1
" :set signcolumn=yes

"" Use <c-space> to trigger completion.
"if has('nvim')
"  inoremap <silent><expr> <c-space> coc#refresh()
"else
"  inoremap <silent><expr> <c-@> coc#refresh()
"endif

"" YES
com! W w

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

:au FocusLost * :wa
:au FocusLost * silent! wa
