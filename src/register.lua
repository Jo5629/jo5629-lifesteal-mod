core.register_on_prejoinplayer(function(name)
    if lifesteal_mod.listContains(name) then
        return lifesteal_mod.DEATH_MESSAGE_DEFAULT
    end
end)

core.register_on_joinplayer(function(player, last_login)
    lifesteal_mod.update(player)
    lifesteal_mod.tryToKick(player)
end)

core.register_on_dieplayer(function(player)
    local newHP = lifesteal_mod.getHearts(player:get_player_name()) - 2
    if newHP <= 0 then
        lifesteal_mod.kickAndBan(player:get_player_name())
    end
    lifesteal_mod.update(player, nil, newHP)
end)

local HEART_ITEMNAME = "lifesteal_mod:heart"
core.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
    if player == hitter or not hitter:is_player() then return end
	if player:get_hp() > 0 and player:get_hp() - damage <= 0 then
        local newHPMax = hitter:get_properties().hp_max + 2
		if newHPMax > lifesteal_mod.HP_MAX then
            local inv = hitter:get_inventory()
            if inv:room_for_item("main", {name = HEART_ITEMNAME}) then
                inv:add_item("main", HEART_ITEMNAME)
            else
                core.add_item(hitter:get_pos(), HEART_ITEMNAME)
            end
            return
        end
        lifesteal_mod.update(hitter, nil, newHPMax)
    end
end)