vim.g.loaded_perl_provider = 0    -- disable perl checkhealth
vim.g.loaded_ruby_provider = 0    -- disable ruby checkhealth

-- Keymaps
vim.g.mapleader = ' '

vim.keymap.set('n', '<leader>fd', vim.cmd.Ex)

-- Options
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "160"

vim.opt.splitright = true

vim.opt.statusline = '%{%v:lua.require\'statusline\'.render()%}'
