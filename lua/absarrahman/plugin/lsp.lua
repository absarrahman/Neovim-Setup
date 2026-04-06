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
        "mrcjkb/rustaceanvim",
        version = "^9",
        ft = "rust",
        dependencies = {
            "mfussenegger/nvim-dap",
        },
        init = function()
            local mason_registry = require("mason-registry")
            local codelldb = mason_registry.get_package("codelldb")
            -- local extension_path = codelldb:get_install_path() .. "/extension/"
            local extension_path = vim.env.HOME .. '/.vscode/extensions/vadimcn.vscode-lldb-1.10.0/'
            local codelldb_path = extension_path .. "adapter/codelldb"
            local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

            vim.g.rustaceanvim = {
                dap = {
                    adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
                },
                server = {
                    on_attach = function(client, bufnr)
                        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

                        vim.keymap.set("n", "K", "<cmd>lua vim.cmd.RustLsp { 'hover', 'actions' }<cr>",
                            { buffer = bufnr })
                        vim.keymap.set("n", "<Leader>vca", "<cmd>lua vim.cmd.RustLsp('codeAction')<cr>",
                            { buffer = bufnr })
                    end,
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                runBuildScripts = true,
                            },
                            checkOnSave = true,
                            check = {
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
            }
        end,
    },
    {
        'mrcjkb/haskell-tools.nvim',
        version = '^4', -- Use the latest stable version
        ft = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
        init = function()
            -- This is the new way to configure the plugin
            vim.g.haskell_tools = {
                hls = {
                    -- The 'ht' argument is a reference to the haskell-tools module
                    on_attach = function(client, bufnr, ht)
                        local opts = { noremap = true, silent = true, buffer = bufnr }

                        -- Haskell-specific keybindings
                        vim.keymap.set('n', '<space>cl', vim.lsp.codelens.run, opts)
                        vim.keymap.set('n', '<space>hs', ht.hoogle.hoogle_signature, opts)
                        vim.keymap.set('n', '<space>ea', ht.lsp.buf_eval_all, opts)

                        -- Standard LSP keybindings (Optional if you have them elsewhere)
                        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                    end,
                },
            }
        end,
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
