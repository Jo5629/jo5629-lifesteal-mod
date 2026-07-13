local worldMT = Settings(core.get_worldpath() .. "/world.mt")

lifesteal_mod = {
    HP_NEWPLAYER = 20,
    HP_REVIVE = 6,
    HP_MAX = core.settings:get("lifesteal_mod.max_hearts") * 2 or 40,
    DEATH_MESSAGE_DEFAULT = "You ran out of hearts.",
    CURRENT_GAME = worldMT:get("gameid"),
    HUDBARS = core.get_modpath("hudbars") ~= nil,
    VL_HUDBARS = core.get_modpath("vl_hudbars") ~= nil,
}

core.register_privilege("lifesteal_admin", {
    description = "Grants access to special functionality for lifesteal_mod.",
    give_to_singleplayer = false,
    give_to_admin = true,
})

core.register_privilege("withdraw", {
	description = "Grants the usage of the /withdraw command.",
	give_to_singleplayer = false,
})

local MP = core.get_modpath(core.get_current_modname()) .. "/src"
local isDamageEnabled = core.settings:get_bool("enable_damage", false)

if not core.get_modpath("lib_chatcmdbuilder") then
    chatcmdbuilder = dofile(MP .. "/chatcmdbuilder.lua")
end

dofile(MP .. "/api.lua")
dofile(MP .. "/items.lua")
dofile(MP .. "/crafts.lua")

if isDamageEnabled then
    dofile(MP .. "/register.lua")
    dofile(MP .. "/withdraw.lua")
    dofile(MP .. "/commands.lua")
    if not (lifesteal_mod.HUDBARS or lifesteal_mod.VL_HUDBARS) then
        dofile(MP .. "/hud.lua")
    end
else
    core.log("warning", "[lifesteal_mod] Core functionality is disabled because `enable_damage` is disabled.")
end

if lifesteal_mod.CURRENT_GAME == "mineclonia" then
    core.log("error", "[lifesteal_mod] Mineclonia may cause the mod and world to function improperly.")
end