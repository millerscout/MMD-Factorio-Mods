require("util")
local enabledTypes = { "assembling-machine", "furnace", "lab", "mining-drill", "ammo-turret" }
local enabledFilters = {}
for _, key in pairs(enabledTypes) do
	table.insert(enabledFilters, { filter = "type", type = key })
end
function calculateExpForMining(entity)
	resources = entity.surface.find_entities_filtered { position = { entity.position.x, entity.position.y }, radius =
		math.ceil(entity.prototype.mining_drill_radius), type = "resource" }
	local resource_count = 0
	local mining_count = 0
	for key, value in pairs(resources) do
		resource_count = resource_count + value.amount
	end
	if global.built_machines[entity.unit_number].mining_count ~= nil then
		mining_count = global.built_machines[entity.unit_number].mining_count
	end
	if global.built_machines[entity.unit_number].resource_count == nil then
		global.built_machines[entity.unit_number].resource_count = resource_count
	else
		collected = global.built_machines[entity.unit_number].resource_count - resource_count
		global.built_machines[entity.unit_number].resource_count = resource_count
		mining_count = mining_count + collected
	end
	global.built_machines[entity.unit_number].mining_count = mining_count
	return mining_count
end

function getCount(entity)
	if entity.type == "lab" then
		return global.built_machines[entity.unit_number].research_count
	elseif entity.type == "mining-drill" then
		return calculateExpForMining(entity)
	elseif entity.type == "ammo-turret" then
		return entity.damage_dealt
	else
		return entity.products_finished
	end
end

function setCount(unit_number, count, name)
	global.built_machines[unit_number][name] = count
end

function updateCount(old_unit_number, new_unit_number, name)
	xpCount = 0
	if global.built_machines[old_unit_number] ~= nil and global.built_machines[old_unit_number][name] ~= nil then
		xpCount = global.built_machines[old_unit_number][name]
	end
	global.built_machines[new_unit_number][name] = xpCount
end

function setStoreCount(tab, count)
	table.insert(tab, count)
	table.sort(tab)
end

function setupLevelForEntities()
	if global.machines == nil then
		global.machines = {}
		local machines = {}
		for key, _ in pairs(game.entity_prototypes) do
			local rootName, _ = GetRootNameOfMachine(key)

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
	SetupOnChange()
end)

script.on_load(function()
	if global.machines == nil then
		global.reset = true
		script.on_nth_tick(60, function()
			setupLevelForEntities()
			get_built_machines()
		end)
	end
	for key, value in pairs(global.built_machines) do
		if value.rootName == nil then

		end
	end
end)
script.on_configuration_changed(function()
	SetupOnChange()
end)

function SetupOnChange()
	global.machines = nil
	setupLevelForEntities()

	get_built_machines()

	if global.stored_products_finished_assemblers == nil then
		global.stored_products_finished_assemblers = {}
	end
	if global.stored_products_finished_furnaces == nil then
		global.stored_products_finished_furnaces = {}
	end
	if global.stored_research_count == nil then
		global.stored_research_count = {}
	end
	if global.stored_mining_count == nil then
		global.stored_mining_count = {}
	end
	if global.stored_damage_dealt == nil then
		global.stored_damage_dealt = {}
	end
end

function get_built_machines()
	global.built_machines = global.built_machines or {}
	for unit_number, machine in pairs(global.built_machines) do
		if not machine.entity or not machine.entity.valid then
			global.built_machines[unit_number] = nil
		end
	end
	local built_assemblers = {}
	for _, surface in pairs(game.surfaces) do
		local entities = surface.find_entities_filtered { type = enabledTypes }
		for _, entity in pairs(entities) do
			if not global.built_machines[entity.unit_number] then
				local rootName = GetRootNameOfMachine(entity.name)
				local current_level = tonumber(string.match(entity.name, "%d+$"))
				if current_level == nil then
					current_level = 0
				end
				global.built_machines[entity.unit_number] = {
					entity = entity,
					unit_number = entity.unit_number,
					level = current_level,
					rootName = rootName
				}
			end
			table.insert(built_assemblers, entity)
		end
	end
	replace_machines(built_assemblers)
end

function GetRootNameOfMachine(str)
	if string.find(str, '-level-') then
		start, _ = string.find(str, '-level-', 1, true)
		rootName = string.sub(str, 0, start - 1)
		return rootName, false
	else
		return str, true
	end
end

max_level = 100
function update_machine_levels(overwrite)
	local baseExp = settings.global["exp_for_buildings-baseExp"].value
	local multiplier = settings.global["exp_for_buildings-multiplier"].value
	local divisor = settings.global["exp_for_buildings-divisor"].value

	local lastExp = 0
	for i = 1, (max_level), 1 do
		lastExp = lastExp + baseExp * multiplier * i / divisor
		if xpCountRequiredForLevel[i] == nil then
			table.insert(xpCountRequiredForLevel, lastExp)
		elseif overwrite then
			xpCountRequiredForLevel[i] = lastExp
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

xpCountRequiredForLevel = {
}

update_machine_levels(true)

function determine_level(metadata, xpCount)
	if metadata.level == 100 then return 100 end
	if xpCount == nil then
		xpCount = 0
	end

	if xpCount >= xpCountRequiredForLevel[metadata.level + 1] then
		return metadata.level + 1
	else
		return metadata.level
	end
end

function determine_machine(entity)
	if settings.global["factory-levels-disable-mod"].value then
		return nil
	end
	if entity == nil or not entity.valid or (entity.type ~= "assembling-machine" and entity.type ~= "furnace") then
		return nil
	end
	rootName, _ = GetRootNameOfMachine(entity.name)
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
	xpCount = getCount(sourceentity)

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

	global.built_machines[created.unit_number] = {
		entity = created,
		unit_number = created.unit_number,
		rootName = global.built_machines[unit_number].rootName,
		level = global.built_machines[unit_number].level
	}

	
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
	elseif created.type == "ammo-turret" then
		created.damage_dealt = xpCount
	else
		created.products_finished = xpCount;
	end
	sourceentity.destroy()
	global.built_machines[unit_number] = nil
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
			metadata = global.built_machines[entity.unit_number]
			machine = global.machines[metadata.rootName]
			if machine ~= nil and entity ~= nil then
				xpCount = getCount(entity)
				should_have_level = determine_level(metadata, xpCount)

				if machine ~= nil and should_have_level > 0 then
					if metadata.level ~= should_have_level then
						if (should_have_level > metadata.level and metadata.level < machine.max_level) then
							created = upgrade_factory(entity.surface,
								machine.level_name .. math.min(should_have_level, machine.max_level),
								entity)
							global.built_machines[created.unit_number].level = should_have_level
							break
						elseif (should_have_level > metadata.level and metadata.level >= machine.max_level and machine.next_machine ~= nil) then
							local created = upgrade_factory(entity.surface, machine.next_machine, entity)
							created.products_finished = 0
							global.built_machines[entity.unit_number].level = should_have_level
							break
						end
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

script.on_nth_tick(30, function(event)
	local assemblers = {}
	for i = 1, 500 do
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
			xpCount = global.built_machines[event.entity.unit_number].research_count
			if xpCount ~= nil and xpCount > 0 then
				setStoreCount(global.stored_research_count, xpCount)
			end
		elseif event.entity.type == "mining-drill" then
			xpCount = global.built_machines[event.entity.unit_number].mining_count
			if xpCount ~= nil and xpCount > 0 then
				setStoreCount(global.stored_mining_count, xpCount)
			end
		elseif event.entity.type == "ammo-turret" then
			xpCount = event.entity.damage_dealt
			if xpCount ~= nil and xpCount > 0 then
				setStoreCount(global.stored_damage_dealt, xpCount)
			end
		end
		global.built_machines[event.entity.unit_number] = nil
	end
end

script.on_event(
	defines.events.on_player_mined_entity,
	on_mined_entity,
	enabledFilters)

script.on_event(
	defines.events.on_robot_mined_entity,
	on_mined_entity,
	enabledFilters)

function replace_built_entity(entity, count)
	global.built_machines[entity.unit_number] = {
		entity = entity,
		unit_number = entity.unit_number,
		rootName = entity.name,
		level = 0
	}
	local machine = global.machines[entity.name]
	if count ~= nil and machine ~= nil then
		local should_have_level = determine_level(global.built_machines[entity.unit_number], count)
		if entity.type == "lab" then
			setCount(entity.unit_number, count, "research_count")
		elseif entity.type == "mining-drill" then
			setCount(entity.unit_number, count, "mining_count")
		elseif entity.type == "ammo-turret" then
			setCount(entity.unit_number, count, "damage_dealt")
		else
			entity.products_finished = count
		end
		if should_have_level > 0 then
			local created = upgrade_factory(entity.surface,
				machine.level_name .. math.min(should_have_level, machine.max_level), entity)
		end
	else
		upgrade_factory(entity.surface, entity.name, entity)
	end
end

function on_built_entity(event)
	if (event.created_entity ~= nil and event.created_entity.type == "assembling-machine") then
		local count = table.remove(global.stored_products_finished_assemblers)
		replace_built_entity(event.created_entity, count)
		return
	elseif (event.created_entity ~= nil and event.created_entity.type == "furnace") then
		local count = table.remove(global.stored_products_finished_furnaces)
		replace_built_entity(event.created_entity, count)
		return
	elseif (event.created_entity ~= nil and event.created_entity.type == "lab") then
		local count = table.remove(global.stored_research_count)
		replace_built_entity(event.created_entity, count)
		return
	elseif (event.created_entity ~= nil and event.created_entity.type == "mining-drill") then
		local count = table.remove(global.stored_mining_count)
		replace_built_entity(event.created_entity, count)
		return
	elseif (event.created_entity ~= nil and event.created_entity.type == "ammo-turret") then
		local count = table.remove(global.stored_damage_dealt)
		replace_built_entity(event.created_entity, count)
		return
	end
end

function on_runtime_mod_setting_changed(event)
	if event.setting == "exp_for_buildings-baseExp" or event.setting == "exp_for_buildings-multiplier" or
		event.setting == "exp_for_buildings-divisor" then
		update_machine_levels(true)
		if xpCountRequiredForLevel[1] then
			game.print("Exp for Level 1: " .. xpCountRequiredForLevel[1])
		end
		if xpCountRequiredForLevel[25] then
			game.print("Exp for Level 25: " .. xpCountRequiredForLevel[25])
		end
		if xpCountRequiredForLevel[50] then
			game.print("Exp for Level 50: " .. xpCountRequiredForLevel[50])
		end
		if xpCountRequiredForLevel[100] then
			game.print("Exp for Level 100: " .. xpCountRequiredForLevel[100])
		end
		if max_level ~= 100 then
			game.print("Exp for Max level of " .. max_level .. ": " .. xpCountRequiredForLevel[max_level])
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
	enabledFilters)

script.on_event(
	defines.events.on_built_entity,
	on_built_entity,
	filters)

script.on_event(defines.events.on_gui_closed, function(event)
	if event.entity ~= nil then
		metadata = global.built_machines[event.entity.unit_number]
		if metadata ~= nil then
			if event.entity.type == "lab" and metadata.research_count ~= nil then
				event.entity.surface.create_entity { name = "flying-text", position = event.entity.position, text =
					metadata.research_count .. "xp" }
			elseif event.entity.type == "mining-drill" and metadata.mining_count ~= nil then
				event.entity.surface.create_entity { name = "flying-text", position = event.entity.position, text =
					metadata.mining_count .. "xp" }
			end
		end
	end
end)
script.on_event(
	defines.events.on_runtime_mod_setting_changed,
	on_runtime_mod_setting_changed)
