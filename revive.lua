minetest.register_craftitem("lifesteal_mod:revive_lantern", {
    stack_max = 1,
    description = "Revive Lantern.",
    inventory_image = "revive.png",
    on_use = function(itemstack, user, pointed_thing)
        minetest.show_formspec(user:get_player_name(), "lifesteal_mod:revive_lantern", 
        "formspec_version[4]"..
        "size[6,3.476]"..
        "field[0.375,1.25;5.25,0.8;name;Dead player's name here.;]"..
        "button[1.5,2.3;3,0.8;revive;Revive]")
        itemstack:take_item()
        return itemstack
    end,
})
minetest.register_on_player_receive_fields(function(player, formname, fields)
    if formname ~= "lifesteal_mod:revive_lantern" then
        return
    end
    local inv = player:get_inventory()
    if fields.revive then
        if not minetest.player_exists(tostring(fields.name)) then
            minetest.chat_send_player(player:get_player_name(), 
            minetest.get_color_escape_sequence("#FF0000")..
            "Player is not real.")
            inv:add_item("main", "lifesteal_mod:revive_lantern")
            minetest.close_formspec(player:get_player_name(), formname)
            return
        end
        local rname = minetest.get_player_by_name(tostring(fields.name))
        if rname == nil then
            minetest.chat_send_player(player:get_player_name(), 
            minetest.get_color_escape_sequence("#FF0000")..
            "Player is not online.")
            inv:add_item("main", "lifesteal_mod:revive_lantern")
            minetest.close_formspec(player:get_player_name(), formname)
            return
        end
        if rname:get_meta():get_int("dead") == 0 then
            minetest.chat_send_player(player:get_player_name(), 
            minetest.get_color_escape_sequence("#FF0000")..
            "Player is not dead.")
            inv:add_item("main", "lifesteal_mod:revive_lantern")
            minetest.close_formspec(player:get_player_name(), formname)
            return
        end
        if rname:get_meta():get_int("dead") == 1 then
            rname:get_meta():set_int("health", 8) --8 = 4 hearts.
            rname:get_meta():set_int("dead", 0)
            minetest.chat_send_player(player:get_player_name(), 
            minetest.get_color_escape_sequence("#05f53d")..
            "Successfully revived player.")
            minetest.kick_player(rname:get_player_name(), string.format("%s has revived you! Rejoin to activate.", player:get_player_name()))
            minetest.close_formspec(player:get_player_name(), formname)
        end
    end
end)