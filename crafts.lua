local heart = "lifesteal_mod:heart"
local fragment = "lifesteal_mod:fragment"

--> Crafts with default mod.
if minetest.get_modpath("default") then
    local meseblock = "default:mese"
    local obsidian = "default:obsidian"
    local diamondblock = "default:diamondblock"

    minetest.register_craft({
        type = "shaped",
        output = "lifesteal_mod:revive_lantern",
        recipe = {
            {heart, heart, heart},
            {heart, "default:meselamp", heart},
            {"default:obsidian", "default:obsidian", "default:obsidian"},
        },
    })

    minetest.register_craft({
        type = "shaped",
        output = "lifesteal_mod:fragment",
        recipe = {
            {obsidian, meseblock, obsidian},
            {diamondblock, "default:goldblock", diamondblock},
            {obsidian, meseblock, obsidian},
        },
    })

    minetest.register_craft({
        type = "shaped",
        output = "lifesteal_mod:heart",
        recipe = {
            {fragment, meseblock, fragment},
            {fragment, diamondblock, fragment},
            {fragment, meseblock, fragment},
        }
    })
end