vim.pack.add({
	{ 
		src = 'https://github.com/mason-org/mason.nvim',
		version = vim.version.range('2.2.1'),
	},
	{ 
		src = 'https://github.com/mfussenegger/nvim-dap',
		version = vim.version.range('0.10.0'),
	},
    {
        src = 'https://github.com/jay-babu/mason-nvim-dap.nvim',
        version = vim.version.range('2.5.2'),
    }
})

require('mason')
require('mason-nvim-dap').setup({
	-- NOTE: this is left here for future porting in case needed
	-- Whether adapters that are set up (via dap) should be automatically installed if they're not already installed.
	-- This setting has no relation with the `ensure_installed` setting.
	-- Can either be:
	--   - false: Daps are not automatically installed.
	--   - true: All adapters set up via dap are automatically installed.
	--   - { exclude: string[] }: All adapters set up via mason-nvim-dap, except the ones provided in the list, are automatically installed.
	--       Example: automatic_installation = { exclude = { "python", "delve" } }
    automatic_installation = false,

    handlers = {
        function(config)
            require('mason-nvim-dap').default_setup(config)
        end,
    },
})
