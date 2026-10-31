local wezterm = require('wezterm')

local font_module = {
    font = {
        primary = wezterm.font('Roboto Mono Nerd Font'),
        fallback = ''
    },

}

function font_module.apply_to_config(config)
    config.font = font_module.font.primary
end

return font_module
