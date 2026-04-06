-- on_attach via autocmd (replaces lsp-zero's on_attach)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(event)
        local opts = { buffer = event.buf, remap = false }

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
        vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "=", function() vim.lsp.buf.format() end, opts)
    end
})

-- Signs
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E",
            [vim.diagnostic.severity.WARN]  = "W",
            [vim.diagnostic.severity.HINT]  = "H",
            [vim.diagnostic.severity.INFO]  = "I",
        }
    }
})

vim.lsp.config('*', {
    capabilities = vim.lsp.protocol.make_client_capabilities(),
})

-- lua_ls
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            runtime = { version = 'LuaJIT' },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = { enable = false },
            diagnostics = { globals = { 'vim' } },
        }
    }
})

-- dartls
vim.lsp.config('dartls', {
    on_attach = function(client, bufnr)
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end,
    settings = {
        dart = {
            analysisExcludedFolders = {
                vim.fn.expand("$HOME/.pub-cache"),
                vim.fn.expand("/opt/homebrew/"),
            }
        }
    }
})

-- cssmodules_ls
vim.lsp.config('cssmodules_ls', {
    on_attach = function(client, bufnr)
        client.server_capabilities.definitionProvider = false
    end,
})

-- Mason
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        'pyright',
        'lua_ls',
        'clangd',
        'html',
        'cssls',
        'tailwindcss',
        'cssmodules_ls',
        'gopls',
        'jsonls',
        'ts_ls',
    },
    automatic_enable = true,  -- automatically calls vim.lsp.enable() for installed servers
})

-- Tab stops
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "json", "dart", "python", "cpp", "javascript", "javascriptreact", "typescript", "typescriptreact" },
    callback = function()
        vim.opt_local.tabstop = 2
        vim.opt_local.shiftwidth = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end
})
