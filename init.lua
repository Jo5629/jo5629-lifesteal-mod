local MP = minetest.get_modpath("lifesteal_mod")

dofile(MP .. "/heart.lua")
dofile(MP .. "/withdraw.lua")
dofile(MP .. "/revive.lua")
dofile(MP .. "/craft.lua")

minetest.register_on_newplayer(function(player) --When new player joins.--
	local meta = player:get_meta()
	local health = meta:get_int("health")
	if meta:get_int("dead") ~= 1 then
		meta:set_int("health", 20)  --Set the new player's max to a 20hp (10 hearts).--
		player:set_properties({
			hp_max = 20,
		})
	end
	player:set_hp(20)
end)

minetest.register_on_joinplayer(function(player)
		local meta = player:get_meta()
		local health = meta:get_int("health")
		if meta:get_int("dead") == 1 then
			minetest.after(0.8, function() --This is for the revive ability.--
				local name = player:get_player_name()
				minetest.kick_player(name, "You died on a lifesteal server.")
			end)
		end
		player:set_properties({
				hp_max = health
		})
		player:set_hp(health)
end)

minetest.register_on_dieplayer(function(player)
		local meta = player:get_meta()
		local health = meta:get_int("health")
		local health = health - 2
		meta:set_int("health", health)
		if meta:get_int("health") == 0 then
			meta:set_int("dead", 1)
			local name = player:get_player_name()
			minetest.kick_player(name, "You died on a lifesteal server.")
		end
end)

minetest.register_on_respawnplayer(function(player)
		local meta = player:get_meta()
		local health = meta:get_int("health")
		if meta:get_int("health") == 0 then
			meta:set_int("dead", 1)
			local name = player:get_player_name()
			minetest.kick_player(name, "You died on a lifesteal server.")
		end
		player:set_hp(meta:get_int("health"))
		player:set_properties({
				hp_max = health
		})
end)

minetest.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
		if player:get_hp() > 0 and player:get_hp() - damage <= 0 and 
		minetest.is_player(hitter) and hitter:get_player_name() ~= player:get_player_name() then
			local health = hitter:get_meta():get_int("health") + 2
			hitter:get_meta():set_int("health", health)
			hitter:set_properties({
				hp_max = health
			})
	end
end)

minetest.register_alias("heart", "lifesteal_mod:heart")