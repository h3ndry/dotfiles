local opts = { noremap = true, silent = true }


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
vim.api.nvim_set_keymap("n", "<Esc>", ":nohlsearch<CR>", opts)

vim.api.nvim_set_keymap("n", "[d", ":lua vim.diagnostic.goto_prev()<CR>", opts)
vim.api.nvim_set_keymap("n", "]d", ":lua vim.diagnostic.goto_next()<CR>", opts)
vim.api.nvim_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts)
vim.api.nvim_set_keymap("n", "gD", ":lua vim.lsp.buf.declaration()<CR>", opts)
vim.api.nvim_set_keymap("n", "gd", ":lua vim.lsp.buf.definition()<CR>", opts)
vim.api.nvim_set_keymap("n", "K", ":lua vim.lsp.buf.hover()<CR>", opts)
vim.api.nvim_set_keymap('n', 'gR', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
vim.api.nvim_set_keymap('n', 'gI', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>F', '<cmd>lua vim.lsp.buf.format()<CR>', opts)
-- vim.api.nvim_set_keymap('n', '<space>s', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>K', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>i', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)



-- Sorce config file
-- vim.api.nvim_set_keymap("n", "<leader>F", ":FormatWrite<CR>", opts)

-- Supper Mapping to substitue// Degeration mapping
vim.api.nvim_set_keymap("n", "<leader>s", ":%s/<C-R><C-W>/<C-R>0/g<CR>", opts)


-- vim.api.nvim_set_keymap("n", "J", "mzJ`z`", opts)
-- vim.api.nvim_set_keymap("n", "n", "nzzzv", opts)
-- vim.api.nvim_set_keymap("n", "N", "Nzzzv", opts)

-- vim.api.nvim_set_keymap("n", "d", '"xd', opts)
-- vim.api.nvim_set_keymap("n", "D", '"xD', opts)
-- vim.api.nvim_set_keymap("n", "c", '"xc', opts)
-- vim.api.nvim_set_keymap("n", "C", '"xC', opts)

-- NEXT n PREV buffer

function open_terminal()
	local buffers = vim.api.nvim_list_bufs()

	for k, v in pairs(buffers) do
		print(k)
	end
end

vim.api.nvim_set_keymap("n", "<leader>t", ":bel 15sp term://zsh<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>T", ':lua open_terminal()<CR>', opts)
-- vim.api.nvim_set_keymap("n", "<leader>t", ":tabnew | term <CR>", opts)
-- vim.api.nvim_set_keymap("n", "<leader>T", ":bel 10sp<CR>", opts)

-- This work better for me
vim.api.nvim_set_keymap("n", "<leader>e", ":Ex <CR>", opts)

--Remap for dealing with word wrap
vim.api.nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { noremap = true, expr = true, silent = true })
vim.api.nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { noremap = true, expr = true, silent = true })

-- Escape terminal
vim.api.nvim_set_keymap("t", "<C-\\><C-\\>", "<C-\\><C-n>", opts)
vim.api.nvim_set_keymap("t", "<C-\\>\\", "<C-\\><C-n>", opts)

-- alternative shorcuts without fzf
vim.api.nvim_set_keymap("n", "<leader>.", ":e<space>**/", opts)
vim.api.nvim_set_keymap("n", "<leader>sT", ":tjump *", opts)


-- Insert timestamp in file
vim.api.nvim_set_keymap("n", "<F3>", 'i<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR><Esc>', opts)
vim.api.nvim_set_keymap("i", "<F3>", '<C-R>=strftime("%Y-%m-%d %a %I:%M %p")<CR>', opts)


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
vim.api.nvim_set_keymap("n", "<leader>b", ":lua require('telescope.builtin').buffers()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>rg", ":lua require('telescope.builtin').live_grep()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>rr", ":lua require('telescope.builtin').grep_string()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>re", ":lua require('telescope.builtin').registers()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>gb", ":lua require('telescope.builtin').git_branches()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>gs", ":lua require('telescope.builtin').git_status()<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>gc", ":Git commit -v <CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gC", ":Git commit --amend --no-edit <CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gS", ":Git stash", opts)
vim.api.nvim_set_keymap("n", "<leader>gSa", ":Git stash apply", opts)
vim.api.nvim_set_keymap("n", "<leader>G", ":Git ", opts)
vim.api.nvim_set_keymap("n", "<leader>ga", ":Git add --update <CR> ", opts)
vim.api.nvim_set_keymap("n", "<leader>gp", ":Git pull <CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gP", ":Git push <CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>gm", ":Git merge ", opts)


-- Managing buffers and Windows
vim.api.nvim_set_keymap("n", "<leader>B", ":bdelete!<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>>", ":bn<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader><", ":bp<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>.", ":cnext<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>,", ":cprevious<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>q", ":close<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>o", ":only<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>O", ":unhide<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>_", ":res<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>|", ":vert res<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>w", "<C-w>", opts)
vim.api.nvim_set_keymap("n", "<leader>scb", ":set scb!<CR>", opts)


-- Random
vim.api.nvim_set_keymap("n", "<leader>;", ":", opts)

-- Lua
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>Trouble<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>xl", "<cmd>Trouble loclist<cr>", opts)
vim.api.nvim_set_keymap("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", opts)
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", opts)

vim.keymap.set("n", "y", "<Plug>(YankyYank)", {})
vim.keymap.set("x", "y", "<Plug>(YankyYank)", {})
