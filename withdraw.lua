minetest.register_privilege("withdraw", {
		description = "Allows to withdraw hearts from health bar."
})

minetest.register_chatcommand("withdraw", {
	description = "Takes an amount of hearts out of your own health.",
	params = "[<hearts>]",
	privs = {withdraw = true},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		if param == "" then
			return false
		end
		if player:get_properties().hp_max - tonumber(param) * 2 <= 0 then
			minetest.chat_send_player(player:get_player_name(), 
			minetest.get_color_escape_sequence("#FF0000")..
			"Error processing request.")
			return
		else
			local inv = player:get_inventory()
			if inv:room_for_item("main", {name = "lifesteal_mod:heart"}) then
				hclock = 0 
				repeat
					inv:add_item("main", "lifesteal_mod:heart")
					hclock = hclock + 1
				until hclock == tonumber(param)
			else
				hclock = 0
				repeat
					minetest.add_item(player:get_pos(), "lifesteal_mod:heart")
					hclock = hclock + 1
				until hclock == tonumber(param)
			end
			local health = player:get_meta():get_int("health")
			local health = health - tonumber(param) * 2
			player:get_meta():set_int("health", health)
			player:set_hp(health)
			player:set_properties({
				hp_max = health
			})
			minetest.chat_send_player(player:get_player_name(),
			minetest.get_color_escape_sequence("#05f53d")..
			string.format("Successful. Withdrew %d hearts.", tonumber(param)))
			minetest.log("action", string.format("%s withdrew %d hearts.", player:get_player_name(), tonumber(param)))
		end
	end,
})