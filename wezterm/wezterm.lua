local wezterm = require('wezterm')
local project = require 'project'

local config = wezterm.config_builder()

-- Apply keybinds
local keybinds = require('keybinds')
keybinds.apply_to_config(config)

-- Apply color config
local colors = require('colors')
colors.apply_to_config(config)

-- Apply font config
local font = require('font')
font.apply_to_config(config)

wezterm.on('gui-startup', function()
    project.startup("WZ_PROJECT", "projects", wezterm)
end)

return config
