define_tile_code("catmummy")

local LevelSequence = require('LevelSequence.level_sequence')
local BORDER_THEME = LevelSequence.BORDER_THEME

local level3 = {
    identifier = "level3",
    title = "Level 3",
    theme = THEME.VOLCANA,
    border_theme = THEME.COSMIC_OCEAN,
    loops = true,
    background_theme = THEME.ICE_CAVES,
    music_theme = THEME.DUAT,
    file_name = "level3.lvl",
    width = 4,
    height = 4,
}

local level_state = {
    loaded = false,
    callbacks = {},
}

level3.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
end

level3.unload_level = function()
    if not level_state.loaded then return end

    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return level3
