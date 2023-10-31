print("Remap running")
vim.g.mapleader = " "
vim.o.timeoutlen = 2000
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
