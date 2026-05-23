core.register_craftitem("lifesteal_mod:heart", {
	description = "Heart",
	inventory_image = "heart.png",
	--stack_max = 65535,
    wield_scale = {x = 0.5, y = 0.5, z = 0.5},
	on_use = function(itemstack, user, pointed_thing)
        local newHPMax = user:get_properties().hp_max + 2
		if newHPMax > lifesteal_mod.HP_MAX then
			return
		end

        lifesteal_mod.update(user, nil, newHPMax)
        itemstack:take_item()
		return itemstack
	end
})
core.register_alias("heart", "lifesteal_mod:heart")

core.register_craftitem("lifesteal_mod:fragment", {
	description = "Heart Fragment",
	inventory_image = "fragment.png",
})

core.register_craftitem("lifesteal_mod:revive_lantern", {
    stack_max = 1,
    description = "Revive Lantern.",
    inventory_image = "revive.png",
    on_use = function(itemstack, user, pointed_thing)
        core.show_formspec(user:get_player_name(), "lifesteal_mod:revive_lantern",
        "formspec_version[4]"..
        "size[6,3.476]"..
        "field[0.375,1.25;5.25,0.8;name;Dead player's name here.;]"..
        "button[1.5,2.3;3,0.8;revive;Revive]")
    end,
})

local function closeFormspec(player, formname, reason, color)
	local name = player:get_player_name()
	core.chat_send_player(player:get_player_name(), core.colorize(color, reason))
	core.close_formspec(name, formname)
end

core.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "lifesteal_mod:revive_lantern" then
        return
    end
    if fields.revive or fields.key_enter_field == "name" then
        local name = tostring(fields.name)
        if not core.player_exists(name) then
			closeFormspec(player, formname, "Player is not real.", "#FF0000")
            return
        end

        if not lifesteal_mod.listContains(name) then
			closeFormspec(player, formname, "Player is not dead.", "#FF0000")
            return
        end

        lifesteal_mod.revive(name)
		closeFormspec(player, formname, "Successfully revived player.", "#05F53D")
        local inv = player:get_inventory()
        inv:remove_item("main", "lifesteal_mod:revive_lantern")
    end
end)