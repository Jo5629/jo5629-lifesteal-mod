local MP = minetest.get_modpath(minetest.get_current_modname())

lifesteal_mod = {}

lifesteal_mod.max_hearts = tonumber(minetest.settings:get("lifesteal_mod.max_hearts")) or 20

if lifesteal_mod.max_hearts <= 10 or lifesteal_mod.max_hearts == nil then
	lifesteal_mod.max_hearts = 20
end

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

	if not lifesteal_mod.is_player_dead(name) then
		player:set_properties({hp_max = 20})
		if health == 0 or health == nil then
			meta:set_int("health", 20)
			player:set_hp(20)
			lifesteal_mod.change_hp_max(player, player:get_hp(), health, true)
		end
	end

	if lifesteal_mod.is_player_dead(name) then
		minetest.kick_player(name, "You died on a lifesteal server.") --> Fail-safe.
		meta:set_int("health", 6)
		return
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
	local name = player:get_player_name()

	local meta = player:get_meta()
	local health = meta:get_int("health")
	local health = health - 2

	if not lifesteal_mod.is_player_dead(name) then
		if health == 0 or health == nil then
			meta:set_int("health", 20)
		end
	end

	meta:set_int("health", health)
	if meta:get_int("health") == 0 then
		minetest.kick_player(name, "You died on a lifesteal server.")

		lifesteal_mod.add_player(name)
		meta:set_int("health", 6)
	end
end)

minetest.register_on_respawnplayer(function(player)
	local meta = player:get_meta()
	local health = meta:get_int("health")
	local name = player:get_player_name()

	if not lifesteal_mod.is_player_dead(name) then
		if health == 0 or health == nil then
			meta:set_int("health", 20)
		end
	end

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
		if not (heart_num >= lifesteal_mod.max_hearts) then
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

minetest.register_on_leaveplayer(function(player)
	local name = player:get_player_name()
	local meta = player:get_meta()
	local health = meta:get_int("health")

	if not lifesteal_mod.is_player_dead(name) then
		if health == 0 or health == nil then
			meta:set_int("health", 20)
		end
	end
end)

--> Code taken from https://github.com/MT-CTF/capturetheflag/blob/master/mods/other/hpbar_hud/init.lua
if not minetest.get_modpath("hudbars") then
	local ids = {}

	local texture_res = 24 -- heart texture resolution

	local function calculate_offset(hearts)
		return {x = (-hearts * texture_res) - 25, y = -(48 + texture_res + 16)}
	end

	minetest.register_on_joinplayer(function(player)
		player:hud_set_flags({healthbar = false}) -- Hide the builtin HP bar
		-- Add own HP bar with the same visuals as the builtin one

		ids[player:get_player_name()] = player:hud_add({
			hud_elem_type = "statbar",
			position = {x = 0.5, y = 1},
			text = "heart.png",
			text2 = "heart_gone.png",
			number = player:get_hp(),
			item = minetest.PLAYER_MAX_HP_DEFAULT,
			direction = 0,
			size = {x = texture_res, y = texture_res},
			offset = calculate_offset(10),
		})

		player:hud_change(ids[player:get_player_name()], "item", player:get_properties().hp_max)
	end)

	minetest.register_on_leaveplayer(function(player)
		ids[player:get_player_name()] = nil
	end)

	-- HACK `register_playerevent` is not documented, but used to implement statbars by MT internally
	minetest.register_playerevent(function(player, eventname)
		local id = ids[player:get_player_name()]
		if not id then return end

		if eventname == "health_changed" then
			player:hud_change(id, "number", player:get_hp())
		elseif eventname == "properties_changed" then
			-- HP max has probably changed, update HP bar background size ("item") accordingly
			local hp_max = player:get_properties().hp_max
			player:hud_change(id, "item", hp_max)

			local offset = {}
			if hp_max / 2 <= 10 then
				offset = calculate_offset(10)
			else
				offset = calculate_offset(hp_max / 2)
			end

			player:hud_change(id, "offset", offset)
		end
	end)
end