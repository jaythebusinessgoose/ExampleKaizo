define_tile_code("catmummy")

local LevelSequence = require('LevelSequence.level_sequence')
local BORDER_THEME = LevelSequence.BORDER_THEME

local level2 = {
    identifier = "level4",
    title = "Level 4",
    theme = THEME.TIDE_POOL,
    border_type = BORDER_THEME.DUAT,
    floor_theme = THEME.VOLCANA,
    file_name = "level4.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

level2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true
end

level2.unload_level = function()
    if not level_state.loaded then return end

    local callbacks_to_clear = level_state.callbacks
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return level2
