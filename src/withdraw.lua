local HEART = "lifesteal_mod:heart"
local colorize = core.colorize

core.register_privilege("withdraw", {
	description = "Allows to withdraw hearts from health bar.",
	give_to_singleplayer = true,
})

local function withdraw(player, hearts)
    if lifesteal_mod.hasHealthBoost(player) then
        return false, colorize("#FF0000", "Wait before the Health Boost effect clears to withdraw a heart.")
    end

    local totalHP = hearts * 2
    local newHP = lifesteal_mod.getHearts(player:get_player_name()) - totalHP
    if newHP <= 0 then
        return false, colorize("#FF0000", "You are withdrawing too many hearts.")
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
    params = "<num>",
    privs = {withdraw = true},
})

cmd:sub("", function(name)
    return withdraw(core.get_player_by_name(name), 1)
end)

cmd:sub(":int:int", function(name, int)
    if int > 0 then
        return withdraw(core.get_player_by_name(name), int)
    end
end)