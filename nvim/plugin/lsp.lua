vim.cmd[[set completeopt+=fuzzy,menuone,noselect,popup]]

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local opts = { buffer = args.buf }

        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        if client:supports_method('textDocument/completion') then
            local chars = {};
            for i = 32, 126 do
                table.insert(chars, string.char(i))
            end

            vim.lsp.completion.enable(true, client.id, args.buf, {
                autotrigger = true,
            })
        end

        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end
            })
        end

        -- Keymaps
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<leader>gra', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>grn', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>grr', vim.lsp.buf.references, opts)
        vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

        vim.api.nvim_set_keymap("n", "<leader>e",
            ':lua vim.diagnostic.open_float(nil, {focus=false, scope="cursor"})<CR>',
            { noremap = true })
    end,
})
