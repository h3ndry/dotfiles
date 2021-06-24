local svelete_bin = '/home/hendry/.local/share/nvim/lspinstall/svelte/node_modules/svelte-language-server/bin/server.js'
require'lspconfig'.svelte.setup{
   cmd = {"node", svelete_bin, "--stdio" }
}

