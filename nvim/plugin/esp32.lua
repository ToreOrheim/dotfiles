vim.pack.add({
	{
		src = 'https://github.com/folke/snacks.nvim',
	},
	{
		src = 'https://github.com/neovim/nvim-lspconfig',
	},
	{
		src = 'https://github.com/Aietes/esp32.nvim',
	},
})

require('snacks').setup({})
require('esp32').setup({
	build_dir = 'build.clang',
})

vim.lsp.config('clangd', require('esp32').lsp_config())
vim.lsp.enable('clangd', { filetypes = { 'c', 'cpp' } })

vim.keymap.set('n', '<leader>Rb', require('esp32').build, { desc = 'ESP32: Build' })
vim.keymap.set('n', '<leader>RM', function() require('esp32').pick('monitor') end, { desc = 'ESP32: Pick & Monitor' })
vim.keymap.set('n', '<leader>Rm', function() require('esp32').command('monitor') end, { desc = 'ESP32: Monitor (remembered port)' })
vim.keymap.set('n', '<leader>RF', function() require('esp32').pick('flash') end, { desc = 'ESP32: Pick & Flash' })
vim.keymap.set('n', '<leader>Rf', function() require('esp32').command('flash') end, { desc = 'ESP32: Flash (remembered port)' })
vim.keymap.set('n', '<leader>Rc', function() require('esp32').command('menuconfig') end, { desc = 'ESP32: Menuconfig' })
vim.keymap.set('n', '<leader>RC', function() require('esp32').command('clean') end, { desc = 'ESP32: Clean' })
vim.keymap.set('n', '<leader>Rr', function() require('esp32').reconfigure() end, { desc = 'ESP32: Reconfigure' })
vim.keymap.set('n', '<leader>Ri', function() require('esp32').info() end, { desc = 'ESP32: Info' })
vim.keymap.set('n', '<leader>Rt', function() require('esp32').set_target() end, { desc = 'ESP32: Set Target' })
