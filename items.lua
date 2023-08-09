local max_hearts = 20 --> Will make into a setting in the future.

--> Heart Item.
minetest.register_craftitem("lifesteal_mod:heart", {
	description = "Heart",
	inventory_image = "heart.png",
	on_use = function(itemstack, user, pointed_thing)
		if user:get_properties().hp_max / 2 >= max_hearts then
			minetest.chat_send_player(user:get_player_name(), minetest.colorize("#FF0000", "You have the max amount of hearts."))
			return
		end
		local meta = user:get_meta()
		local health = meta:get_int("health")
		local health = health + 2
		meta:set_int("health", health)
		itemstack:take_item()
		user:set_properties({
				hp_max = health
		})
		lifesteal_mod.change_hp_max(user, health, health, false)
		return itemstack
	end
})
minetest.register_alias("heart", "lifesteal_mod:heart")

minetest.register_craftitem("lifesteal_mod:fragment", {
	description = "Heart Fragment",
	inventory_image = "fragment.png",
})

--> Revive Lantern.

minetest.register_craftitem("lifesteal_mod:revive_lantern", {
    stack_max = 1,
    description = "Revive Lantern.",
    inventory_image = "revive.png",
    on_use = function(itemstack, user, pointed_thing)
        minetest.show_formspec(user:get_player_name(), "lifesteal_mod:revive_lantern", 
        "formspec_version[4]"..
        "size[6,3.476]"..
        "field[0.375,1.25;5.25,0.8;name;Dead player's name here.;]"..
        "button[1.5,2.3;3,0.8;revive;Revive]")
    end,
})

local function close_formspec(player, formname, reason, color)
	local name = player:get_player_name()
	minetest.chat_send_player(player:get_player_name(), minetest.colorize(color, reason))
	minetest.close_formspec(name, formname)
end

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "lifesteal_mod:revive_lantern" then
        return
    end
    if fields.revive or fields.key_enter_field == "name" then
        local name = tostring(fields.name)
        if not minetest.player_exists(name) then
			close_formspec(player, formname, "Player is not real.", "#FF0000")
            return
        end

        if not lifesteal_mod.is_player_dead(name) then
			close_formspec(player, formname, "Player is not dead.", "#FF0000")
            return
        end

        lifesteal_mod.remove_player(name)
		close_formspec(player, formname, "Successfully revived player.", "#05F53D")
        local inv = player:get_inventory()
        inv:remove_item("main", "lifesteal_mod:revive_lantern")
    end
end)