local cmd = chatcmdbuilder.register("ls", {
    params = "(<name> +<num>) | (<name> -<num>) | (revive <name>)",
    privs = {server = true},
})

local colorize = core.colorize
local function addHearts(target, num)
    num = num * 2
    if not core.player_exists(target) or not lifesteal_mod.getHearts(target) then
        return false, colorize("#FF0000", "Player does not exist!")
    end
    local newHP = lifesteal_mod.getHearts(target) + num
    if newHP > lifesteal_mod.HP_MAX then
        newHP = lifesteal_mod.HP_MAX
    end
    if newHP < 2 then
        newHP = 2
    end

    local targetObj = core.get_player_by_name(target)
    if targetObj then
        lifesteal_mod.update(targetObj, newHP)
    else
        lifesteal_mod.setHearts(target, newHP)
    end
    return true, colorize("#00FF00", ("Set %s's hearts to %d."):format(target, newHP / 2))
end

cmd:sub(":target:username +:num:int", function(name, target, num)
    if num <= 0 then
        return
    end
    return addHearts(target, num)
end)

cmd:sub(":target:username -:num:int", function(name, target, num)
    if num <= 0 then
        return
    end
    return addHearts(target, -1 * num)
end)

cmd:sub("revive :target:username", function(name, target)
    local player = core.get_player_by_name(name)
    if not lifesteal_mod.listContains(target) then
        lifesteal_mod.chatSendPlayer(player:get_player_name(), "Player is not real or is still alive.", "#FF0000")
        return
    end
    if lifesteal_mod.revive(target) then
        lifesteal_mod.chatSendPlayer(player:get_player_name(), "Revived " .. target .. ".", "#05F53D")
    end
end)