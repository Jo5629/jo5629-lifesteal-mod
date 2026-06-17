core.register_on_prejoinplayer(function(name)
    if lifesteal_mod.isBanned(name) then
        return lifesteal_mod.DEATH_MESSAGE_DEFAULT
    end
end)

core.register_on_joinplayer(function(player, last_login)
    --> Backwards compatibility.
    local meta = player:get_meta()
    if meta:contains("health") then
        lifesteal_mod.update(player, meta:get_int("health"))
        meta:set_string("health", "")
    else
        lifesteal_mod.update(player)
    end
    lifesteal_mod.tryToKick(player)
end)

core.register_on_dieplayer(function(player)
    local newHP = lifesteal_mod.getHearts(player:get_player_name()) - 2
    lifesteal_mod.update(player, newHP)
    if newHP <= 0 then
        lifesteal_mod.kickAndBan(player:get_player_name())
    end
end)

local HEART_ITEMNAME = "lifesteal_mod:heart"
core.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
    if player == hitter or not hitter:is_player() then return end
	if player:get_hp() > 0 and player:get_hp() - damage <= 0 then
        local newHP = lifesteal_mod.getHearts(hitter:get_player_name()) + 2
        local newHealthBoostHP = hitter:get_properties().hp_max + 2
		if newHP > lifesteal_mod.HP_MAX then
            local inv = hitter:get_inventory()
            if inv:room_for_item("main", {name = HEART_ITEMNAME}) then
                inv:add_item("main", HEART_ITEMNAME)
            else
                core.add_item(hitter:get_pos(), HEART_ITEMNAME)
            end
            return
        end
        lifesteal_mod.update(hitter, newHP)
        if lifesteal_mod.hasHealthBoost(hitter) then
            hitter:set_properties({hp_max = newHealthBoostHP})
            vl_hudbars.update_health(hitter)
        end
    end
end)

if lifesteal_mod.CURRENT_GAME == "mineclone2" then
    local effect = mcl_potions.registered_effects["health_boost"]
    local oldOnStart = effect.on_start or function() end
    local oldOnLoad = effect.on_load or function() end
    local oldAfterEnd = effect.after_end or function() end

    local function onStart(object, factor)
        local newHP = lifesteal_mod.getHearts(object:get_player_name()) + factor
        object:set_properties({hp_max = newHP})
        vl_hudbars.update_health(object)
    end

    effect.on_start = function(object, factor)
        oldOnStart(object, factor)
        onStart(object, factor)
    end
    effect.on_load = function(player, factor)
        oldOnLoad(player, factor)
        core.after(0, function() onStart(player, factor) end)
    end
    effect.after_end = function(object)
        oldAfterEnd(object)
        lifesteal_mod.update(object)
    end

    mcl_potions.registered_effects["health_boost"] = effect
end