local storage = core.get_mod_storage()
local banList = {}
local hpList = {}

if storage:contains("lifesteal_mod.dead_players") then --> Backwards compatibility
    banList = core.deserialize(storage:get_string("lifesteal_mod.dead_players"))
    storage:set_string("lifesteal_mod.dead_players", "")
elseif storage:contains("lifesteal_mod:banList") then
    banList = core.parse_json(storage:get_string("lifesteal_mod:banList"))
end
if storage:contains("lifesteal_mod:hpList") then
    hpList = core.parse_json(storage:get_string("lifesteal_mod:hpList"))
end
if type(banList) ~= "table" then banList = {} end
if type(hpList) ~= "table" then hpList = {} end

function lifesteal_mod.update(player, hpMax)
    local name = player:get_player_name()
    if not hpMax then
        hpMax = lifesteal_mod.HP_MAX_NEWPLAYER
        if lifesteal_mod.getHearts(name) then
            hpMax = lifesteal_mod.getHearts(name)
        end
    end

    lifesteal_mod.setHearts(name, hpMax)
    player:set_properties({hp_max = hpMax})

    if lifesteal_mod.vl_hudbars then
        vl_hudbars.update_health(player)
    elseif lifesteal_mod.hudbars then
        hb.change_hudbar(player, "health", player:get_hp(), hpMax)
    end
end

function lifesteal_mod.getHearts(pName)
    return hpList[pName]
end

function lifesteal_mod.setHearts(pName, num)
    hpList[pName] = num
    storage:set_string("lifesteal_mod:hpList", core.write_json(hpList))
end

function lifesteal_mod.banPlayer(pName)
    banList[pName] = true
    storage:set_string("lifesteal_mod:banList", core.write_json(banList))
end

function lifesteal_mod.unbanPlayer(pName)
    banList[pName] = nil
    storage:set_string("lifesteal_mod:banList", core.write_json(banList))
end

function lifesteal_mod.listContains(pName)
    for name, _ in pairs(banList) do
        if name == pName then
            return true
        end
    end
    return false
end

function lifesteal_mod.tryToKick(player)
    if lifesteal_mod.listContains(player:get_player_name()) then
        lifesteal_mod.kickAndBan(player:get_player_name())
        return true
    end
    return false
end

function lifesteal_mod.kickAndBan(pName)
    lifesteal_mod.banPlayer(pName)
    core.kick_player(pName, lifesteal_mod.DEATH_MESSAGE_DEFAULT)
end

function lifesteal_mod.revive(pName)
    if not lifesteal_mod.listContains(pName) then
        return false
    end
    lifesteal_mod.setHearts(pName, lifesteal_mod.HP_REVIVE)
    lifesteal_mod.unbanPlayer(pName)
    return true
end

function lifesteal_mod.chatSendPlayer(pName, text, color)
    color = color or "#FFFFFF"
    core.chat_send_player(pName, core.colorize(color, text))
end