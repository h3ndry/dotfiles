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


