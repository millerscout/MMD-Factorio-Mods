require("util")
require("__" .. "xp-for-buildings" .. "__.util_mmd")
require("__" .. "xp-for-buildings" .. "__.mmddata")
require("__" .. "xp-for-buildings" .. "__.patches")

function CalculateExpForMining(entity)
	local resources = entity.surface.find_entities_filtered { position = { entity.position.x, entity.position.y }, radius =
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

function GetCount(entity)
	if entity.type == "lab" then
		return global.built_machines[entity.unit_number].research_count
	elseif entity.type == "mining-drill" then
		return CalculateExpForMining(entity)
	elseif entity.type == "ammo-turret" then
		return entity.damage_dealt
	else
		return entity.products_finished
	end
end

function SetCount(unit_number, count, name)
	global.built_machines[unit_number][name] = count
end

function UpdateCount(old_unit_number, new_unit_number, name)
	xpCount = 0
	if global.built_machines[old_unit_number] ~= nil and global.built_machines[old_unit_number][name] ~= nil then
		xpCount = global.built_machines[old_unit_number][name]
	end
	global.built_machines[new_unit_number][name] = xpCount
end

function SetStoreCount(type, count, level)
	table.insert(global.ExpTable[type], { level = level, xpCount = count })
end

function SetupLevelForEntities()
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
				if machines[rootName].max_level ~= Max_level then
					machines[rootName].max_level = machines[rootName].max_level + 1
				end
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
	AddEntitiesToDiscoScience()
end)

script.on_load(function()
	if XpCountRequiredForLevel == nil then
		Update_machine_levels(true)
	end

	if XpCountRequiredForLevelPerType["assembling-machine"] == nil then
		Update_machine_levels_for_type("assembling-machine", true)
	end
	if XpCountRequiredForLevelPerType["furnace"] == nil then
		Update_machine_levels_for_type("furnace", true)
	end
end)
script.on_configuration_changed(function()
	SetupOnChange()
	AddEntitiesToDiscoScience()
end)


local needsUpdate = true
function RunPatches()
	if needsUpdate then
		needsUpdate = false
		if global.mmd_patch ~= #Patches then
			if global.mmd_patch == nil then global.mmd_patch = 0 end
			for i = global.mmd_patch + 1, #Patches, 1 do
				Patches[i]()
			end
			for key, value in pairs(aa) do
				game.print(key .. "__" .. value)
			end
		end
		global.mmd_patch = #Patches
	end
end

function SetupOnChange()
	global.machines = nil
	baseExp = settings.global["exp_for_buildings-baseExp"].value
	baseExp_for_assemblies = settings.global["exp_for_buildings-baseExp_for_assemblies"].value
	baseExp_for_furnaces = settings.global["exp_for_buildings-baseExp_for_furnaces"].value
	multiplier = settings.global["exp_for_buildings-multiplier"].value
	divisor = settings.global["exp_for_buildings-divisor"].value
	revert_levels = settings.global["exp_for_buildings_revert_levels"].value

	SetupLevelForEntities()
	UpdateLevelCalculation(true)

	Get_built_machines()
end

function Get_built_machines()
	global.built_machines = global.built_machines or {}
	for unit_number, machine in pairs(global.built_machines) do
		if not machine.entity or not machine.entity.valid then
			global.built_machines[unit_number] = nil
		end
	end
	local built_assemblers = {}
	for _, surface in pairs(game.surfaces) do
		local entities = surface.find_entities_filtered { type = EnabledTypes }
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
		local start, _ = string.find(str, '-level-', 1, true)
		local refName = string.sub(str, 0, start - 1)
		return refName, false
	else
		return str, true
	end
end

local baseExp = settings.global["exp_for_buildings-baseExp"].value
local baseExp_for_assemblies = settings.global["exp_for_buildings-baseExp_for_assemblies"].value
local baseExp_for_furnaces = settings.global["exp_for_buildings-baseExp_for_furnaces"].value
local multiplier = settings.global["exp_for_buildings-multiplier"].value
local divisor = settings.global["exp_for_buildings-divisor"].value
local revert_levels = settings.global["exp_for_buildings_revert_levels"].value

function Update_machine_levels(overwrite)
	local lastExp = 0
	for i = 1, (Max_level), 1 do
		lastExp = lastExp + baseExp * multiplier * i / divisor
		if XpCountRequiredForLevel[i] == nil then
			table.insert(XpCountRequiredForLevel, lastExp)
		elseif overwrite then
			XpCountRequiredForLevel[i] = lastExp
		end
	end
end

function Update_machine_levels_for_type(type, overwrite)
	local lastExp = 0
	local exp = 0
	if type == "furnace" then
		exp = baseExp_for_furnaces
	elseif type == "assembling-machine" then
		exp = baseExp_for_assemblies
	end
	for i = 1, (Max_level), 1 do
		lastExp = lastExp + exp * multiplier * i / divisor
		if XpCountRequiredForLevelPerType[type] == nil then XpCountRequiredForLevelPerType[type] = {} end
		if XpCountRequiredForLevelPerType[type][i] == nil then
			table.insert(XpCountRequiredForLevelPerType[type], lastExp)
		elseif overwrite then
			XpCountRequiredForLevelPerType[type][i] = lastExp
		end
	end
end

function UpdateLevelCalculation(force)
	Update_machine_levels(force)
	Update_machine_levels_for_type("assembling-machine", force)
	Update_machine_levels_for_type("furnace", force)
end

remote.add_interface("factory_levels", {
	add_machine = function(machine)
		if machine.name == nil or machine.level_name == nil or machine.max_level == nil then
			return false
		else
			global.machines[machine.name] = machine
			if machine.max_level > Max_level then
				Max_level = machine.max_level
				UpdateLevelCalculation(false)
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

			if global.machines[machine.name].max_level > Max_level then
				Max_level = global.machines[machine.name].max_level
				Update_machine_levels()
				Update_machine_levels_for_type("assembling-machine")
				Update_machine_levels_for_type("furnace")
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

XpCountRequiredForLevel = {
}
XpCountRequiredForLevelPerType = {
}

UpdateLevelCalculation(true)

function Determine_level(level, type, xpCount)
	if level >= Max_level then return Max_level end
	if level == nil then level = 0 end
	if global.machines == nil then SetupLevelForEntities() end
	if xpCount == nil then
		xpCount = 0
	end

	if XpCountRequiredForLevelPerType[type] ~= nil then
		if xpCount >= XpCountRequiredForLevelPerType[type][level + 1] then
			return Determine_level(level + 1, type, xpCount)
		end
	elseif xpCount >= XpCountRequiredForLevel[level + 1] then
		return Determine_level(level + 1, type, xpCount)
	end
	return level
end

function Get_inventory_contents(inventory)
	local inventory_results = {}
	if inventory == nil then
		return inventory_results
	end

	local inventory_contents = inventory.get_contents()
	for name, count in pairs(inventory_contents) do
		table.insert(inventory_results, { name = name, count = count })
	end
	return inventory_results
end

function Insert_inventory_contents(inventory, contents)
	if inventory == nil or not inventory.is_empty() then
		return
	end
	for _, item in pairs(contents) do
		inventory.insert(item)
	end
end

function Upgrade_entity(surface, targetname, sourceentity)
	if SkippedEntities[targetname] ~= nil then return end
	local unit_number = sourceentity.unit_number
	local xpCount = GetCount(sourceentity)

	local box = sourceentity.bounding_box
	local item_requests = nil
	local recipe = nil
	if revert_levels then
		targetname, _ = GetRootNameOfMachine(targetname)
	end

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
		input_inventory = Get_inventory_contents(sourceentity.get_inventory(defines.inventory.assembling_machine_input))
	elseif sourceentity.type == "furnace" then
		input_inventory = Get_inventory_contents(sourceentity.get_inventory(defines.inventory.furnace_source))
	end
	local output_inventory = Get_inventory_contents(sourceentity.get_output_inventory())
	local module_inventory = Get_inventory_contents(sourceentity.get_module_inventory())
	local fuel_inventory = Get_inventory_contents(sourceentity.get_fuel_inventory())
	local burnt_result_inventory = Get_inventory_contents(sourceentity.get_burnt_result_inventory())


	if sourceentity.type == "assembling-machine" then
		-- Recipe should survive, but why take that chance.
		recipe = sourceentity.get_recipe()
	end
	-- direction not working (Bug? bug to bi-bio)
	local direction = sourceentity.direction
	local orientation = sourceentity.orientation
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

	if created == nil then
		return
	end
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
		UpdateCount(unit_number, created.unit_number, "research_count")
	elseif created.type == "mining-drill" then
		UpdateCount(unit_number, created.unit_number, "mining_count")
	elseif created.type == "ammo-turret" then
		created.damage_dealt = xpCount
	else
		created.products_finished = xpCount;
	end
	sourceentity.destroy({ raise_destroy = true })
	global.built_machines[unit_number] = nil
	if created.type == "assembling-machine" and recipe ~= nil then
		created.set_recipe(recipe)
	end

	if created.type == "assembling-machine" then
		Insert_inventory_contents(created.get_inventory(defines.inventory.assembling_machine_input), input_inventory)
	elseif created.type == "furnace" then
		Insert_inventory_contents(created.get_inventory(defines.inventory.furnace_source), input_inventory)
	end

	Insert_inventory_contents(created.get_output_inventory(), output_inventory)
	Insert_inventory_contents(created.get_module_inventory(), module_inventory)
	Insert_inventory_contents(created.get_fuel_inventory(), fuel_inventory)
	Insert_inventory_contents(created.get_burnt_result_inventory(), burnt_result_inventory)

	local old_on_ground = surface.find_entities_filtered { area = box, name = 'item-on-ground' }
	for _, item in pairs(old_on_ground) do
		item.destroy({ raise_destroy = true })
	end
	created.orientation = orientation
	created.direction = direction
	return created
end

function replace_machines(entities)
	if global.machines ~= nil then
		for _, entity in pairs(entities) do
			metadata = global.built_machines[entity.unit_number]
			machine = global.machines[metadata.rootName]
			if machine ~= nil and entity ~= nil and not revert_levels then
				xpCount = GetCount(entity)

				should_have_level = Determine_level(metadata.level, entity.type, xpCount)

				local text = math.min(should_have_level, machine.max_level)

				if machine ~= nil and should_have_level > 0 then
					if metadata.level ~= should_have_level then
						if (should_have_level > metadata.level and metadata.level < machine.max_level) then
							created = Upgrade_entity(entity.surface,
								machine.level_name .. text,
								entity)
							global.built_machines[created.unit_number].level = should_have_level
							break
						elseif (should_have_level > metadata.level and metadata.level >= machine.max_level and machine.next_machine ~= nil) then
							local created = Upgrade_entity(entity.surface, machine.next_machine, entity)
							created.products_finished = 0
							global.built_machines[entity.unit_number].level = should_have_level
							break
						end
					end
				end
			elseif revert_levels then
				if metadata.rootName == nil then
					metadata.rootName, _ = GetRootNameOfMachine(entity.name)
				end
				if entity.name ~= metadata.rootName then
					Upgrade_entity(entity.surface, metadata.rootName, entity)
				end
			end
		end
	end
end

function Get_next_machine()
	if global.current_machine == nil or global.check_machines == nil then
		global.check_machines = table.deepcopy(global.built_machines)
	end
	global.current_machine = next(global.check_machines, global.current_machine)
end

script.on_nth_tick(30, function(event)
	RunPatches()

	local assemblers = {}
	for i = 1, 500 do
		Get_next_machine()
		if i == 1 and global.current_machine == nil then
			return
		end
		if global.current_machine == nil then
			break
		end
		local entity = global.check_machines[global.current_machine]
		if entity and entity.entity and entity.entity.valid then
			table.insert(assemblers, entity.entity)
		else
			global.built_machines[global.current_machine] = nil
		end
	end
	replace_machines(assemblers)
end)

function On_mined_entity(event)
	if (event.entity ~= nil) then
		if global.built_machines[event.entity.unit_number] ~= nil then
			local machine = global.built_machines[event.entity.unit_number]
			local level   = machine.level
			if event.entity.type == "furnace" then
				if event.entity.products_finished ~= nil and event.entity.products_finished > 0 then
					SetStoreCount(event.entity.type, event.entity.products_finished, level)
				end
			elseif event.entity.type == "assembling-machine" then
				if event.entity.products_finished ~= nil and event.entity.products_finished > 0 then
					SetStoreCount(event.entity.type, event.entity.products_finished, level)
				end
			elseif event.entity.type == "lab" then
				xpCount = machine.research_count
				if xpCount ~= nil and xpCount > 0 then
					SetStoreCount(event.entity.type, xpCount, level)
				end
			elseif event.entity.type == "mining-drill" then
				if machine ~= nil then
					xpCount = machine.mining_count
					if xpCount ~= nil and xpCount > 0 then
						SetStoreCount(event.entity.type, xpCount, level)
					end
				end
			elseif event.entity.type == "ammo-turret" then
				xpCount = event.entity.damage_dealt
				if xpCount ~= nil and xpCount > 0 then
					SetStoreCount(event.entity.type, xpCount, level)
				end
			end
			global.built_machines[event.entity.unit_number] = nil
		end
	end
end

script.on_event(
	defines.events.on_player_mined_entity,
	On_mined_entity,
	EnabledFilters)

script.on_event(
	defines.events.on_robot_mined_entity,
	On_mined_entity,
	EnabledFilters)

script.on_event(defines.events.on_player_changed_surface, function(pi, si, name, tick)
	Get_built_machines()
end)

function Replace_built_entity(entity)
	if SkippedEntities[entity.name] ~= nil then return end
	if SkippedEntities[GetRootNameOfMachine(entity.name)] ~= nil then return end

	SortExpTable(entity.type)
	local expTable = table.remove(global.ExpTable[entity.type])
	local machine = global.machines[GetRootNameOfMachine(entity.name)]

	if expTable == nil then
		expTable = { level = 0, xpCount = 0 }
	end
	global.built_machines[entity.unit_number] = {
		entity = entity,
		unit_number = entity.unit_number,
		rootName = GetRootNameOfMachine(entity.name),
		level = expTable.level
	}
	if expTable.xpCount ~= nil and machine ~= nil and not revert_levels then
		local should_have_level = Determine_level(global.built_machines[entity.unit_number].level, entity.type,
			expTable.xpCount)

		if entity.type == "lab" then
			SetCount(entity.unit_number, expTable.xpCount, "research_count")
		elseif entity.type == "mining-drill" then
			SetCount(entity.unit_number, expTable.xpCount, "mining_count")
		elseif entity.type == "ammo-turret" then
			if entity.damage_dealt == nil or entity.damage_dealt == 0 then
				entity.damage_dealt = expTable.xpCount
			end
		else
			entity.products_finished = expTable.xpCount
		end

		if should_have_level > 0 then
			local text = math.min(should_have_level, machine.max_level)

			local created = Upgrade_entity(entity.surface,
				machine.level_name .. text, entity)
		end
	else
		Upgrade_entity(entity.surface, GetRootNameOfMachine(entity.name), entity)
	end
end

function On_built_entity(event)
	if (event.created_entity ~= nil and global.ExpTable[event.created_entity.type] ~= nil) then
		Replace_built_entity(event.created_entity)
		return
	end
end

function On_runtime_mod_setting_changed(event)
	baseExp = settings.global["exp_for_buildings-baseExp"].value
	baseExp_for_assemblies = settings.global["exp_for_buildings-baseExp_for_assemblies"].value
	baseExp_for_furnaces = settings.global["exp_for_buildings-baseExp_for_furnaces"].value
	multiplier = settings.global["exp_for_buildings-multiplier"].value
	divisor = settings.global["exp_for_buildings-divisor"].value
	revert_levels = settings.global["exp_for_buildings_revert_levels"].value

	global.machines = nil


	if event.setting == "exp_for_buildings-baseExp" or event.setting == "exp_for_buildings-multiplier" or
		event.setting == "exp_for_buildings-divisor" or event.setting == "exp_for_buildings-baseExp_for_assemblies" or event.setting == "exp_for_buildings-baseExp_for_furnaces" then
		UpdateLevelCalculation(true)
		for i = 1, #XpCountRequiredForLevel, 1 do
			game.print("Exp for Level " .. i .. ": " .. XpCountRequiredForLevel[i])
		end

		if Max_level ~= Max_level then
			game.print("Exp for Max level of " .. Max_level .. ": " .. XpCountRequiredForLevel[Max_level])
		end
	end
	SetupLevelForEntities()
	if revert_levels then
		Get_built_machines()
	end
end

script.on_event(
	defines.events.on_research_finished,
	function(data)
		if not data.by_script then
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
	end
)

script.on_event(
	defines.events.on_robot_built_entity,
	On_built_entity,
	EnabledFilters)

script.on_event(
	defines.events.on_built_entity,
	On_built_entity,
	EnabledFilters)

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
	On_runtime_mod_setting_changed)
