return {
    "barreiroleo/ltex_extra.nvim",
    ft = { "markdown", "tex" },
    dependencies = { "neovim/nvim-lspconfig" },
    -- yes, you can use the opts field, just I'm showing the setup explicitly
    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        require("ltex_extra").setup {
            server_opts = {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    -- your on_attach process
                end,
                settings = {
                }
            },
        }
    end
}
