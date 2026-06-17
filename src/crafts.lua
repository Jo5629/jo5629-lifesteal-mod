local HEART = "lifesteal_mod:heart"
local FRAGMENT = "lifesteal_mod:fragment"
local LANTERN = "lifesteal_mod:revive_lantern"
local CRAFT = core.register_craft

if core.get_modpath("default") then
    local MESE = "default:mese"
    local OBSIDIAN = "default:obsidian"
    local DIAMOND = "default:diamondblock"

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
            {MESE, DIAMOND, MESE},
            {FRAGMENT, MESE, FRAGMENT},
        }
    })

    CRAFT({
        output = LANTERN,
        recipe = {
            {HEART, OBSIDIAN, HEART},
            {OBSIDIAN, "default:meselamp", OBSIDIAN},
            {HEART, OBSIDIAN, HEART},
        },
    })
end

if lifesteal_mod.CURRENT_GAME == "mineclone2" then
    core.unregister_item(FRAGMENT)

    local NAUTILUS = "mcl_mobitems:nautilus_shell"
    local NETHERITE = "mcl_nether:netherite_ingot"
    local STAR = "mcl_mobitems:nether_star"
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
        output = LANTERN,
        recipe = {
            {HEART, "mcl_totems:totem", HEART},
            {HEALING, "mcl_lanterns:soul_lantern_floor", HEALING},
            {HEART, "mcl_end:crystal", HEART}
        }
    })
end