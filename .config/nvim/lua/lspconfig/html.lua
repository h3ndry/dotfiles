--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local server_name = "html"
local bin_name = "/home/hendry/.local/share/nvim/lspinstall/html/vscode-html/html-language-features/server/dist/node/htmlServerMain.js"

require'lspconfig'.html.setup {
    cmd = {"node", bin_name, "--stdio"},
    capabilities = capabilities,
}
