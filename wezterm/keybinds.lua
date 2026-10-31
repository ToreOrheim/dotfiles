local wezterm = require('wezterm')
local act = wezterm.action

local keybinds_module = {
    mouse_bindings = {
        {
            event = { Up = { streak = 1, button = 'Left' } },
            mods = 'CTRL',
            action = act.OpenLinkAtMouseCursor,
        },
        {
            event = { Down = { streak = 1, button = 'Left' } },
            mods = 'CTRL',
            action = act.Nop,
        },
    }
}

function keybinds_module.apply_to_config(config)
    config.mouse_bindings = keybinds_module.mouse_bindings
end

return keybinds_module
