meta = {
    name = 'ExampleKaizo',
    version = '1.0',
    description = 'Example usage of LevelSequence',
    author = 'JayTheBusinessGoose',
}

local level_sequence = require("LevelSequence/level_sequence")
local SIGN_TYPE = level_sequence.SIGN_TYPE

local level1 = require('level1')
local level2 = require('level2')
local level3 = require('level3')
local level4 = require('level4')
local level5 = require('level5')
local level6 = require('level6')

level_sequence.set_levels({level1, level2, level3, level4, level5, level6})

define_tile_code("shortcut")
set_pre_tile_code_callback(function(x, y, layer)
    level_sequence.spawn_shortcut(x, y, layer, level3, SIGN_TYPE.RIGHT)
    return true
end, "shortcut")

level_sequence.set_hide_entrance(false)

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