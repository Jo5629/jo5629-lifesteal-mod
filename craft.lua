local heart = "lifesteal_mod:heart"

if minetest.get_modpath("default") then
    minetest.register_craft({
        type = "shaped",
        output = "lifesteal_mod:revive_lantern",
        recipe = {
            {heart, heart, heart},
            {heart, "default:meselamp", heart},
            {"default:obsidian", "default:obsidian", "default:obsidian"},
        },
    })
end