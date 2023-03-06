minetest.register_craftitem("lifesteal_mod:heart", {
		groups = {not_in_creative_inventory = 1},
		description = "1 Heart as an item.",
		inventory_image = "heart.png",
		on_use = function(itemstack, user, pointed_thing)
			local meta = user:get_meta()
			local health = meta:get_int("health")
			local health = health + 2
			meta:set_int("health", health)
			local inv = user:get_inventory()
			itemstack:take_item()
			user:set_properties({
					hp_max = health
			})
			return itemstack
		end
})