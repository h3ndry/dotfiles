-- set errorformat=%f(%l\\,%c):%t%*[^\ ]%m

-- vim.opt_local.errorformat = "%f(%l\\,%c):%t%*[^"

vim.opt_local.errorformat = '%f(%l\\,%c):%t%*[\\^\\ ]%m'

vim.keymap.set('v', '<leader>f', ':!csharpier format<CR>', {
  buffer = true,
  desc = 'Format selection with csharpier',
})
