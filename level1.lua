local level1 = {
    identifier = "level1",
    title = "Level 1",
    theme = THEME.JUNGLE,
    width = 3,
    height = 1,
    file_name = "level1.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

level1.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
end

level1.unload_level = function()
    if not level_state.loaded then return end
    
    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return level1