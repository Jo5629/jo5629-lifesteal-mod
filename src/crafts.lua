local HEART = "lifesteal_mod:heart"
local FRAGMENT = "lifesteal_mod:fragment"

if core.get_modpath("default") then
    local MESE = "default:mese"
    local OBSIDIAN = "default:obsidian"
    local DIAMOND = "default:diamondblock"

    core.register_craft({
        output = "lifesteal_mod:revive_lantern",
        recipe = {
            {HEART, HEART, HEART},
            {HEART, "default:meselamp", HEART},
            {OBSIDIAN, OBSIDIAN, OBSIDIAN},
        },
    })

    core.register_craft({
        output = FRAGMENT,
        recipe = {
            {OBSIDIAN, MESE, OBSIDIAN},
            {DIAMOND, "default:goldblock", DIAMOND},
            {OBSIDIAN, MESE, OBSIDIAN},
        },
    })

    core.register_craft({
        output = HEART,
        recipe = {
            {FRAGMENT, MESE, FRAGMENT},
            {FRAGMENT, DIAMOND, FRAGMENT},
            {FRAGMENT, MESE, FRAGMENT},
        }
    })
end

if lifesteal_mod.CURRENT_GAME == "mineclone2" then
    core.unregister_item(FRAGMENT)

    local NAUTILUS = "mcl_mobitems:nautilus_shell"
    local NETHERITE = "mcl_nether:netherite_ingot"
    local STAR = "mcl_mobitems:nether_star"
    local TOTEM = "mcl_totems:totem"

    core.register_craft({
        output = HEART,
        recipe = {
            {NAUTILUS, NETHERITE, NAUTILUS},
            {NETHERITE, STAR, NETHERITE},
            {NAUTILUS, NETHERITE, NAUTILUS},
        },
    })

    core.register_craft({
        output = "lifesteal_mod:revive_lantern",
        recipe = {
            {HEART, "mcl_armor:elytra", HEART},
            {TOTEM, "mcl_mobitems:heart_of_the_sea", "mcl_potions:speckled_melon"},
            {HEART, "mcl_heads:skeleton", HEART},
        },
    })
end