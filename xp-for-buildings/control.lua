require("util")
function calculateExpForMining(entity)
	resources = entity.surface.find_entities_filtered { position = { entity.position.x, entity.position.y }, radius =
		math.ceil(entity.prototype.mining_drill_radius), type = "resource" }
	resource_count = 0
	for key, value in pairs(resources) do
		resource_count = resource_count + value.amount
	end
	if global.built_machines[entity.unit_number].resource_count == nil then
		global.built_machines[entity.unit_number].resource_count = resource_count
		return  0
	else
		collected = global.built_machines[entity.unit_number].resource_count - resource_count
		global.built_machines[entity.unit_number].mining_count = collected
		return collected
	end
		
	
end
function getCount(entity)
	if entity.type == "lab" then
		return global.built_machines[entity.unit_number].research_count
	elseif entity.type == "mining-drill" then
		

		collected = calculateExpForMining(entity)

		return collected
	else
		return entity.products_finished
	end
end

function setCount(unit_number, count, name)
	global.built_machines[unit_number][name] = count
end

function updateCount(old_unit_number, new_unit_number, name)
	resource_count = 0
	if global.built_machines[old_unit_number] ~= nil and global.built_machines[old_unit_number][name] ~= nil then
		resource_count = global.built_machines[old_unit_number][name]
	end
	global.built_machines[new_unit_number][name] = resource_count
end

function setStoreCount(tab, count)
	table.insert(tab, count)
	table.sort(tab)
end

function setupMachines()
	if global.machines == nil then
		global.machines = {}
		local machines = {}
		for key, value in pairs(game.entity_prototypes) do
			print(key)

			rootName, _ = GetRootNameOfMachine(key)

			if machines[rootName] == nil then
				machines[rootName] = {
					level_name = rootName .. '-level-',
					max_level = 1
				}
			else
				machines[rootName].max_level = machines[rootName].max_level + 1
			end
		end
		for rootName, value in pairs(machines) do
			if value.max_level > 1 then
				global.machines[rootName] = value
			end
		end
	end
end

script.on_init(function()
	global.stored_products_finished_assemblers = {}
	global.stored_products_finished_furnaces = {}
	global.stored_research_count = {}
	global.stored_mining_count = {}

	setupMachines()
	get_built_machines()
end)

script.on_load(function()
	if global.machines == nil then
		global.reset = true
		script.on_nth_tick(60, function()
			setupMachines()
			get_built_machines()
		end)
	end
end)
script.on_configuration_changed(function()
	get_built_machines()
	global.machines = nil
	setupMachines()
end)

function get_built_machines()
	global.built_machines = global.built_machines or {}
	for unit_number, machine in pairs(global.built_machines) do
		if not machine.entity or not machine.entity.valid then
			global.built_machines[unit_number] = nil
		end
	end
	local built_assemblers = {}
	for _, surface in pairs(game.surfaces) do
		local assemblers = surface.find_entities_filtered { type = { "assembling-machine", "furnace", "lab",
			"mining-drill" } }
		for _, machine in pairs(assemblers) do
			if not global.built_machines[machine.unit_number] then
				global.built_machines[machine.unit_number] = { entity = machine, unit_number = machine.unit_number }
			end
			table.insert(built_assemblers, machine)
		end
	end
	replace_machines(built_assemblers)
end

function GetRootNameOfMachine(str, start)
	if string.find(str, '-level-') then
		start, _ = string.find(str, '-level-', 1, true)
		rootName = string.sub(str, 0, start - 1)
		return rootName, false
	else
		return str, true
	end
end

exponent = settings.global["factory-levels-exponent"].value
max_level = 1
function update_machine_levels(overwrite)
	if overwrite then
		max_level = 100 -- Just in case another mod cuts the max level of this mods machines to something like 25.
		required_items_for_levels = {}
		exponent = settings.global["factory-levels-exponent"].value
	end
	for i = 1, (max_level + 1), 1 do -- Adding one more level for machine upgrade to next tier.
		if required_items_for_levels[i] == nil then
			table.insert(required_items_for_levels, math.floor(math.pow(i, exponent)))
		end
	end
end

remote.add_interface("factory_levels", {
	add_machine = function(machine)
		if machine.name == nil or machine.level_name == nil or machine.max_level == nil then
			return false
		else
			global.machines[machine.name] = machine
			if machine.max_level > max_level then
				max_level = machine.max_level
				update_machine_levels()
			end
			return true
		end
	end,
	update_machine = function(machine)
		if machine.name == nil or global.machines[machine.name] == nil then
			return false
		else
			global.machines[machine.name].level_name = machine.level_name or global.machines[machine.name].level_name
			global.machines[machine.name].max_level = machine.max_level or global.machines[machine.name].max_level
			global.machines[machine.name].next_machine = machine.next_machine or
				global.machines[machine.name].next_machine
			global.machines[machine.name].disable_mod_setting = machine.disable_mod_setting or
				global.machines[machine.name].disable_mod_setting
			if global.machines[machine.name].max_level > max_level then
				max_level = global.machines[machine.name].max_level
				update_machine_levels()
			end
			return true
		end
	end,
	remove_machine = function(machine_name)
		if machine_name == nil or global.machines[machine_name] == nil then
			return false
		end
		global.machines[machine_name] = nil
		return true
	end,
	get_machine = function(machine_name)
		if machine_name == nil then
			return nil
		end
		return global.machines[machine_name]
	end
})

required_items_for_levels = {
}

update_machine_levels(true)

function determine_level(finished_products_count)
	local should_have_level = 1
	if finished_products_count == nil then
		finished_products_count = 0
	end

	for level, min_count_required_for_level in pairs(required_items_for_levels) do
		if finished_products_count >= min_count_required_for_level then
			should_have_level = level
		end
	end

	return should_have_level
end

function determine_machine(entity)
	if settings.global["factory-levels-disable-mod"].value then
		return nil
	end
	if entity == nil or not entity.valid or (entity.type ~= "assembling-machine" and entity.type ~= "furnace") then
		return nil
	end
	rootName, _ = GetRootNameOfMachine(entity.name, machine.level_name)
	machine = global.machines[rootName]
	if machine then
		return machine
	end
	return nil
end

function get_inventory_contents(inventory)
	inventory_results = {}
	if inventory == nil then
		return inventory_results
	end

	inventory_contents = inventory.get_contents()
	for name, count in pairs(inventory_contents) do
		table.insert(inventory_results, { name = name, count = count })
	end
	return inventory_results
end

function insert_inventory_contents(inventory, contents)
	if inventory == nil or not inventory.is_empty() then
		return
	end
	for _, item in pairs(contents) do
		inventory.insert(item)
	end
end

function upgrade_factory(surface, targetname, sourceentity)
	unit_number = sourceentity.unit_number
	finished_products_count = getCount(sourceentity)

	local box = sourceentity.bounding_box
	local item_requests = nil
	local recipe = nil

	local existing_requests = surface.find_entity("item-request-proxy", sourceentity.position)
	if existing_requests then
		-- Module requests do not survive the machine being replaced.  Preserve them before the machine is replaced.
		item_requests = {}
		for module_name, count in pairs(existing_requests.item_requests) do
			item_requests[module_name] = count
		end
		if next(item_requests, nil) == nil then
			item_requests = nil
		end
	end

	-- For unknown reasons, Factorio is voiding ALL of the inventories of the machine.
	local input_inventory = {}
	if sourceentity.type == "assembling-machine" then
		input_inventory = get_inventory_contents(sourceentity.get_inventory(defines.inventory.assembling_machine_input))
	elseif sourceentity.type == "furnace" then
		input_inventory = get_inventory_contents(sourceentity.get_inventory(defines.inventory.furnace_source))
	end
	local output_inventory = get_inventory_contents(sourceentity.get_output_inventory())
	local module_inventory = get_inventory_contents(sourceentity.get_module_inventory())
	local fuel_inventory = get_inventory_contents(sourceentity.get_fuel_inventory())
	local burnt_result_inventory = get_inventory_contents(sourceentity.get_burnt_result_inventory())

	global.built_machines[unit_number] = nil
	if sourceentity.type == "assembling-machine" then
		-- Recipe should survive, but why take that chance.
		recipe = sourceentity.get_recipe()
	end
	-- direction not working (Bug? bug to bi-bio)
	local created = surface.create_entity { name = targetname,
		source = sourceentity,
		direction = sourceentity.direction,
		orientation = sourceentity.orientation,
		raise_built = true,
		fast_replace = true,
		spill = false,
		create_build_effect_smoke = false,
		position = sourceentity.position,
		force = sourceentity.force }

	global.built_machines[created.unit_number] = { entity = created, unit_number = created.unit_number }
	if item_requests then
		surface.create_entity({
			name = "item-request-proxy",
			position = created.position,
			force = created.force,
			target = created,
			modules = item_requests
		})
	end



	if created.type == "lab" then
		updateCount(unit_number, created.unit_number, "research_count")
	elseif created.type == "mining-drill" then
		updateCount(unit_number, created.unit_number, "mining_count")
	else
		created.products_finished = finished_products_count;
	end
	sourceentity.destroy()

	if created.type == "assembling-machine" and recipe ~= nil then
		created.set_recipe(recipe)
	end

	if created.type == "assembling-machine" then
		insert_inventory_contents(created.get_inventory(defines.inventory.assembling_machine_input), input_inventory)
	elseif created.type == "furnace" then
		insert_inventory_contents(created.get_inventory(defines.inventory.furnace_source), input_inventory)
	end
	insert_inventory_contents(created.get_output_inventory(), output_inventory)
	insert_inventory_contents(created.get_module_inventory(), module_inventory)
	insert_inventory_contents(created.get_fuel_inventory(), fuel_inventory)
	insert_inventory_contents(created.get_burnt_result_inventory(), burnt_result_inventory)

	local old_on_ground = surface.find_entities_filtered { area = box, name = 'item-on-ground' }
	for _, item in pairs(old_on_ground) do
		item.destroy()
	end

	return created
end

function replace_machines(entities)
	if global.machines ~= nil then
		for _, entity in pairs(entities) do
			rootName, isRootAlready = GetRootNameOfMachine(entity.name)
			machine = global.machines[rootName]
			if machine ~= nil and entity ~= nil then
				resource_count = getCount(entity)
				should_have_level = determine_level(resource_count)

				if isRootAlready then
					upgrade_factory(entity.surface, machine.level_name .. math.min(should_have_level, machine.max_level),
						entity)
				elseif machine ~= nil then
					local current_level = tonumber(string.match(entity.name, "%d+$"))
					if current_level == nil then current_level = 1 end
					if (settings.global["factory-levels-disable-mod"].value) or (machine.disable_mod_setting and settings.global[machine.disable_mod_setting].value) then
						upgrade_factory(entity.surface, rootName, entity)
						break
					elseif (should_have_level > current_level and current_level < machine.max_level) then
						upgrade_factory(entity.surface,
							machine.level_name .. math.min(should_have_level, machine.max_level),
							entity)
						break
					elseif (should_have_level > current_level and current_level >= machine.max_level and machine.next_machine ~= nil) then
						local created = upgrade_factory(entity.surface, machine.next_machine, entity)
						created.products_finished = 0
						break
					end
				end
			end
		end
	end
end

function get_next_machine()
	if global.current_machine == nil or global.check_machines == nil then
		global.check_machines = table.deepcopy(global.built_machines)
	end
	global.current_machine = next(global.check_machines, global.current_machine)
end

script.on_nth_tick(6, function(event)
	local assemblers = {}
	for i = 1, 100 do
		get_next_machine()
		if i == 1 and global.current_machine == nil then
			return
		end
		if global.current_machine == nil then
			break
		end
		entity = global.check_machines[global.current_machine]
		if entity and entity.entity and entity.entity.valid then
			table.insert(assemblers, entity.entity)
		else
			global.built_machines[global.current_machine] = nil
		end
	end
	replace_machines(assemblers)
end)

function on_mined_entity(event)
	if (event.entity ~= nil) then
		if event.entity.type == "furnace" then
			if event.entity.products_finished ~= nil and event.entity.products_finished > 0 then
				setStoreCount(global.stored_products_finished_furnaces, event.entity.products_finished)
			end
		elseif event.entity.type == "assembling-machine" then
			if event.entity.products_finished ~= nil and event.entity.products_finished > 0 then
				setStoreCount(global.stored_products_finished_assemblers, event.entity.products_finished)
			end
		elseif event.entity.type == "lab" then
			resource_count = global.built_machines[event.entity.unit_number].research_count
			if resource_count ~= nil and resource_count > 0 then
				setStoreCount(global.stored_research_count, resource_count)
			end
		elseif event.entity.type == "mining-drill" then
			resource_count = global.built_machines[event.entity.unit_number].mining_count
			if resource_count ~= nil and resource_count > 0 then
				setStoreCount(global.stored_mining_count, resource_count)
			end
		end
		global.built_machines[event.entity.unit_number] = nil
	end
end

script.on_event(
	defines.events.on_player_mined_entity,
	on_mined_entity,
	{
		{ filter = "type", type = "assembling-machine" },
		{ filter = "type", type = "furnace" },
		{ filter = "type", type = "lab" },
		{ filter = "type", type = "mining-drill" },
	})

script.on_event(
	defines.events.on_robot_mined_entity,
	on_mined_entity,
	{
		{ filter = "type", type = "assembling-machine" },
		{ filter = "type", type = "furnace" },
		{ filter = "type", type = "lab" },
		{ filter = "type", type = "mining-drill" },
	})

function replace_built_entity(entity, finished_product_count)
	global.built_machines[entity.unit_number] = { entity = entity, unit_number = entity.unit_number }
	local machine = determine_machine(entity)
	if finished_product_count ~= nil then
		local should_have_level = determine_level(finished_product_count)
		if entity.type == "lab" then
			setCount(entity.unit_number, finished_product_count, "research_count")
		elseif entity.type == "mining-drill" then
			setCount(entity.unit_number, finished_product_count, "mining_count")
		else
			entity.products_finished = finished_product_count
		end

		if machine ~= nil then
			local created = upgrade_factory(entity.surface,
				machine.level_name .. math.min(should_have_level, machine.max_level), entity)
			created.products_finished = finished_product_count
		end
	else
		if machine ~= nil ~= entity.name then
			rootName, _ = GetRootNameOfMachine(entity.name)
			upgrade_factory(entity.surface, rootName, entity)
		end
	end
end

function on_built_entity(event)
	if (event.created_entity ~= nil and event.created_entity.type == "assembling-machine") then
		local finished_product_count = table.remove(global.stored_products_finished_assemblers)
		replace_built_entity(event.created_entity, finished_product_count)
		return
	elseif (event.created_entity ~= nil and event.created_entity.type == "furnace") then
		local finished_product_count = table.remove(global.stored_products_finished_furnaces)
		replace_built_entity(event.created_entity, finished_product_count)
		return
	elseif (event.created_entity ~= nil and event.created_entity.type == "lab") then
		local finished_product_count = table.remove(global.stored_research_count)
		replace_built_entity(event.created_entity, finished_product_count)
		return
	elseif (event.created_entity ~= nil and event.created_entity.type == "mining-drill") then
		local finished_product_count = table.remove(global.stored_mining_count)
		replace_built_entity(event.createdentity, finished_product_count)
		return
	end
end

function on_runtime_mod_setting_changed(event)
	if event.setting == "factory-levels-disable-mod" then
		-- Refresh EVERY machine immediately.  User potentially wishes to remove this mod or some other mod that depends on this mod.
		get_built_machines()
	elseif event.setting == "factory-levels-exponent" then
		update_machine_levels(true)
		if required_items_for_levels[25] then
			game.print("Crafts for Level 25: " .. required_items_for_levels[25])
		end
		if required_items_for_levels[50] then
			game.print("Crafts for Level 50: " .. required_items_for_levels[50])
		end
		if required_items_for_levels[100] then
			game.print("Crafts for Level 100: " .. required_items_for_levels[100])
		end
		if max_level ~= 100 then
			game.print("Crafts for Max level of " .. max_level .. ": " .. required_items_for_levels[max_level])
		end
	else
		update_machines = false
		for machine_name, machine in pairs(global.machines) do
			if event.setting == machine.disable_mod_setting then
				update_machines = true
			end
		end
		if update_machines then
			get_built_machines()
		end
	end
end

script.on_event(
	defines.events.on_research_finished,
	function(data)
		for _, machine in pairs(global.built_machines) do
			if machine.entity.type == "lab" then
				if machine.research_count == nil then
					machine.research_count = data.research.research_unit_count
				else
					machine.research_count = machine.research_count + data.research.research_unit_count
				end
			end
		end
	end
)

script.on_event(
	defines.events.on_robot_built_entity,
	on_built_entity,
	{
		{ filter = "type", type = "assembling-machine" },
		{ filter = "type", type = "furnace" },
		{ filter = "type", type = "lab" },
		{ filter = "type", type = "mining-drill" }
	})

script.on_event(
	defines.events.on_built_entity,
	on_built_entity,
	{
		{ filter = "type", type = "assembling-machine" },
		{ filter = "type", type = "furnace" },
		{ filter = "type", type = "lab" },
		{ filter = "type", type = "mining-drill" },
	})

script.on_event(
	defines.events.on_runtime_mod_setting_changed,
	on_runtime_mod_setting_changed)
