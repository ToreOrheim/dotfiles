vim.pack.add({
	{ 
		src = 'https://github.com/mfussenegger/nvim-dap',
		version = vim.version.range('0.10.0'),
	},
	{ 
		src = 'https://github.com/nvim-neotest/nvim-nio',
		version = vim.version.range('1.10.1'),
	},
	{ 
		src = 'https://github.com/rcarriga/nvim-dap-ui',
		version = vim.version.range('4.0.0'),
	},
})

local dapui = require('dapui')

dapui.setup {
    layouts = {
        {
            elements = {
                { id = 'scopes', size = 0.25 },
                { id = 'breakpoints', size = 0.25 },
                { id = 'stacks', size = 0.25 },
                { id = 'watches', size = 0.25 },
            },
            size = 40,
            position = 'left',
        },
        {
            elements = {
                'repl',
                'console',
            },
            size = 10,
            position = 'bottom',
        },
        {
            name = 'monitor',
            elements = {
                { id = 'easy-dotnet_cpu', size = 0.5 },
                { id = 'easy-dotnet_mem', size = 0.5 },
            },
            size = 35,
            position = 'right',
        },
    },
}

local dap = require('dap')

dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open({})
end
dap.listeners.before.event_terminated['dapui_config'] = function()
    dapui.close({})
end
dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close({})
end

vim.keymap.set('n', '<leader>du', function()
    if dap.session() then
        dapui.toggle()
    end
end, { desc = 'Toggle DAP UI' })

