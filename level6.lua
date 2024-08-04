define_tile_code("catmummy")

local LevelSequence = require('LevelSequence.level_sequence')
local BORDER_THEME = LevelSequence.BORDER_THEME

local level6 = {
    identifier = "level6",
    title = "Cosmic Ocean Theme Custom Orb Placements",
    theme = THEME.COSMIC_OCEAN,
    floor_theme = THEME.JUNGLE,
    subtheme = THEME.VOLCANA,
    file_name = "level6.lvl",
    width = 3, -- Cosmic Ocean levels must have a width and height configured.
    height = 3, -- And both must be at least 3.
}

local level_state = {
    loaded = false,
    orbs_to_spawn = {},
    jellyfish = {},
    callbacks = {},
}

level6.load_level = function()
    if level_state.loaded then return end

    level_state.orbs_to_spawn = {}
    level_state.jellyfish = {}

    -- Handle the spawning of natural orbs to move them to the configured positions.
    level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(orb, spawn_flags)
        if spawn_flags & SPAWN_TYPE.SCRIPT == 0 then
            if #level_state.orbs_to_spawn > 0 then
                -- Move spawned orbs to the position of orb tilecodes.
                local pos = level_state.orbs_to_spawn[1]
                table.remove(level_state.orbs_to_spawn, 1)
                move_entity(orb.uid, pos.x, pos.y, 0, 0, pos.layer)

                -- Makes the orb have a consistent position, can be set to anything 0-255.
                orb.timer = 0
            else
                -- When there are fewer orb tilecodes than spawned orbs, kill the orb instead.
                orb.flags = set_flag(orb.flags, ENT_FLAG.DEAD)
                orb:destroy()
                return
            end
        end

        orb:set_post_destroy(function()
            local orb_uids = get_entities_by_type(ENT_TYPE.ITEM_FLOATING_ORB)
            local live_orbs = false
            for _, orb_uid in pairs(orb_uids) do
                if not test_flag(get_entity(orb_uid).flags, ENT_FLAG.DEAD) then
                    live_orbs = true
                    break
                end
            end
            if not live_orbs then
                for _, jellyfish in pairs(level_state.jellyfish) do
                    get_entity(jellyfish).move_state = 6
                end
            end
        end)
    end, SPAWN_TYPE.ANY, MASK.ITEM, ENT_TYPE.ITEM_FLOATING_ORB)

    level_state.callbacks[#level_state.callbacks+1] = set_callback(function()
        if not level_state.loaded then return end

        -- Actually spawn any additional orbs now that the natural orbs have spawned.
        for _, orb in pairs(level_state.orbs_to_spawn) do
            local orb_entity = get_entity(spawn_entity(ENT_TYPE.ITEM_FLOATING_ORB, orb.x, orb.y, orb.layer, 0, 0))
            -- Makes the orb have a consistent position, can be set to anything 0-255.
            orb_entity.timer = 0
        end
    end, ON.LEVEL)

    level_state.callbacks[#level_state.callbacks+1] = set_pre_tile_code_callback(function(x, y, layer)
        -- Instead of spawning the orbs during level generation, store the locations and spawn them later.
        level_state.orbs_to_spawn[#level_state.orbs_to_spawn+1] = {x=x, y=y, layer=layer}
        return true
    end, "cosmic_orb")

    level_state.callbacks[#level_state.callbacks+1] = set_post_entity_spawn(function(jelly, spawn_flags)
        jelly.orb_uid = jelly.uid
        level_state.jellyfish[#level_state.jellyfish+1] = jelly.uid
    end, SPAWN_TYPE.ANY, MASK.MONSTER, ENT_TYPE.MONS_MEGAJELLYFISH)

    level_state.loaded = true
end

level6.unload_level = function()
    if not level_state.loaded then return end

    local callbacks_to_clear = level_state.callbacks
    level_state.orbs_to_spawn = {}
    level_state.jellyfish = {}
    level_state.loaded = false
    level_state.callbacks = {}
    for _, callback in pairs(callbacks_to_clear) do
        clear_callback(callback)
    end
end

return level6
