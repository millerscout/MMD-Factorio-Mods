mmddata = {}

mmddata["ReferenceBuildings"] = {}
mmddata["included_entities"] = {}

Custom_multiplier = settings.startup["exp_for_buildings_custom_multiplier"].value
Range_multiplier = settings.startup["exp_for_buildings_range_multiplier"].value

Max_health_multiplier = settings.startup["exp_for_buildings_max_health_multiplier"].value
Speed_multiplier = settings.startup["exp_for_buildings_speed_multiplier"].value
Energy_multiplier = settings.startup["exp_for_buildings_energy_multiplier"].value
Pollution_multiplier = settings.startup["exp_for_buildings_pollution_multiplier"].value
Damage_multiplier = settings.startup["exp_for_buildings_damage_multiplier"].value
Productivity_multipliers = settings.startup["exp_for_buildings_productivity_multiplier"].value

if Custom_multiplier > 0 then
    Max_health_multiplier = Max_health_multiplier * Custom_multiplier
    Speed_multiplier = Speed_multiplier * Custom_multiplier
    Energy_multiplier = Energy_multiplier * Custom_multiplier
    Pollution_multiplier = Pollution_multiplier * Custom_multiplier
    Damage_multiplier = Damage_multiplier * Custom_multiplier
    Productivity_multipliers = Productivity_multipliers * Custom_multiplier
end

Exp_for_buildings_skipped_entities = settings.startup["exp_for_buildings_skipped_entities"].value
Max_range_for_turrets = settings.startup["exp_for_buildings_max_range_for_turrets"].value
Force_Effects_On_Entities = settings.startup["exp_for_buildings_Force_Effects_On_Entities"].value
IsDebug = settings.startup["exp_for_buildings_debug"].value

Exp_for_buildings_calculate_onlythelast_mkbuildings = settings.startup
    ["exp_for_buildings_calculate_onlythelast_mkbuildings"].value
Reduce_base_pollution = settings.startup
    ["exp_for_buildings_reduce_base_pollution"].value
Reduce_energy_usage = settings.startup
    ["exp_for_buildings_reduce_energy_usage"].value

Reduce_crafting_speed_by_furnace = settings.startup["exp_for_buildings_reduce_crafting_speed_by_furnace"].value
Reduce_crafting_speed_by_assembling_machine = settings.startup
    ["exp_for_buildings_reduce_crafting_speed_by_assembling_machine"].value
Reduce_crafting_speed_by_research = settings.startup
    ["exp_for_buildings_reduce_crafting_speed_by_research"].value
Reduce_crafting_speed_by_mining_speed = settings.startup
    ["exp_for_buildings_reduce_crafting_speed_by_mining_speed"].value

Disable_turret = settings.startup
    ["exp_for_buildings_disable_turret"].value
Disable_assembling_machine = settings.startup
    ["exp_for_buildings_disable_assembling_machine"].value
Disable_furnace = settings.startup
    ["exp_for_buildings_disable_furnace"].value
Disable_lab = settings.startup
    ["exp_for_buildings_disable_lab"].value
Disable_mining = settings.startup
    ["exp_for_buildings_disable_mining-drill"].value


Max_level = settings.startup["exp_for_buildings_max_level"].value

SkippedEntities = {}
SkippedEntities["se-delivery-cannon"] = 0
SkippedEntities["se-delivery-cannon-weapon"] = 0
SkippedEntities["se-energy-beam-defence"] = 0
SkippedEntities["se-meteor-defence"] = 0
SkippedEntities["se-meteor-point-defence"] = 0
SkippedEntities["kr-mineral-water-pumpjack"] = 0
SkippedEntities["recycling-machine"] = 0
SkippedEntities["kr-fluid-burner"] = 0
SkippedEntities["capsule-ammo-turret-rampant-arsenal"] = 0
SkippedEntities["se-meteor-point-defence-container"] = 0
SkippedEntities["se-space-elevator"] = 0
SkippedEntities["se-spaceship-rocket-engine"] = 0
SkippedEntities["se-spaceship-ion-engine"] = 0
SkippedEntities["se-recycling-facility"] = 0
SkippedEntities["se-space-telescope-gammaray"] = 0
SkippedEntities["se-space-telescope-microwave"] = 0
SkippedEntities["se-space-telescope-radio"] = 0
SkippedEntities["se-space-telescope-xray"] = 0
SkippedEntities["se-energy-transmitter-emitter"] = 0
SkippedEntities["se-meteor-defence-container"] = 0
SkippedEntities["se-spaceship-antimatter-engine"] = 0


-- skipped entities temporally, until implemented
SkippedEntities["vtk-deepcore-mining-moho"] = 0
SkippedEntities["vtk-deepcore-mining-drill"] = 0
SkippedEntities["vtk-deepcore-mining-drill-advanced"] = 0


EnabledTypes = {}
EnabledFilters = {}

TechnologyUpdate = {}


if not Disable_turret then
    table.insert(EnabledTypes, "ammo-turret")
    table.insert(EnabledFilters, { filter = "type", type = "ammo-turret" })
end
if not Disable_assembling_machine then
    table.insert(EnabledTypes, "assembling-machine")
    table.insert(EnabledFilters, { filter = "type", type = "assembling-machine" })
end
if not Disable_furnace then
    table.insert(EnabledTypes, "furnace")
    table.insert(EnabledFilters, { filter = "type", type = "furnace" })
end
if not Disable_lab then
    table.insert(EnabledTypes, "lab")
    table.insert(EnabledFilters, { filter = "type", type = "lab" })
end
if not Disable_mining then
    table.insert(EnabledTypes, "mining-drill")
    table.insert(EnabledFilters, { filter = "type", type = "mining-drill" })
end
