meta = {
    name = 'ExampleKaizo',
    version = '2.4',
    description = 'Example usage of LevelSequence',
    author = 'JayTheBusinessGoose',
}

local level_sequence = require("LevelSequence/level_sequence")
local SIGN_TYPE = level_sequence.SIGN_TYPE

level_sequence.load_levels()

-- Load in one of these levels to test configurations known to crash in CO.
-- local co_crash1 = require('co_crash1')
-- local co_crash2 = require('co_crash2')
-- local co_crash3 = require('co_crash3')
-- level_sequence.add_level(co_crash1)
-- level_sequence.add_level(co_crash2)
-- level_sequence.add_level(co_crash3)

local function find_level_with_id(level_id)
    local levels = level_sequence.levels()
    for _, level in pairs(levels) do
        if level.identifier == level_id then
            return level
        end
    end
    return nil
end

define_tile_code("shortcut")
set_pre_tile_code_callback(function(x, y, layer)
    local shortcut_level = find_level_with_id("level7")
    level_sequence.spawn_shortcut(x, y, layer, shortcut_level, SIGN_TYPE.RIGHT)
    return true
end, "shortcut")

level_sequence.set_on_win(function(attempts, total_time)
    print("You won!")
	warp(1, 1, THEME.BASE_CAMP)
end)

set_callback(function()
    level_sequence.activate()
end, ON.LOAD)

set_callback(function()
    level_sequence.activate()
end, ON.SCRIPT_ENABLE)

set_callback(function()
    level_sequence.deactivate()
end, ON.SCRIPT_DISABLE)