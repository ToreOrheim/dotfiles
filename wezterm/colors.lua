local colors_module = {
    color_scheme = "Tokyo Night",
    opacity = { bg = 0.9, text = 1 },
    fancy_tab = false
}

function colors_module.apply_to_config(config)
    config.color_scheme = colors_module.color_scheme
    config.window_background_opacity = colors_module.opacity.bg
    config.text_background_opacity = colors_module.opacity.text
    config.use_fancy_tab_bar = colors_module.fancy_tab
end

return colors_module
