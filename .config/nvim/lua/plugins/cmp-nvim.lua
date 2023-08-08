return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "L3MON4D3/LuaSnip",
        "onsails/lspkind-nvim",
        'tamago324/cmp-zsh',
        "hrsh7th/cmp-nvim-lsp",
        "ray-x/cmp-treesitter",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-calc",
        "lukas-reineke/cmp-rg",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "f3fora/cmp-spell",
        "saadparwaiz1/cmp_luasnip",
    },
    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities.textDocument.completion.completionItem.snippetSupport = true
        local lspconfig = require("lspconfig")
        local has_words_before = function()
            local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            return col ~= 0 and
                vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local cmp = require "cmp"
        local lspkind = require("lspkind")
        local luasnip = require("luasnip")

        local buildtime_path = vim.split(package.path, ";")
        table.insert(buildtime_path, "lua/?.lua")
        table.insert(buildtime_path, "lua/?/init.lua")
        local servers = {
            "clangd",
            "rust_analyzer",
            "lua_ls",
            "texlab",
            "svelte",
            "bashls",
            -- "ltex",
        }

        cmp.setup {
            window = {
                completion = {
                    border = "rounded",
                    scrollbar = "-",
                },
                documentation = {
                    border = "rounded",
                    scrollbar = "-",
                },
            },

            snippet = {
                expand = function(args)
                    require "luasnip".lsp_expand(args.body)
                end
            },
            mapping = {
                ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<C-e>"] = cmp.mapping.close(),
                ["<c-y>"] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true
                },
                ["<C-n>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end,
                    { "i", "s" }
                ),
                ["<C-p>"] = cmp.mapping(
                    function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end,
                    { "i", "s" }
                )
            },
            sources = {
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "nvim_lua" },
                { name = "cmp-cmdline" },
                { name = 'zsh' },
                { name = "calc" },
                { name = "path" },
            },
            experimental = {},

            formatting = {
                format = lspkind.cmp_format {
                    menu = {
                        luasnip = "[SNIP]",
                        nvim_lsp = "[LSP]",
                        nvim_lua = "[API]",
                        calc = "[CALC]",
                        cmdline = "[CMD]",
                        path = "[PATH]",
                    }
                }
            }

        }

        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' },
                { name = 'cmdline' }
            })
        })

        for _, lsp in ipairs(servers) do
            if lsp == "sumneko_lua" then
                require "lspconfig".sumneko_lua.setup {
                    settings = {
                        Lua = {
                            buildtime = { version = "LuaJIT", path = runtime_path },
                            diagnostics = { globals = { "vim" } },
                            workspace = { library = vim.api.nvim_get_buildtime_file("", true) },
                            telemetry = { enable = false }
                        }
                    }
                }
            else
                lspconfig[lsp].setup { capabilities = capabilities }
            end
        end

        lspconfig.emmet_language_server.setup {}
        lspconfig.tailwindcss.setup {}
        lspconfig.emmet_ls.setup {}

        lspconfig.pyright.setup {}
        lspconfig.html.setup {}
        lspconfig.cssls.setup {}
        lspconfig.jsonls.setup {
            settings = {
                json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = { enable = true },
                },
            },
        }


        require("luasnip.loaders.from_vscode").lazy_load({
            paths = { "./snippets/" },
        })

        vim.keymap.set('n', '<space>d', vim.diagnostic.open_float)
        vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
        vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
        vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)
        vim.keymap.set("n", "<leader>xx", vim.diagnostic.setqflist)
        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
                local opts = { buffer = ev.buf }
                vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
                vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                vim.keymap.set('n', 'gI', vim.lsp.buf.implementation, opts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                vim.keymap.set('n', '<space>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                end, opts)
                vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                vim.keymap.set('n', '<space>gr', vim.lsp.buf.references, opts)
                vim.keymap.set('n', '<space>F', function()
                    vim.lsp.buf.format { async = true }
                end, opts)
            end,
        })
    end
    ,
}
