local HEART_ITEMNAME = "lifesteal_mod:heart"
local PREFIX = lifesteal_mod.PREFIX
local combatTimers = {}

core.register_on_prejoinplayer(function(name)
    if lifesteal_mod.isBanned(name) then
        return lifesteal_mod.DEATH_MESSAGE_DEFAULT
    end
end)

core.register_on_joinplayer(function(player, last_login)
    --> Backwards compatibility.
    local meta = player:get_meta()
    if meta:contains("health") then
        lifesteal_mod.update(player, meta:get_int("health"))
        meta:set_string("health", "")
    else
        lifesteal_mod.update(player)
    end

    lifesteal_mod.tryToKick(player)
end)

local function giveHeartTo(name)
    if lifesteal_mod.isBanned(name) then return end
    local player = core.get_player_by_name(name)
    local newHP = lifesteal_mod.getHearts(name) + 2
    if player then
        local newHealthBoostHP = player:get_properties().hp_max + 2
        if newHP > lifesteal_mod.HP_MAX then
            local inv = player:get_inventory()
            if inv:room_for_item("main", {name = HEART_ITEMNAME}) then
                inv:add_item("main", HEART_ITEMNAME)
            else
                core.add_item(player:get_pos(), HEART_ITEMNAME)
            end
            return
        end
        lifesteal_mod.update(player, newHP)
        if lifesteal_mod.hasHealthBoost(player) then
            player:set_properties({hp_max = newHealthBoostHP})
            vl_hudbars.update_health(player)
        end
    else
        lifesteal_mod.setHearts(name, newHP)
    end
end

local function onDie(player)
    local name = player:get_player_name()
    local newHP = lifesteal_mod.getHearts(name) - 2
    lifesteal_mod.update(player, newHP)

    if newHP <= 0 then
        lifesteal_mod.kickAndBan(name)
    end

    local combatDef = combatTimers[name]
    if combatDef then
        giveHeartTo(combatDef.hitter)
        combatTimers[name] = nil
    end
end

core.register_on_dieplayer(onDie)

core.register_on_punchplayer(function(player, hitter, time_from_last_punch, tool_capabilities, dir, damage)
    if player == hitter or not hitter:is_player() then return end
    if player:get_hp() > 0 then
        local name = player:get_player_name()
        if not combatTimers[name] and lifesteal_mod.NOTIFY_COMBAT_MODE then
            local start = (lifesteal_mod.ENABLE_COMBAT_LOGGING and " Dying or logging out") or " Dying"
            local message = start .. " while in combat will result in the loss of a heart."
            lifesteal_mod.chatSendPlayer(name, PREFIX .. message, "#FF0000")
        end
        combatTimers[name] = {
            hitter = hitter:get_player_name(),
            timer = lifesteal_mod.COMBAT_TIMER,
        }
    end
end)

core.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    if combatTimers[name] then
        if lifesteal_mod.ENABLE_COMBAT_LOGGING then
            onDie(player)
        else
            combatTimers[name] = nil
        end
    end
end)

core.register_globalstep(function(dtime)
    for player, def in pairs(combatTimers) do
        local timeLeft = def.timer - dtime
        combatTimers[player].timer = timeLeft
        if timeLeft <= 0 then
            if lifesteal_mod.NOTIFY_COMBAT_MODE then
                lifesteal_mod.chatSendPlayer(player, PREFIX .. " You have exited combat mode.", "#00FF00")
            end
            combatTimers[player] = nil
        end
    end
end)

if lifesteal_mod.CURRENT_GAME == "mineclone2" then
    local effect = mcl_potions.registered_effects["health_boost"]
    local oldOnStart = effect.on_start or function() end
    local oldOnLoad = effect.on_load or function() end
    local oldAfterEnd = effect.after_end or function() end

    local function onStart(object, factor)
        local newHP = lifesteal_mod.getHearts(object:get_player_name()) + factor
        object:set_properties({hp_max = newHP})
        vl_hudbars.update_health(object)
    end

    effect.on_start = function(object, factor)
        oldOnStart(object, factor)
        onStart(object, factor)
    end
    effect.on_load = function(player, factor)
        oldOnLoad(player, factor)
        core.after(0, function() onStart(player, factor) end)
    end
    effect.after_end = function(object)
        oldAfterEnd(object)
        lifesteal_mod.update(object)
    end

    mcl_potions.registered_effects["health_boost"] = effect
end