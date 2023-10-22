require("__" .. "xp-for-buildings" .. "__.mmddata")
local buildings = {}

function buildings.tryUpdate_machine_speed(machine, level, speed_multiplier)
	if machine.crafting_speed ~= nil then
		machine.crafting_speed = machine.crafting_speed + level * speed_multiplier
	elseif machine.mining_speed ~= nil then
		machine.mining_speed = machine.mining_speed + level * speed_multiplier
	elseif machine.researching_speed ~= nil then
		machine.researching_speed = machine.researching_speed + level * speed_multiplier
	end
end

function buildings.tryUpdate_machine_energy_usage(machine, level, base_usage, usage_multiplier, energy_unit)
	if machine.energy_usage ~= nil then
		machine.energy_usage = (base_usage + usage_multiplier * level) .. energy_unit
	end
end

function buildings.tryUpdate_machine_pollution(machine, level, base_emission, emission_multiplier)
	if machine.energy_source ~= nil then
		machine.energy_source.emissions_per_minute = base_emission + emission_multiplier * level
	end
end

function buildings.Try_update_health(machine, level)
	if machine.max_health ~= nil then
		machine.max_health = machine.max_health + (machine.max_health / 100 + Max_health_multiplier) * level
	end
end

function buildings.Try_update_weaponParams(machine, level)
	if machine.attack_parameters ~= nil then
		machine.attack_parameters.cooldown = machine.attack_parameters.cooldown - (0.02 * level)
		local damage = 0.98
		if machine.attack_parameters.damage_modifier ~= nil then damage = machine.attack_parameters.damage_modifier end
		machine.attack_parameters.damage_modifier = damage + (Damage_multiplier * level)
		local lastRange = machine.attack_parameters.range + Max_range_for_turrets
		local range = machine.attack_parameters.range + Range_multiplier * level
		if range > lastRange then
			range = lastRange
		end
		machine.attack_parameters.range = range
	end
end

function buildings.Try_update_machine_productivity(machine, level, base_productivity, productivity_multiplier)
	machine.base_productivity = base_productivity + productivity_multiplier * level
end

function buildings.Try_update_machine_module_slots(machine, level, levels_per_module_slot, base_module_slots,
												   module_slot_bonus)
	machine.module_specification = {
		module_slots = base_module_slots + (math.floor(level / levels_per_module_slot) * module_slot_bonus) }
end

function buildings.update_animation_tint(animation, tint)
	if animation == nil then
		return
	end

	if animation.north then
		buildings.update_animation_tint(animation.north, tint)
		buildings.update_animation_tint(animation.east, tint)
		buildings.update_animation_tint(animation.west, tint)
		buildings.update_animation_tint(animation.south, tint)
		return
	end

	if animation.layers then
		for _, layer in pairs(animation.layers) do
			buildings.update_animation_tint(layer, tint)
		end
	end
	if animation.hr_version then
		buildings.update_animation_tint(animation.hr_version, tint)
	end
	animation.tint = tint
end

function buildings.update_machine_tint(machine, level)
	multiplier = level
	base_tint = { r = 1, g = 1, b = 1 }
	if level <= 25 then
		baseTintR = -0.02
		baseTintG = -0.02
		baseTintB = 0
	elseif level <= 50 then
		baseTintR = 0
		baseTintG = 0
		baseTintB = -0.016
		multiplier = level - 25
	elseif level <= 75 then
		baseTintR = 0
		baseTintG = 0
		baseTintB = -0.02
		multiplier = level - 50
	else
		baseTintR = 0
		baseTintG = -0.008
		baseTintB = -0.008
		multiplier = level - 75
	end

	local tint = {
		r = base_tint.r + multiplier * baseTintR,
		g = base_tint.g + multiplier * baseTintG,
		b = base_tint.b + multiplier * baseTintB,
		a = 1
	}

	buildings.update_animation_tint(machine.animation, tint)

	-- Some machines, such as centrigue put their main animation set into idle_animation.
	buildings.update_animation_tint(machine.idle_animation, tint)
end

function buildings.get_or_create_machine(machine_type, base_machine_name, level, max_level)
	local base_machine = data.raw[machine_type][base_machine_name]

	if base_machine == nil then
		return nil
	end

	if level == 0 then
		return base_machine
	end

	local new_machine_name = base_machine_name .. "-level-" .. level

	if data.raw[base_machine.type][new_machine_name] == nil then
		local base_machine = data.raw[machine_type][base_machine_name]
		if base_machine == nil then
			return nil
		end
		local machine = table.deepcopy(base_machine)
		machine.name = new_machine_name
		if Force_Effects_On_Entities then
			machine.allowed_effects = { "consumption", "speed", "productivity", "pollution" }
		end

		if machine.type == "ammo-turret" then
			for key, value in pairs(TechnologyUpdate) do
				local ref = value[1]
				if ref ~= nil and ref.turret_id == base_machine_name then
					table.insert(data.raw["technology"][key].effects,
						{ type = ref.type, turret_id = new_machine_name, modifier = ref.modifier, })
				end
			end
		end

		data:extend({ machine })
	end
	local new_machine = data.raw[base_machine.type][new_machine_name]
	if DiscoScience and DiscoScience.prepareLab then
		DiscoScience.prepareLab(new_machine)
	end
	return new_machine
end

function buildings.create_leveled_machines(metadata)
	for tier = 1, metadata.tiers, 1 do
		for level = 1, metadata.levels[tier], 1 do
			local max_level = metadata.levels[tier]
			local machine = buildings.get_or_create_machine(metadata.type, metadata.base_machine_names[tier], level,
				max_level)

			if level > 0 then
				machine.flags = machine.flags or { "placeable-neutral", "placeable-player", "player-creation" }
				local hidden = false

				for _, flag in pairs(machine.flags) do
					if flag == "hidden" then
						hidden = false
						break
					end
				end

				if not hidden then
					table.insert(machine.flags, "hidden")
				end

				if machine.miniable ~= nil then
					machine.minable.result = metadata.item[tier]
				end

				machine.placeable_by = { item = metadata.item[tier], count = 1 }
				machine.localised_name = { "entity-name.exp_for_buildings",
					{ "entity-name." .. metadata.base_machine_names[tier] }, level }
				machine.localised_description = { "entity-description." .. metadata.base_machine_names[tier] }
			end

			buildings.tryUpdate_machine_speed(machine, level,
				metadata.speed_multipliers[tier])

			buildings.tryUpdate_machine_energy_usage(machine, level, metadata.base_consumption[tier],
				metadata.energy_multiplier[tier], metadata.consumption_unit[tier])

			buildings.tryUpdate_machine_pollution(machine, level, metadata.base_pollution[tier],
				metadata.pollution_multipliers[tier])

			buildings.Try_update_machine_productivity(machine, level, metadata.base_productivity[tier],
				metadata.productivity_multipliers[tier])

			buildings.Try_update_weaponParams(machine, level)

			buildings.Try_update_health(machine, level)


			buildings.Try_update_machine_module_slots(machine, level, metadata.levels_per_module_slots[tier],
				metadata.base_module_slots[tier], metadata.bonus_module_slots[tier])

			buildings.update_machine_tint(machine, level)
			if IsDebug then
				mmddata.qtd = mmddata.qtd + 1
			end
		end
	end
end

function buildings.fix_productivity(machines)
	for tier = 1, machines.tiers, 1 do
		for level = 0, machines.levels[tier], 1 do
			local machine = buildings.get_or_create_machine(machines.type, machines.base_machine_names[tier], level,
				machines.levels[tier])
			if machine.base_productivity == 0 or machine.base_productivity == nil then
				buildings.Try_update_machine_productivity(machine, level, machines.base_productivity[tier],
					machines.productivity_multipliers[tier])
			end
		end
	end
end

return buildings
