local wk = require("which-key")

vim.keymap.set("", "<Space>", "<Nop>")
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Line  Movementnnoremap <C-S-k> :YourCommandHere<CR>
vim.keymap.set("n", "<C-S-j>", ":t.<CR>")
vim.keymap.set("n", "<C-S-k>", ":t-1<CR>")
vim.keymap.set("v", "<C-S-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-S-k>", ":m '<-2<CR>gv=gv")


vim.keymap.set("v", "<leader>f", ":!pg_format <CR>")

-- My greates remap yet
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>")

-- -- format code based on a specific file type, use the LSP formnater if none
-- -- is mathch | asumem jq, black, prettier is installed on ypur machine
-- vim.keymap.set('n', '<space>F', function()
--     if vim.bo.filetype == 'json' then
--         vim.cmd('%!jq')
--     elseif vim.bo.filetype == 'python' then
--         vim.cmd('silent !black -q %')
--     elseif vim.bo.filetype == 'css'
--         and vim.bo.filetype == 'scss' then
--         vim.cmd('silent !prettier -w %')
--     -- elseif vim.bo.filetype == 'typescriptreact' then
--     --     vim.cmd('silent !prettier -w %')
--     else
--         vim.lsp.buf.format()
--     end
-- end)


-- vim.cmd(
--   [[
--     :set splitright
--     function! Exec_on_term(cmd)
--
--       if a:cmd=="normal"
--         exec "normal mk\"vyip"
--       else
--         exec "normal gv\"vy"
--       endif
--
--       if !exists("g:last_terminal_chan_id")
--         vs
--         terminal
--         let g:last_terminal_chan_id = b:terminal_job_id
--         wincmd p
--       endif
--
--       if getreg('"v') =~ "^\n"
--         call chansend(g:last_terminal_chan_id, expand("%:p")."\n")
--       else
--         call chansend(g:last_terminal_chan_id, @v)
--       endif
--       exec "normal `k"
--     endfunction
--
--     " nnoremap <space>r :call Exec_on_term("normal")<CR>
--     " vnoremap <space>r :<c-u>call Exec_on_term("visual")<CR>
-- ]]
-- )


-- format code based on a specific file type, use the LSP formnater if nonekey
-- is mathch | asumem jq, black, prettier is installed on ypur machine
-- vim.keymap.set('n', '<C-l>', ':set colorcolumn=80 <CR>')

-- vim.keymap.set('n', '<space>s', '<cmd>lua vim.diagnostic.setloclist()<CR>')


-- Supper Mapping to substitue// Degeration mapping
vim.keymap.set("n", "<leader>S", ":%s/\\<<C-R><C-W>\\>/<C-R>0/g<CR>")
vim.keymap.set("n", "<leader>e", ":Neotree <CR>")
vim.keymap.set("t", "<C-\\><C-\\>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-\\>\\", "<C-\\><C-n>")
vim.keymap.set("n", "<leader>.", ":e<space>**/")
-- vim.keymap.set("n", "<leader>sT", ":tjump *")
vim.keymap.set("n", "<leader>M", ":make <CR>")
vim.keymap.set("n", "<leader>cr", ":!cargo run <CR>")
vim.keymap.set("n", "<leader>ct", ":!cargo test <CR>")


-- Managing buffers and Windows
vim.keymap.set("n", "<leader>B", ":bdelete!<CR>")
vim.keymap.set("n", "<leader>>", ":bn<CR>")
vim.keymap.set("n", "<leader><", ":bp<CR>")
vim.keymap.set("n", "<leader>.", ":cnext<CR>")
vim.keymap.set("n", "<leader>,", ":cprevious<CR>")
vim.keymap.set("n", "<leader>q", ":close<CR>")
vim.keymap.set("n", "<leader>o", ":only<CR>")
-- vim.keymap.set("n", "<leader>O", ":unhide<CR>")
vim.keymap.set("n", "<leader>_", ":res<CR>")
-- vim.keymap.set("n", "<leader>|", ":vert res<CR>")
