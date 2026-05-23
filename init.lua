lifesteal_mod = {
    HP_MAX_NEWPLAYER = 20,
    HP_REVIVE = 6,
    HP_MAX = 40,
    DEATH_MESSAGE_DEFAULT = "You ran out of hearts.",
    hudbars = core.get_modpath("hudbars") ~= nil,
    vl_hudbars = core.get_modpath("vl_hudbars") ~= nil,
}

lifesteal_mod.HP_MAX = core.settings:get("lifesteal_mod.max_hearts") * 2

local modpath = core.get_modpath(core.get_current_modname()) .. "/src"
dofile(modpath .. "/api.lua")
dofile(modpath .. "/register.lua")
dofile(modpath .. "/items.lua")
dofile(modpath .. "/withdraw.lua")
dofile(modpath .. "/crafts.lua")

if not (lifesteal_mod.hudbars or lifesteal_mod.vl_hudbars) then
    dofile(modpath .. "/hud.lua")
end