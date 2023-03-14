local opts = { noremap = true, silent = true }


--Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Window navigation movement
vim.keymap.set("n", "<leader>h", ":wincmd h<CR>", opts)
vim.keymap.set("n", "<leader>k", ":wincmd k<CR>", opts)
vim.keymap.set("n", "<leader>j", ":wincmd j<CR>", opts)
vim.keymap.set("n", "<leader>l", ":wincmd l<CR>", opts)

-- Line  Movement
vim.keymap.set("n", "<C-j>", ":t.<CR>", opts)
vim.keymap.set("n", "<C-k>", ":t-1<CR>", opts)
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", opts)

-- My greates remap yet
vim.keymap.set("i", "<C-l>", "<C-o>A", opts)
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", opts)

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
vim.keymap.set('n', 'gR', vim.lsp.buf.references, opts)
vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)

-- format code based on a specific file type, use the LSP formnater if none
-- is mathch | asumem jq, black, prettier is installed on ypur machine
vim.keymap.set('n', '<space>F', function()
    if vim.bo.filetype == 'json' then
        vim.cmd('%!jq')
    elseif vim.bo.filetype == 'python' then
        vim.cmd('silent !black -q %')
    elseif vim.bo.filetype == 'css'
        and vim.bo.filetype == 'scss' then
        vim.cmd('silent !prettier -w %')
    else
        vim.lsp.buf.format()
    end
end, opts)



-- format code based on a specific file type, use the LSP formnater if none
-- is mathch | asumem jq, black, prettier is installed on ypur machine
vim.keymap.set('n', '<C-l>',':set colorcolumn=80 <CR>' , opts)

-- vim.keymap.set('n', '<space>s', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
vim.keymap.set('n', '<space>K', vim.lsp.buf.signature_help, opts)
vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
vim.keymap.set('n', '<space>d', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<space>i', vim.lsp.buf.implementation, opts)



-- Sorce config file
-- vim.keymap.set("n", "<leader>F", ":FormatWrite<CR>", opts)

-- Supper Mapping to substitue// Degeration mapping
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-R><C-W>\\>/<C-R>0/g<CR>", opts)


-- vim.keymap.set("n", "J", "mzJ`z`", opts)
-- vim.keymap.set("n", "n", "nzzzv", opts)
-- vim.keymap.set("n", "N", "Nzzzv", opts)

-- vim.keymap.set("n", "d", '"xd', opts)
-- vim.keymap.set("n", "D", '"xD', opts)
-- vim.keymap.set("n", "c", '"xc', opts)
-- vim.keymap.set("n", "C", '"xC', opts)

-- NEXT n PREV buffer


vim.keymap.set("n", "<leader>t", ":bel 15sp term://zsh<CR>", opts)
vim.keymap.set("n", "<leader>T", function()
    -- local buffers = vim.vi
    -- for k, v in pairs(buffers) do
    -- print("I suppose to do magic here")
    -- -- end
end, opts)
-- vim.keymap.set("n", "<leader>t", ":tabnew | term <CR>", opts)
-- vim.keymap.set("n", "<leader>T", ":bel 10sp<CR>", opts)

-- This work better for me
vim.keymap.set("n", "<leader>e", ":Ex <CR>", opts)

-- --Remap for dealing with word wrap
-- vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", opts)
-- vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'",  opts)

-- Escape terminal
vim.keymap.set("t", "<C-\\><C-\\>", "<C-\\><C-n>", opts)
vim.keymap.set("t", "<C-\\>\\", "<C-\\><C-n>", opts)

-- alternative shorcuts without fzf
vim.keymap.set("n", "<leader>.", ":e<space>**/", opts)
vim.keymap.set("n", "<leader>sT", ":tjump *", opts)
vim.keymap.set("n", "<leader>M", ":make <CR>", opts)


-- Insert timestamp in file
vim.keymap.set("n", "<F3>", 'i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>', opts)
vim.keymap.set("i", "<F3>", '<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>', opts)


-- -- buffer jump, useful
-- vim.keymap.set("n", "<leader>bb", ":buffer ", opts)
-- vim.keymap.set("n", "<leader>bv", ":vertical sbuffer ", opts)
-- vim.keymap.set("n", "<leader>bs", ":sbuffer ", opts)

-- -- My greates remap ever... I don't see the need of fzf
-- vim.keymap.set("n", "<leader>ff", ":find ", opts)
-- vim.keymap.set("n", "<leader>fv", ":vertical sfind ", opts)
-- vim.keymap.set("n", "<leader>fs", ":sfind ", opts)

-- nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
-- nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
-- nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
-- nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

vim.keymap.set("n", "<leader>f", require('telescope.builtin').find_files, opts)
vim.keymap.set("n", "<leader>b", require('telescope.builtin').buffers, opts)
vim.keymap.set("n", "<leader>rg", require('telescope.builtin').live_grep, opts)
vim.keymap.set("n", "<leader>rr", require('telescope.builtin').grep_string, opts)
vim.keymap.set("n", "<leader>re", require('telescope.builtin').registers, opts)
vim.keymap.set("n", "<leader>gb", require('telescope.builtin').git_branches, opts)
vim.keymap.set("n", "<leader>gs", require('telescope.builtin').git_status, opts)
vim.keymap.set("n", "<leader>m", require('telescope.builtin').marks, opts)
vim.keymap.set("n", "<leader>gc", ":Git commit -v <CR>", opts)
vim.keymap.set("n", "<leader>gC", ":Git commit --amend --no-edit <CR>", opts)
vim.keymap.set("n", "<leader>gS", ":Git stash", opts)
vim.keymap.set("n", "<leader>gSa", ":Git stash apply", opts)
vim.keymap.set("n", "<leader>G", ":Git ", opts)
vim.keymap.set("n", "<leader>ga", ":Git add --update <CR> ", opts)
vim.keymap.set("n", "<leader>gp", ":Git pull <CR>", opts)
vim.keymap.set("n", "<leader>gP", ":Git push <CR>", opts)
vim.keymap.set("n", "<leader>gm", ":Git merge ", opts)
vim.keymap.set("n", "<leader>u", ":UndotreeToggle <CR>", opts)


-- Managing buffers and Windows
vim.keymap.set("n", "<leader>B", ":bdelete!<CR>", opts)
vim.keymap.set("n", "<leader>>", ":bn<CR>", opts)
vim.keymap.set("n", "<leader><", ":bp<CR>", opts)
vim.keymap.set("n", "<leader>.", ":cnext<CR>", opts)
vim.keymap.set("n", "<leader>,", ":cprevious<CR>", opts)
vim.keymap.set("n", "<leader>q", ":close<CR>", opts)
vim.keymap.set("n", "<leader>o", ":only<CR>", opts)
vim.keymap.set("n", "<leader>O", ":unhide<CR>", opts)
vim.keymap.set("n", "<leader>_", ":res<CR>", opts)
vim.keymap.set("n", "<leader>|", ":vert res<CR>", opts)
-- vim.keymap.set("n", "<leader>w", "<C-w>", opts)
vim.keymap.set("n", "<leader>scb", ":set scb!<CR>", opts)


-- Random
vim.keymap.set("n", "<leader>;", ":", opts)

-- Lua
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble<cr>", opts)
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", opts)
vim.keymap.set("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", opts)
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble loclist<cr>", opts)
vim.keymap.set("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", opts)
vim.keymap.set("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)
