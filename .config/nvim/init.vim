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
set incsearch
set noswapfile
set nobackup
set nobackup
set undodir=~/.config/nvim/undodir
set completeopt=menuone,noinsert,noselect
set spelllang=en
set nowrap
set background=dark

set updatetime=300

set ttimeout
set ttimeoutlen=0

" set signcolumn=yes

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
" set noruler
set laststatus=1
"set noshowcmd

" " vnoremap . :norm.<CR>
" " Check speeling for the following documents
" augroup remember_folds
"         autocmd!
"         autocmd FileType markdown setlocal spell
"         autocmd FileType mail setlocal spell
"         autocmd BufRead,BufNewFile *.md setlocal spell
"         autocmd BufRead,BufNewFile *.tex setlocal spell
"         autocmd BufRead,BufNewFile *.txt setlocal spell
" augroup END



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

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

" LSP Extensions
" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-compe'
Plug 'kabouzeid/nvim-lspinstall'
Plug 'nvim-lua/lsp_extensions.nvim'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'OrangeT/vim-csharp'

" post install (yarn install | npm install) then load plugin only for editing supported files
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'svelte', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }


Plug 'evanleck/vim-svelte', {'branch': 'main'}

" Color scheme
Plug 'h3ndry/tokyonight.nvim'

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

" Just make life more easy
Plug 'junegunn/goyo.vim'

call plug#end()

" colorscheme paramount
let g:tokyonight_style = "night"
colorscheme tokyonight
" colorscheme onedark


nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <C-j> :t.<CR>
nnoremap <C-k> :t-1<CR>
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv


nnoremap <leader>s :so ~/.config/nvim/init.vim<CR>
tnoremap <C-\><C-\> <C-\><C-n>

let g:netrw_banner=0
autocmd FileType netrw set nolist
let g:netrw_liststyle = 3


nnoremap <leader>e :Ex<CR>
nnoremap <leader>n :bn<CR>
nnoremap <leader>N :bp<CR>
nnoremap <leader>g :GFiles<CR>
nnoremap <leader>p :Prettier<CR>

nnoremap <leader>t :bel 10sp term://zsh<CR>
nnoremap <leader>T :bel 10sp<CR>

nnoremap <leader>\l :Limelight<CR>
nnoremap <leader>\L :Limelight!<CR>
nnoremap <leader>\g :Goyo<CR>
nmap <C-P> :FZF<CR>
nmap <C-L> :Buffers<CR>

lua require('lspsettings')
lua require('complection')

" inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <C-Space>      compe#confirm('<C-Space>')
" inoremap <silent><expr> <C-e>     compe#close('<C-e>')
" inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
" inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })



let g:UltiSnipsExpandTrigger="<C-Space>"
let g:UltiSnipsJumpForwardTrigger="<Tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-Tab>"


" let g:ulti_expand_or_jump_res = 0 "default value, just set once
" function! Ulti_ExpandOrJump_and_getRes()
"     call UltiSnips#ExpandSnippetOrJump()
"     return g:ulti_expand_or_jump_res
" endfunction

" inoremap <CR> <C-R>=(Ulti_ExpandOrJump_and_getRes() > 0)?"":"\n"<CR>

au FocusLost * :wa
au FocusLost * silent! wa

augroup rm_whitespace
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufEnter,BufWinEnter,TabEnter *.rs :lua require'lsp_extensions'.inlay_hints{}
augroup END

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({ ttimeout = 40 })
augroup END

fun! EmptyRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
endfun

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



" nnoremap <S-h> :call ToggleHiddenAll()<CR>
