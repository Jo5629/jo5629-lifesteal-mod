local MP = minetest.get_modpath(minetest.get_current_modname())

lifesteal_mod = {}

dofile(MP .. "/api.lua")
dofile(MP .. "/items.lua")
dofile(MP .. "/crafts.lua")
dofile(MP .. "/withdraw.lua")

minetest.register_on_prejoinplayer(function(name, ip)
	if lifesteal_mod.is_player_dead(name) then
		return "You died on a lifesteal server."
	end
end)

minetest.register_on_joinplayer(function(player)
	local meta = player:get_meta()
	local health = meta:get_int("health")
	local name = player:get_player_name()

	if lifesteal_mod.is_player_dead(name) then
		minetest.kick_player(name, "You died on a lifesteal server.") --> Fail-safe.
		meta:set_int("health", 6)
		return
	else
		if health == nil or health == 0 then
			meta:set_int("health", 20)
		end
	end

	player:set_hp(player:get_hp())
	minetest.after(0.01, function() lifesteal_mod.change_hp_max(player, player:get_hp(), health, true) end)
end)

minetest.register_on_newplayer(function(player) --> When new player joins.
	local meta = player:get_meta()

	local health = meta:get_int("health")
	if not health == nil then
		meta:set_int("health", 20) --> Set the new player's max to a 20hp (10 hearts).
	end

	lifesteal_mod.change_hp_max(player, health, player:get_properties().hp_max, true)
end)

minetest.register_on_dieplayer(function(player)
	local meta = player:get_meta()
	local health = meta:get_int("health")
	local health = health - 2
	meta:set_int("health", health)
	if meta:get_int("health") == 0 then
		local name = player:get_player_name()
		minetest.kick_player(name, "You died on a lifesteal server.")

		lifesteal_mod.add_player(name)
		meta:set_int("health", 6)
	end

end)

minetest.register_on_respawnplayer(function(player)
	local meta = player:get_meta()
	local health = meta:get_int("health")
	local name = player:get_player_name()

	if lifesteal_mod.is_player_dead(name) then
		minetest.kick_player(name, "You died on a lifesteal server.")
		return
	else
		player:set_hp(player:get_hp() - 2)
	end

	player:set_hp(health)
	lifesteal_mod.change_hp_max(player, player:get_hp(), health, true)
end)

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
	if player:get_hp() > 0 and player:get_hp() - damage <= 0 and 
	minetest.is_player(hitter) and hitter:get_player_name() ~= player:get_player_name() then
		local heart_num = hitter:get_properties().hp_max / 2
		if not (heart_num >= 20) then
			local health = hitter:get_meta():get_int("health") + 2
			hitter:get_meta():set_int("health", health)

			lifesteal_mod.change_hp_max(hitter, health, health, false)
		else
			local inv = hitter:get_inventory()
			if inv:room_for_item("main", {name = "lifesteal_mod:heart"}) then
				inv:add_item("main", "lifesteal_mod:heart")
			else
				minetest.add_item(hitter:get_pos(), {name = "lifesteal_mod:heart"})
			end
		end
		
	end
end)