vim.keymap.set('v', '<leader>f', '!biome format --stdin-file-path %<CR>', {
  buffer = true,
  desc = 'Format selection with biome',
})
