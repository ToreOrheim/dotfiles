vim.pack.add({
	{
		src = 'https://github.com/nvim-lua/plenary.nvim',
	},
	{
		src = 'https://github.com/nvim-telescope/telescope.nvim',
		version = vim.version.range('0.2.1'),
	},
})

require('telescope')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
