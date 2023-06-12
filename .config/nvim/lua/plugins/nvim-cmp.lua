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
        local nvim_lsp = require("lspconfig")
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
            "pyright",
            "tsserver",
            "html",
            "cssls",
            "emmet_ls",
            "lua_ls",
            "texlab",
            "svelte",
            "bashls",
            "volar",
            "ltex",
            "omnisharp",
            "tailwindcss"
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
                -- {name = "gh_issues"},
                { name = "luasnip" },
                { name = "nvim_lsp" },
                { name = "nvim_lua" },
                { name = "cmp-cmdline" },
                { name = 'zsh' },
                -- { name = "cmp-treesitter" },
                { name = "calc" },
                -- { name = "cmp-spell" },
                { name = "path" },
                -- { name = "rg" },
                -- { name = "buffer" }
            },
            experimental = {},

            formatting = {
                format = lspkind.cmp_format {
                    -- with_text = true,
                    menu = {
                        luasnip = "[SNIP]",
                        nvim_lsp = "[LSP]",
                        nvim_lua = "[API]",
                        calc = "[CALC]",
                        cmdline = "[CMD]",
                        -- spell = "[SPELL]",
                        path = "[PATH]",
                        -- rg = "[RG]",
                        -- buffer = "[BUFF]"
                    }
                }
            }

        }

        cmp.setup.cmdline('/', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        cmp.setup.cmdline('=', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline('?', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = 'buffer' }
            }
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
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
            elseif lsp == "omnisharp" then
                local pid = vim.fn.getpid()
                local omnisharp_bin = "/usr/bin/omnisharp"

                require 'lspconfig'.omnisharp.setup({
                    handlers = {
                        ["textDocument/definition"] = require('omnisharp_extended').handler,
                    },
                    cmd = { omnisharp_bin, '--languageserver', '--hostPID', tostring(pid) },
                    capabilities = capabilities,
                })
            else
                nvim_lsp[lsp].setup { capabilities = capabilities }
            end
        end
        require("luasnip.loaders.from_vscode").lazy_load({
            paths = { "./snippets/" },
        })
    end
    ,
}
