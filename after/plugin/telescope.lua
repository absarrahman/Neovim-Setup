local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
-- You need to install ripgrep
-- sudo apt-get install ripgrep
vim.keymap.set('n', '<leader>pg', function()
	builtin.grep_string({
		search = vim.fn.input("Find In Project: ")
	})
end)
