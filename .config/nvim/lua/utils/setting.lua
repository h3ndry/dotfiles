vim.o.swapfile = false
vim.o.tabstop = 4
vim.o.tabstop = 4
vim.bo.shiftwidth = 4
vim.o.report = 0
vim.bo.expandtab = true


local function trim_trailing_whitespaces()
	if vim.bo.modifiable == true then
		local view = vim.fn.winsaveview()
		vim.cmd [[keepp %s/\s\+$//e]]
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
		vim.wo.number = true
		vim.wo.relativenumber = true
		trim_trailing_whitespaces()
	end
end

-- Super cool, works perfect.... I am proud of myself
local group_1 = vim.api.nvim_create_augroup("hide-numbers", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", { callback = function ()
	if vim.bo.buftype == 'terminal' then
		vim.wo.number = false
		vim.wo.relativenumber = false
		-- vim.cmd [[ startinsert ]]
	else
		vim.wo.number = true
		vim.wo.relativenumber = true
		trim_trailing_whitespaces()
	end
end, group = group_1 })

vim.api.nvim_create_autocmd("TermOpen", { callback = term_config, group = group_1 })

local group_2 = vim.api.nvim_create_augroup("auto-save", { clear = true })
vim.api.nvim_create_autocmd("FocusLost", { callback = trim_trailing_whitespaces, group = group_2 })

-- Highlight on yank
vim.cmd [[
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

-- -- auto save on FocusLost
-- --
-- -- Super cool, works perfect.... I am proud of myself


-- vim.api.nvim_exec([[
--     au FocusLost * :wa
--     au FocusLost * :wa
--     au FocusLost * silent! wa
--     au BufLeave * silent! wall
-- ]], false)

vim.api.nvim_exec(
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
]],
	false
)


vim.api.nvim_exec(
	[[
	set shada='1000,f1
    " set tabstop=4
    set path+=**
    set wildignore+=**/node_modules/**
    set shortmess+=c
    let g:netrw_liststyle=3
    set noshowmode

    let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
    set laststatus=3
    " set fillchars=stl:\
    " set statusline=\

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


    imap <silent><script><expr> <C-y> copilot#Accept("\<CR>")
    let g:copilot_no_tab_map = v:true

]],
	false
)

vim.o.termguicolors = true
vim.g.onedark_terminal_italics = 2
vim.cmd [[colorscheme github_dark]]
-- vim.cmd [[colorscheme poimandres]]
-- vim.cmd('colorscheme poimandres')
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
vim.o.scrolloff = 2
vim.o.updatetime = 150
vim.wo.signcolumn = "yes"
