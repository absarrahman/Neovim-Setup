local dap =  require("dap")
local dapui = require("dapui")
local dapgo = require('dap-go')

vim.keymap.set("n", "<F5>", ":lua require'dap'.continue()<CR>")
vim.keymap.set("n", "<F10>", ":lua require'dap'.step_over()<CR>")
vim.keymap.set("n", "<F11>", ":lua require'dap'.step_into()<CR>")
vim.keymap.set("n", "<F12>", ":lua require'dap'.step_out()<CR>")
vim.keymap.set("n", "<leader>b", ":lua require'dap'.toggle_breakpoint()<CR>")
vim.keymap.set("n", "<leader>B", ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
vim.keymap.set("n", "<leader>lp", ":lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
vim.keymap.set("n", "<leader>dr", ":lua require'dap'.repl.open()<CR>")
vim.keymap.set("n", "<leader>op", ":lua require'dapui'.open()<CR>")
vim.keymap.set("n", "<leader>cp", ":lua require'dapui'.close()<CR>")

dap.adapters.dart = {
    type = "executable",
    -- As of this writing, this functionality is open for review in https://github.com/flutter/flutter/pull/91802
    command = "dart",
    args = {"debug_adapter"}
}

dap.adapters.flutter = {
    type = 'executable',
    command = 'flutter',
    args = {'debug_adapter'}
}

dap.configurations.dart = {
    {
        type = "dart",
        request = "launch",
        name = "Launch Dart Program",
        -- The nvim-dap plugin populates this variable with the filename of the current buffer
        program = "${workspaceFolder}/lib/main.dart",
        -- The nvim-dap plugin populates this variable with the editor's current working directory
        cwd = "${workspaceFolder}",
        -- This gets forwarded to the Flutter CLI tool, substitute `iPhone 15 Pro` for whatever device you wish to launch
        toolArgs = {"-d", "iPhone 15 Pro"}
    },
    {
        type = "flutter",
        request = "launch",
        name = "Launch Flutter Program",
        -- The nvim-dap plugin populates this variable with the filename of the current buffer
        program = "${workspaceFolder}/lib/main.dart",
        -- The nvim-dap plugin populates this variable with the editor's current working directory
        cwd = "${workspaceFolder}",
        -- This gets forwarded to the Flutter CLI tool, substitute `iPhone 15 Pro` for whatever device you wish to launch
        toolArgs = {"-d", "iPhone 15 Pro"}
    }

}

dapui.setup()
-- Don't forget to add in zsh 
-- export GOPATH="$HOME/go"
-- export PATH="$GOPATH/bin:$PATH"
dapgo.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
