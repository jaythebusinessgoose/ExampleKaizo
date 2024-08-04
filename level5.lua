define_tile_code("catmummy")

local LevelSequence = require('LevelSequence.level_sequence')
local BORDER_THEME = LevelSequence.BORDER_THEME

local level5 = {
    identifier = "level5",
    title = "Level 5",
    theme = THEME.JUNGLE,
    border_type = BORDER_THEME.ICE_BABY,
    floor_theme = THEME.TIDE_POOL,
    background_theme = THEME.ICE_CAVES,
    file_name = "level5.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

level5.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
end

level5.unload_level = function()
    if not level_state.loaded then return end

    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return level5
