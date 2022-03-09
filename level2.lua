define_tile_code("catmummy")

local LevelSequence = require('LevelSequence.level_sequence')
local BORDER_THEME = LevelSequence.BORDER_THEME

local level2 = {
    identifier = "level2",
    title = "Level 2",
    theme = THEME.TEMPLE,
    border_type = BORDER_THEME.NEO_BABYLON,
    floor_theme = THEME.ICE_CAVES,
    background_theme = THEME.VOLCANA,
    music_theme = THEME.DUAT,
    file_name = "level2.lvl",
}

local level_state = {
    loaded = false,
    callbacks = {},
}

level2.load_level = function()
    if level_state.loaded then return end
    level_state.loaded = true

    level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
        spawn_entity(ENT_TYPE.MONS_CATMUMMY, x, y, layer, 0, 0)
        return true
    end, "catmummy")
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
