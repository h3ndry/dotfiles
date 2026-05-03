vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>R', '<cmd>restart<CR>')
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>D', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
-- vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
-- vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--nohlsearch

vim.keymap.set('', '<Space>', '<Nop>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Line  Movementnnoremap <C-S-k> :YourCommandHere<CR>
vim.keymap.set('n', '<C-j>', ':t.<CR>')
vim.keymap.set('n', '<C-k>', ':t-1<CR>')
vim.keymap.set('v', '<C-j>', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', '<C-k>', ":m '<-2<CR>gv=gv")

-- Diff get stafff
vim.keymap.set('n', '<leader>dh', ':diffget //2 <CR>')
vim.keymap.set('n', '<leader>dl', ':diffget //3 <CR>')

-- Diff get stafff
vim.keymap.set('n', '<leader>dH', ':%diffget //2 <CR>')
vim.keymap.set('n', '<leader>dL', ':%diffget //3 <CR>')

-- for some reason I need to save a lot since I am using oil.vim so better I have this
vim.keymap.set('n', '<leader>w', ':w <CR>')

-- My greates remap yet
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR>')

-- Supper Mapping to substitue// Degeration mapping
vim.keymap.set('n', '<leader>S', ':%s/\\<<C-R><C-W>\\>/<C-R>0/g<CR>')
vim.keymap.set('t', '<C-\\><C-\\>', '<C-\\><C-n>')

vim.keymap.set('t', '<C-\\>\\', '<C-\\><C-n>')

vim.keymap.set('t', '<leader><Esc>', '<C-\\><C-n>')

-- vim.keymap.set('t', '<C-_>', ':fc!')

vim.keymap.set('n', '<leader>A', ':!launch-agent.sh<CR>', { desc = 'Lauch agentic coding for this folder' })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'snacks_terminal', -- Replace 'lua' with your desired file type
  callback = function()
    vim.keymap.set('t', '<C-_>', function()
      vim.api.nvim_input '<C-\\><C-n>'
      require('snacks').terminal()
    end, { buffer = true }) -- Local to buffer
  end,
})

vim.keymap.set('n', '<leader>.', ':e<space>**/')
-- vim.keymap.set("n", "<leader>sT", ":tjump *")
vim.keymap.set('n', '<leader>M', ':wa<CR>:make<CR>')
vim.keymap.set('n', '<leader>cr', ':wa<CR>:!cargo run <CR>')
vim.keymap.set('n', '<leader>ct', ':wa<CR>:!cargo test <CR>')

-- Managing buffers and Windows
vim.keymap.set('n', '<leader>B', ':bdelete!<CR>')

vim.keymap.set('n', '<leader>mp', ':LivePreview start <CR>')

-- vim.keymap.set('n', '<leadereader>>', ':bn<CR>')
--
-- vim.keymap.set('n', '<leader><', ':bp<CR>')

-- vim.keymap.set('n', '<leader>.', ':cnext<CR>')
-- vim.keymap.set('n', '<leader>,', ':cprevious<CR>')

vim.keymap.set('n', '<leader>uu', ':UndotreeToggle<CR>')
vim.keymap.set('n', '<leader>q', ':close<CR>')
vim.keymap.set('n', '<leader>Q', ':tabc<CR>')
vim.keymap.set('n', '<leader><CR>', ':only<CR>')
vim.keymap.set('t', '<leader><CR>', ':only<CR>')
-- vim.keymap.set("n", "<leader>O", ":unhide<CR>")
vim.keymap.set('n', '<leader>_', ':res<CR>')

vim.keymap.set('v', '<leader>cl', ':CodeCompanion  ')

-- vim.keymap.set('n', '<leader>r', function()
--   vim.cmd 'normal! "zy'
--   local output = vim.fn.systemlist(vim.fn.getreg 'z')
--   local pos = vim.fn.getpos '.'
--   local last_line = vim.fn.line '$'
--   vim.cmd 'normal! }'
--   local first_blank = vim.fn.line '.'
--   if first_blank == last_line then
--     vim.api.nvim_buf_set_lines(0, last_line, last_line, false, { '' })
--     vim.api.nvim_buf_set_lines(0, last_line + 1, last_line + 1, false, output)
--   else
--     vim.cmd 'normal! }'
--     local second_blank = vim.fn.line '.'
--     if second_blank == first_blank or first_blank + 1 > second_blank - 1 then
--       vim.api.nvim_buf_set_lines(0, first_blank, first_blank, false, output)
--     else
--       vim.api.nvim_buf_set_lines(0, first_blank, second_blank - 1, false, output)
--     end
--   end
--   vim.fn.setpos('.', pos)
-- end)

-- vim.keymap.set('n', '}', function()
--   vim.opt.hlsearch = false
--   -- vim.cmd '}/.\\+<CR>:noh<CR>'
--   vim.opt.hlsearch = true
-- end)
--

-- vim.keymap.set('n', '}', ':nohl<CR>}/.\\+<CR>:noh<CR>')
-- vim.keymap.set('n', '{', ':nohl<CR>{?.\\+<CR>:noh<CR>')

-- Open PR for current branch in browser
vim.keymap.set('n', '<leader>pr', function()
  local branch = vim.fn.system('git rev-parse --abbrev-ref HEAD'):gsub('\n', '')
  -- local pr_id =
  --   vim.fn.system('az repos pr list --source-branch ' .. vim.fn.shellescape(branch) .. ' --query "[0].pullRequestId" -o tsv 2>/dev/null'):gsub('\n', '')
  -- if pr_id ~= '' then
  --   vim.fn.system('az repos pr show --id ' .. vim.fn.shellescape(pr_id) .. ' --open >/dev/null 2>&1')
  -- else
  --   vim.notify('No PR found for branch: ' .. branch, vim.log.levels.WARN)
  -- end
end, { desc = 'Open PR in browser' })

-- vim.keymap.set("n", "<leader>|", ":vert res<CR>")
