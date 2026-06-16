local HEART = "lifesteal_mod:heart"
local FRAGMENT = "lifesteal_mod:fragment"
local CRAFT = core.register_craft

if core.get_modpath("default") then
    local MESE = "default:mese"
    local OBSIDIAN = "default:obsidian"
    local DIAMOND = "default:diamondblock"

    CRAFT({
        output = "lifesteal_mod:revive_lantern",
        recipe = {
            {HEART, HEART, HEART},
            {HEART, "default:meselamp", HEART},
            {OBSIDIAN, OBSIDIAN, OBSIDIAN},
        },
    })

    CRAFT({
        output = FRAGMENT,
        recipe = {
            {OBSIDIAN, MESE, OBSIDIAN},
            {DIAMOND, "default:goldblock", DIAMOND},
            {OBSIDIAN, MESE, OBSIDIAN},
        },
    })

    CRAFT({
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
    local HEALING = "mcl_potions:healing"

    CRAFT({
        output = HEART,
        recipe = {
            {NAUTILUS, NETHERITE, NAUTILUS},
            {NETHERITE, STAR, NETHERITE},
            {NAUTILUS, NETHERITE, NAUTILUS},
        },
    })

    CRAFT({
        output = "lifesteal_mod:revive_lantern",
        recipe = {
            {HEART, TOTEM, HEART},
            {HEALING, "mcl_lanterns:soul_lantern_floor", HEALING},
            {HEART, TOTEM, HEART}
        }
    })
end