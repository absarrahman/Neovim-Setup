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
        version = '^4',
        ft = "rust",
        dependencies = {
            "neovim/nvim-lspconfig",
            "mfussenegger/nvim-dap",
            {
                "lvimuser/lsp-inlayhints.nvim",
                config = true,

            }
        },
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
                        on_attach = function(client, bufnr)
                            require("lsp-inlayhints").on_attach(client, bufnr)

                            vim.keymap.set("n", "K", "<cmd>lua vim.cmd.RustLsp { 'hover', 'actions' }<cr>",
                                { buffer = bufnr })
                            -- Code action groups
                            vim.keymap.set("n", "<Leader>vca", "<cmd>lua vim.cmd.RustLsp('codeAction')<cr>",
                                { buffer = bufnr })
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
    {
        "mfussenegger/nvim-lint",
        event = {
            "BufReadPre",
            "BufNewFile",
        },
        config = function()
            local lint = require("lint")

            lint.linters_by_ft = {
                javascript = { "eslint_d" },
                typescript = { "eslint_d" },
                javascriptreact = { "eslint_d" },
                typescriptreact = { "eslint_d" },
                svelte = { "eslint_d" },
                python = { "pylint" },
            }

            local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
                group = lint_augroup,
                callback = function()
                    lint.try_lint()
                end,
            })

            vim.keymap.set("n", "<leader>l", function()
                lint.try_lint()
            end, { desc = "Trigger linting for current file" })
        end,
    }
}
