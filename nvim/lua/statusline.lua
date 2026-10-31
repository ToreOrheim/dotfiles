return {
    render = function()
        local active_win = vim.fn.win_getid()
        local status_win = tonumber(vim.g.actual_curwin)

        if status_win ~= active_win then
            return 'Statusline for inactive windows'
        end

        return table.concat({
            'Statusline left-aligned stuff',
            '%=',
            'Statusline right-aligned stuff'
        })
    end,
}
