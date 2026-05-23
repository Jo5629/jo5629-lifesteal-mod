core.register_craftitem("lifesteal_mod:heart", {
	description = "Heart",
	inventory_image = "heart.png",
    stack_max = 1,
	on_use = function(itemstack, user, pointed_thing)
        local newHPMax = user:get_properties().hp_max + 2
		if newHPMax > lifesteal_mod.HP_MAX then
			return
		end

        lifesteal_mod.update(user, newHPMax)
        itemstack:take_item()
		return itemstack
	end
})
core.register_alias("heart", "lifesteal_mod:heart")

core.register_craftitem("lifesteal_mod:fragment", {
	description = "Heart Fragment",
	inventory_image = "fragment.png",
})

core.register_tool("lifesteal_mod:revive_lantern", {
    description = "Revive Lantern.",
    inventory_image = "revive.png",
    on_use = function(itemstack, user, pointed_thing)
        lifesteal_mod.lantern:show(user)
    end,
})

local function revivePlayer(player, ctx)
    local inv = player:get_inventory()
    local reviveName = ctx.form.playerName
    if not inv:contains_item("main", {name = "lifesteal_mod:revive_lantern"})
    or not reviveName or not lifesteal_mod.listContains(reviveName) then
        lifesteal_mod.chatSendPlayer(player:get_player_name(), "Player is not real or is still alive.", "#FF0000")
        return
    end
    lifesteal_mod.lantern:close(player)
    lifesteal_mod.revive(reviveName)
    lifesteal_mod.chatSendPlayer(player:get_player_name(), "Revived " .. reviveName .. ".", "#05F53D")
    inv:remove_item("main", "lifesteal_mod:revive_lantern")
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