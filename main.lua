meta = {
    name = 'ExampleKaizo',
    version = '2.4',
    description = 'Example usage of LevelSequence',
    author = 'JayTheBusinessGoose',
}

local level_sequence = require("LevelSequence/level_sequence")
local SIGN_TYPE = level_sequence.SIGN_TYPE

define_tile_code("catmummy")
define_tile_code("shortcut")

level_sequence.load_levels()
level_sequence.set_show_toast(true)

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

local level2 = find_level_with_id("level2")
if level2 then
    function level2.on_load_level()
        level2.attach_callback(set_pre_tile_code_callback(function(x, y, layer)
            spawn_entity(ENT_TYPE.MONS_CATMUMMY, x, y, layer, 0, 0)
            return true
        end, "catmummy"))
    end
end

level_sequence.set_on_win(function(attempts, total_time)
    print("You won!")
	warp(1, 1, THEME.BASE_CAMP)
end)

local active = false
local internal_callbacks = {}
local function add_callback(callback)
    internal_callbacks[#internal_callbacks+1] = callback
end
local function activate()
    if active then return end
    active = true

    level_sequence.activate()

    add_callback(set_pre_tile_code_callback(function(x, y, layer)
        local shortcut_level = find_level_with_id("level6")
        level_sequence.spawn_shortcut(x, y, layer, shortcut_level, SIGN_TYPE.RIGHT)
        return true
    end, "shortcut"))
end
local function deactivate()
    if not active then return end
    active = false
    level_sequence.deactivate()
    for _, callback in pairs(internal_callbacks) do
        clear_callback(callback)
    end
end

set_callback(activate, ON.LOAD)

set_callback(activate, ON.SCRIPT_ENABLE)

set_callback(deactivate, ON.SCRIPT_DISABLE)