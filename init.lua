local worldMT = Settings(core.get_worldpath() .. "/world.mt")

lifesteal_mod = {
    HP_NEWPLAYER = 20,
    HP_REVIVE = 6,
    HP_MAX = 40,
    DEATH_MESSAGE_DEFAULT = "You ran out of hearts.",
    CURRENT_GAME = worldMT:get("gameid"),
    HUDBARS = core.get_modpath("hudbars") ~= nil,
    VL_HUDBARS = core.get_modpath("vl_hudbars") ~= nil,
}

lifesteal_mod.HP_MAX = core.settings:get("lifesteal_mod.max_hearts") * 2

local MP = core.get_modpath(core.get_current_modname()) .. "/src"

if not core.get_modpath("lib_chatcmdbuilder") then
    chatcmdbuilder = dofile(MP .. "/chatcmdbuilder.lua")
end

dofile(MP .. "/api.lua")
dofile(MP .. "/register.lua")
dofile(MP .. "/items.lua")
dofile(MP .. "/crafts.lua")
dofile(MP .. "/withdraw.lua")
dofile(MP .. "/commands.lua")

if not (lifesteal_mod.HUDBARS or lifesteal_mod.VL_HUDBARS) then
    dofile(MP .. "/hud.lua")
end