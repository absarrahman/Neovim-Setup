return {
    { 'williamboman/mason.nvim' },
    { 'williamboman/mason-lspconfig.nvim' },
    -- LSP Support
    {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        lazy = true,
        config = false,
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            { 'hrsh7th/cmp-nvim-lsp' },
        }
    },
    {
        "absarrahman/rustaceanvim",
        branch = "fixFilePathSpace",
        ft = "rust",
        dependencies = "neovim/nvim-lspconfig",
        config = function()
            vim.g.rustaceanvim = function()
                local mason_registry = require("mason-registry")

                -- Need codelldb dap from mason
                local codelldb = mason_registry.get_package("codelldb")
                local extension_path = codelldb:get_install_path() .. "/extension/"
                local codelldb_path = extension_path .. "adapter/codelldb"
                local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
                return {
                    dap = {
                        adapter = require('rustaceanvim.config').get_codelldb_adapter(codelldb_path, liblldb_path),
                    },

                    server = {
                        on_attach = function(_, bufnr)
                            vim.lsp.inlay_hint.enable(bufnr, true)
                            vim.keymap.set("n", "K", "<cmd>RustLSP hover actions<cr>", { buffer = bufnr })
                            -- Code action groups
                            vim.keymap.set("n", "<Leader>vca", "<cmd>RustLsp codeAction<cr>", { buffer = bufnr })
                        end,
                        settings = {
                            -- rust-analyzer language server configuration
                            ["rust-analyzer"] = {
                                cargo = {
                                    allFeatures = true,
                                    loadOutDirsFromCheck = true,
                                    runBuildScripts = true,
                                },
                                -- Add clippy lints for Rust.
                                checkOnSave = {
                                    allFeatures = true,
                                    command = "clippy",
                                    extraArgs = { "--no-deps" },
                                },
                                procMacro = {
                                    enable = true,
                                    ignored = {
                                        ["async-trait"] = { "async_trait" },
                                        ["napi-derive"] = { "napi" },
                                        ["async-recursion"] = { "async_recursion" },
                                    },
                                },
                            },
                        },
                    },
                    tools = {
                        on_initialized = function()
                            vim.cmd([[
                  augroup RustLSP
                    autocmd CursorHold                      *.rs silent! lua vim.lsp.buf.document_highlight()
                    autocmd CursorMoved,InsertEnter         *.rs silent! lua vim.lsp.buf.clear_references()
                    autocmd BufEnter,CursorHold,InsertLeave *.rs silent! lua vim.lsp.codelens.refresh()
                  augroup END
                ]])
                        end,
                    },
                }
            end

            -- local rt = require("rust-tools")
            -- local mason_registry = require("mason-registry")
            --
            -- -- Need codelldb dap from mason
            -- local codelldb = mason_registry.get_package("codelldb")
            -- local extension_path = codelldb:get_install_path() .. "/extension/"
            -- local codelldb_path = extension_path .. "adapter/codelldb"
            -- local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"
            --
            -- rt.setup({
            --     capabilities = require("cmp_nvim_lsp").default_capabilities(),
            --     server = {
            --         on_attach = function(_, bufnr)
            --             -- Hover actions
            --             vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
            --             -- Code action groups
            --             vim.keymap.set("n", "<Leader>vca", rt.code_action_group.code_action_group, { buffer = bufnr })
            --         end,
            --     },
            --     dap = {
            --         adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
            --     },
            -- })
        end
    },
    -- Commenting out
    {
        'numToStr/Comment.nvim',
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        config = true
    },
    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            { 'L3MON4D3/LuaSnip' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { "rafamadriz/friendly-snippets" },
            { 'RobertBrunhage/flutter-riverpod-snippets' },
            { 'Nash0x7E2/awesome-flutter-snippets' },
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lsp_zero = require('lsp-zero')
            require('luasnip.loaders.from_vscode').load()

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                completion = {
                    completeopt = 'menu,menuone,noinsert'
                },
                formatting = lsp_zero.cmp_format(),
                mapping = cmp.mapping.preset.insert {
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete {},
                    ['<CR>'] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = true,
                    },
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                },
                sources = {
                    { name = 'path' },
                    { name = 'nvim_lua' },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                },
            }
        end
    },
}
