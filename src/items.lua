core.register_craftitem("lifesteal_mod:heart", {
	description = "Heart",
	inventory_image = "heart.png",
	on_use = function(itemstack, user, pointed_thing)
        if lifesteal_mod.hasHealthBoost(user) then
            lifesteal_mod.chatSendPlayer(user:get_player_name(), "Wait before the Health Boost effect clears to use the heart.", "#FF0000")
            return
        end

        local newHP = lifesteal_mod.getHearts(user:get_player_name()) + 2
		if newHP > lifesteal_mod.HP_MAX then
            lifesteal_mod.chatSendPlayer(user:get_player_name(), "You have already reached the maximum number of hearts.", "#FF0000")
			return
		end

        lifesteal_mod.update(user, newHP)
        itemstack:take_item()
		return itemstack
	end
})
core.register_alias("heart", "lifesteal_mod:heart")

core.register_craftitem("lifesteal_mod:fragment", {
	description = "Heart Fragment",
	inventory_image = "lifesteal_mod_fragment.png",
})

core.register_tool("lifesteal_mod:revive_lantern", {
    description = "Revive Lantern.",
    inventory_image = "lifesteal_mod_revive_lantern.png",
    on_use = function(itemstack, user, pointed_thing)
        lifesteal_mod.lantern:show(user)
    end,
})

local function revivePlayer(player, ctx)
    local inv = player:get_inventory()
    local reviveName = ctx.form.playerName
    if not inv:contains_item("main", {name = "lifesteal_mod:revive_lantern"})
    or not reviveName or not lifesteal_mod.isBanned(reviveName) then
        lifesteal_mod.chatSendPlayer(player:get_player_name(), "Player is not real or is still alive.", "#FF0000")
        return
    end
    lifesteal_mod.lantern:close(player)
    if lifesteal_mod.revive(reviveName) then
        lifesteal_mod.chatSendPlayer(player:get_player_name(), "Revived " .. reviveName .. ".", "#05F53D")
        inv:remove_item("main", "lifesteal_mod:revive_lantern")
    end
end

local gui = flow.widgets
lifesteal_mod.lantern = flow.make_gui(function(player, ctx)
    return gui.Vbox{
        gui.Field{
            name = "playerName",
            label = "Revive:",
        },
        gui.ItemImageButton{
            w = 2, h = 2,
            item_name = "lifesteal_mod:revive_lantern",
            name = "revivePlayer",
            on_event = revivePlayer,
        },
        gui.Tooltip{
            tooltip = "",
            gui_element_name = "revivePlayer",
        },
    }
end)