set exrc
syntax on
set hidden
set relativenumber
set nu
set nohlsearch
set noerrorbells
set expandtab
set tabstop=4 softtabstop=4
set shiftwidth=4
set scrolloff=4
set incsearch
set noswapfile
set nobackup
set nobackup
set undodir=~/.config/nvim/undodir
set completeopt=menuone,noinsert,noselect
set nowrap
set background=dark

set updatetime=50

set ttimeout
set ttimeoutlen=0

set shortmess+=c
" highlight ColorColumn ctermbg=0 guibg=lightgrey

" set colorcolumn=80
let mapleader = " "

augroup remember_folds
  autocmd!
  autocmd BufWinLeave * silent! mkview
  autocmd BufWinEnter * silent! loadview
augroup END

"disable status line, I think it look nice this way
set noruler
set laststatus=1
"set noshowcmd

" vnoremap . :norm.<CR>
" Check speeling for the following documents
augroup remember_folds
        autocmd!
        autocmd FileType markdown setlocal spell
        autocmd FileType mail setlocal spell
        autocmd BufRead,BufNewFile *.md setlocal spell
        autocmd BufRead,BufNewFile *.tex setlocal spell
        autocmd BufRead,BufNewFile *.txt setlocal spell
augroup END



call plug#begin('~/.config/nvim/plugged')

" editing plugins
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'tpope/vim-repeat'
Plug 'cohama/lexima.vim'
" Plug 'vim-airline/vim-airline'

"navigation plugin
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'evanleck/vim-svelte'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'machakann/vim-sandwich'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'OmniSharp/omnisharp-vim'

" Color scheme
Plug 'owickstrom/vim-colors-paramount'
Plug 'h3ndry/tokyonight.nvim'
Plug 'ful1e5/onedark.nvim'

" Just make life more easy
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }
Plug 'junegunn/goyo.vim'

call plug#end()

" colorscheme paramount
let g:tokyonight_style = "night"
colorscheme tokyonight
" colorscheme onedark


" hi ActiveWindow  guibg=NONE ctermbg=NONE
" hi Normal guibg=NONE ctermbg=NONE
" hi InactiveWindow guibg=NONE ctermbg=NONE

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>s :so ~/.config/nvim/init.vim<CR>
tnoremap <C-\><C-\> <C-\><C-n>
let g:netrw_banner=0
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+,\(^\|\s\s\)ntuser\.\S\+'
autocmd FileType netrw set nolist
let g:netrw_liststyle = 3


nnoremap <leader>e :Ex<CR>
nnoremap <leader>n :bn<CR>
nnoremap <leader>N :bp<CR>
nnoremap <leader>g :GFiles<CR>

nnoremap <leader>` :bel 10sp term://zsh<CR>
nnoremap <leader>j :bel 10sp<CR>
nnoremap <leader>l :vs<CR>
nnoremap <leader>f :Prettier<CR>

nnoremap <leader>\l :Limelight.8<CR>
nnoremap <leader>\L :Limelight!<CR>
nnoremap <leader>\g :Goyo<CR>
nmap <C-P> :FZF<CR>
nmap <C-L> :Buffers<CR>

lua require('lspsettings')
lua require('complection')
lua require('just_settings_for_now')

inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })



let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

au FocusLost * :wa
au FocusLost * silent! wa

" augroup THE_PRIMEAGEN
"     autocmd!
"     autocmd BufWritePre * %s/\s\+$//e
"     autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
" augroup END

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

"Split teminal on right side
set splitright
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

if &term =~ '256color'
    " disable Background Color Erase (BCE) so that color schemes
    " render properly when inside 256-color tmux and GNU screen.
    " see also https://sunaku.github.io/vim-256color-bce.html
    set t_ut=
endif

let g:livepreview_previewer = 'zathura'

runtime macros/sandwich/keymap/surround.vim

let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction

nnoremap <S-h> :call ToggleHiddenAll()<CR>
