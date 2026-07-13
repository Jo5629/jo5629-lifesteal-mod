local UNSUPPORTED_GAMES = {
    ["mineclonia"] = true,
}

local function get(name, default)
    return core.settings:get(name) or default
end

local worldMT = Settings(core.get_worldpath() .. "/world.mt")
local getMP = core.get_modpath
local MP = getMP(core.get_current_modname()) .. "/src"
local isDamageEnabled = get("enable_damage", false)

lifesteal_mod = {
    HP_NEWPLAYER = get("lifesteal_mod.hearts_newplayer", 10) * 2,
    HP_REVIVE = get("lifesteal_mod.hearts_revive", 3) * 2,
    HP_MAX = get("lifesteal_mod.max_hearts", 20) * 2,
    DEATH_MESSAGE_DEFAULT = get("lifesteal_mod.death_message", "You ran out of hearts."),
    CURRENT_GAME = worldMT:get("gameid"),
    HUDBARS = getMP("hudbars") ~= nil,
    VL_HUDBARS = getMP("vl_hudbars") ~= nil,
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

if not getMP("lib_chatcmdbuilder") then
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

if UNSUPPORTED_GAMES[lifesteal_mod.CURRENT_GAME]
and get("lifesteal_mod.show_unsupported_error", false) then
    core.log("error", "[lifesteal_mod] Unsupported game detected. The mod and world may function improperly.")
end