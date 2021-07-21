require'lspconfig'.clangd.setup{
       cmd = { "clangd", "--background-index" }
   }

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local server_name = "html"
local bin_name = "/home/hendry/.local/share/nvim/lspinstall/html/vscode-html/html-language-features/server/dist/node/htmlServerMain.js"

require'lspconfig'.html.setup {
    cmd = {"node", bin_name, "--stdio"},
    capabilities = capabilities,
}
local pid = vim.fn.getpid()
-- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
local omnisharp_bin = "/home/hendry/.local/share/nvim/lspinstall/csharp/omnisharp/run"
-- on Windows
-- local omnisharp_bin = "/path/to/omnisharp/OmniSharp.exe"
require'lspconfig'.omnisharp.setup{
    cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
}

require'lspconfig'.rust_analyzer.setup{
    cmd = { "/home/hendry/.local/share/nvim/lspinstall/rust/rust-analyzer" }
}
local system_name
if vim.fn.has("mac") == 1 then
  system_name = "macOS"
elseif vim.fn.has("unix") == 1 then
  system_name = "Linux"
elseif vim.fn.has('win32') == 1 then
  system_name = "Windows"
else
  print("Unsupported system for sumneko")
end

-- set the path to the sumneko installation; if you previously installed via the now deprecated :LspInstall, use
local sumneko_root_path = vim.fn.stdpath('cache')..'/lspconfig/sumneko_lua/lua-language-server'
local sumneko_binary = '/home/hendry/.local/share/nvim/lspinstall/lua/sumneko-lua-language-server'

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
  cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

local svelete_bin = '/home/hendry/.local/share/nvim/lspinstall/svelte/node_modules/svelte-language-server/bin/server.js'
require'lspconfig'.svelte.setup{
   cmd = {"node", svelete_bin, "--stdio" }
}

require'lspconfig'.texlab.setup{
        cmd = { "/home/hendry/.local/share/nvim/lspinstall/latex/texlab" }
}
require'lspconfig'.tsserver.setup{}

require'lspconfig'.phpactor.setup{
	cmd = { "/home/hendry/.local/share/nvim/lspinstall/phpactor/bin/phpactor", "language-server" }
}
