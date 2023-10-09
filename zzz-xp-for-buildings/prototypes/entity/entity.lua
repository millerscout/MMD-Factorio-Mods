if mods["space-exploration"] then
	table.insert(data.raw["assembling-machine"]["chemical-plant"].crafting_categories, "melting")
end

if mods["space-exploration"] then
	table.insert(data.raw["furnace"]["stone-furnace"].crafting_categories, "kiln")
	table.insert(data.raw["furnace"]["steel-furnace"].crafting_categories, "kiln")
	table.insert(data.raw["furnace"]["electric-furnace"].crafting_categories, "kiln")
end


if mods["angelspetrochem"] then
	electrolyzer_levels = {
		type = "assembling-machine",
		tiers = 4,
		base_machine_names = { "angels-electrolyser", "angels-electrolyser-2", "angels-electrolyser-3",
			"angels-electrolyser-4" },
		levels = { 25, 25, 25, 100 },
		base_speeds = { 1, 1.5, 2, 2.5 },
		speed_multipliers = { 0.02, 0.02, 0.02, 0.025 },
		base_consumption = { 300, 350, 400, 450 },
		consumption_multipliers = { 2, 2, 2, 2 },
		consumption_unit = { "kW", "kW", "kW", "kW" },
		base_pollution = { 1.2, 1.8, 2.4, 3 },
		pollution_multipliers = { 0.1, 0.1, 0.1, 0.2 },
		base_productivity = { 0, 0, 0, 0 },
		productivity_multipliers = { 0.002, 0.002, 0.002, 0.002 },
		levels_per_module_slots = { 25, 25, 25, 25 },
		base_module_slots = { 2, 2, 2, 2 },
		bonus_module_slots = { 0, 0, 0, 1 }
	}
end

if mods["angelsbioprocessing"] then
	algaefarm_levels = {
		type = "assembling-machine",
		tiers = 4,
		base_machine_names = { "algae-farm", "algae-farm-2", "algae-farm-3", "algae-farm-4" },
		levels = { 25, 25, 25, 100 },
		base_speeds = { 0.5, 1, 1.5, 2 },
		speed_multipliers = { 0.02, 0.02, 0.02, 0.03 },
		base_consumption = { 100, 125, 150, 175 },
		consumption_multipliers = { 1, 1, 1, 1 },
		consumption_unit = { "kW", "kW", "kW", "kW" },
		base_pollution = { -10, -20, -30, -40 },
		pollution_multipliers = { -0.1, -0.1, -0.1, -0.2 },
		base_productivity = { 0, 0, 0, 0 },
		productivity_multipliers = { 0.002, 0.002, 0.002, 0.002 },
		levels_per_module_slots = { 25, 25, 25, 25 },
		base_module_slots = { 2, 2, 2, 2 },
		bonus_module_slots = { 0, 0, 0, 1 }
	}
end

if mods["angelsrefining"] then
	ore_crusher_levels = {
		type = "assembling-machine",
		tiers = 4,
		base_machine_names = { "burner-ore-crusher", "ore-crusher", "ore-crusher-2", "ore-crusher-3" },
		levels = { 25, 25, 50, 100 },
		base_speeds = { 1, 1.5, 2, 3 },
		speed_multipliers = { 0.02, 0.02, 0.02, 0.04 },
		base_consumption = { 100, 100, 125, 150 },
		consumption_multipliers = { 2, 2, 2, 2 },
		consumption_unit = { "kW", "kW", "kW", "kW" },
		base_pollution = { 7, 2, 3, 4 },
		pollution_multipliers = { 0.1, 0.1, 0.1, 0.2 },
		base_productivity = { 0, 0, 0, 0 },
		productivity_multipliers = { 0.002, 0.002, 0.002, 0.002 },
		levels_per_module_slots = { 25, 25, 25, 25 },
		base_module_slots = { 0, 1, 2, 3 },
		bonus_module_slots = { 0, 0, 1, 1 }
	}

	liquifier_levels = {
		type = "assembling-machine",
		tiers = 4,
		base_machine_names = { "liquifier", "liquifier-2", "liquifier-3", "liquifier-4" },
		levels = { 25, 25, 50, 100 },
		base_speeds = { 1.5, 2.25, 3, 3.75 },
		speed_multipliers = { 0.03, 0.03, 0.015, 0.0375 },
		base_consumption = { 125, 150, 200, 300 },
		consumption_multipliers = { 1, 2, 2, 3 },
		consumption_unit = { "kW", "kW", "kW", "kW" },
		base_pollution = { 1.8, 2.4, 3, 3.6 },
		pollution_multipliers = { 0.1, 0.1, 0.1, 0.2 },
		base_productivity = { 0, 0, 0, 0 },
		productivity_multipliers = { 0.002, 0.002, 0.002, 0.002 },
		levels_per_module_slots = { 25, 25, 25, 25 },
		base_module_slots = { 1, 2, 3, 4 },
		bonus_module_slots = { 0, 0, 1, 1 }
	}

	crystallizer_levels = {
		type = "assembling-machine",
		tiers = 2,
		base_machine_names = { "crystallizer", "crystallizer-2" },
		levels = { 50, 100 },
		base_speeds = { 1.5, 2.25 },
		speed_multipliers = { 0.015, 0.0275 },
		base_consumption = { 150, 250 },
		consumption_multipliers = { 2, 3 },
		consumption_unit = { "kW", "kW", "kW" },
		base_pollution = { 1.8, 2.4 },
		pollution_multipliers = { 0.1, 0.1 },
		base_productivity = { 0, 0 },
		productivity_multipliers = { 0.002, 0.002 },
		levels_per_module_slots = { 25, 25 },
		base_module_slots = { 1, 2 },
		bonus_module_slots = { 0, 1 }
	}
end
