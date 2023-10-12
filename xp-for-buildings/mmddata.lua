mmddata = {}
mmddata["ReferenceBuildings"] = {}
mmddata["skipped_entities"] = {}
speed_multiplier = settings.startup["exp_for_buildings_speed_multiplier"].value
energy_multiplier = settings.startup["exp_for_buildings_energy_multiplier"].value
pollution_multiplier = settings.startup["exp_for_buildings_pollution_multiplier"].value
productivity_multipliers = settings.startup["exp_for_buildings_productivity_multiplier"].value
exp_for_buildings_skipped_entities = settings.startup["exp_for_buildings_skipped_entities"].value
isDebug = settings.startup["exp_for_buildings_debug"].value

exp_for_buildings_calculate_onlythelast_mkbuildings = settings.startup
    ["exp_for_buildings_calculate_onlythelast_mkbuildings"].value
reduce_base_pollution = settings.startup
    ["exp_for_buildings_reduce_base_pollution"].value
reduce_energy_usage = settings.startup
    ["exp_for_buildings_reduce_energy_usage"].value

reduce_crafting_speed_by_furnace = settings.startup["exp_for_buildings_reduce_crafting_speed_by_furnace"].value
reduce_crafting_speed_by_assembling_machine = settings.startup
    ["exp_for_buildings_reduce_crafting_speed_by_assembling_machine"].value
reduce_crafting_speed_by_research = settings.startup
    ["exp_for_buildings_reduce_crafting_speed_by_research"].value
reduce_crafting_speed_by_mining_speed = settings.startup
    ["exp_for_buildings_reduce_crafting_speed_by_mining_speed"].value
disable_turret = settings.startup
    ["exp_for_buildings_disable_turret"].value

max_level = settings.startup["exp_for_buildings_max_level"].value

skippedEntities = {}
