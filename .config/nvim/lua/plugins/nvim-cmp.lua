return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "L3MON4D3/LuaSnip" },
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
                "omnisharp"
            }

            cmp.setup {
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
                    { name = "cmp-treesitter" },
                    { name = "calc" },
                    { name = "cmp-spell" },
                    { name = "path" },
                    { name = "rg" },
                    { name = "buffer" }
                },
                experimental = { ghost_text = true },
                formatting = {
                    format = lspkind.cmp_format {
                        with_text = true,
                        menu = {
                            luasnip = "[SNIP]",
                            nvim_lsp = "[LSP]",
                            nvim_lua = "[API]",
                            calc = "[CALC]",
                            cmdline = "[CMD]",
                            spell = "[SPELL]",
                            path = "[PATH]",
                            rg = "[RG]",
                            buffer = "[BUFF]"
                        }
                    }
                }
            }
            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline('/', {
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
                    { name = 'path' }
                }, {
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
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                        },
                        -- You can choose the select mode (default is charwise 'v')
                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V',  -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        -- If you set this to `true` (default is `false`) then any textobject is
                        -- extended to include preceding xor succeeding whitespace. Succeeding
                        -- whitespace has priority in order to act similarly to eg the built-in
                        -- `ap`.
                        include_surrounding_whitespace = true,
                    },
                },
            })
        end
    }

}
