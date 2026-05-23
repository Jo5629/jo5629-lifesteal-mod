local HEART = "lifesteal_mod:heart"
local chatcmdbuilder = dofile(core.get_modpath(core.get_current_modname()) .. "/src/chatcmdbuilder.lua")

core.register_privilege("withdraw", {
	description = "Allows to withdraw hearts from health bar.",
	give_to_singleplayer = true,
})

local function withdraw(player, hearts)
    local totalHP = hearts * 2
    local newHP = player:get_properties().hp_max - totalHP
    if newHP <= 0 then
        return
    end

    local inv = player:get_inventory()
    for _ = 1, hearts do
        if inv:room_for_item("main", {name = HEART}) then
            inv:add_item("main", HEART)
        else
            core.add_item(player:get_pos(), HEART)
        end
    end

    lifesteal_mod.update(player, newHP)
end

local cmd = chatcmdbuilder.register("withdraw", {
    privs = {withdraw = true},
})

cmd:sub("", function(name)
    withdraw(core.get_player_by_name(name), 1)
end)

cmd:sub(":int:int", function(name, int)
    if int > 0 then
        withdraw(core.get_player_by_name(name), int)
    end
end)