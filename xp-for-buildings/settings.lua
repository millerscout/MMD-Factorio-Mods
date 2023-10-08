data:extend({
    {
        type = "int-setting",
        name = "exp_for_buildings-baseExp",
        minimum_value = 1,
        maximum_value = 5000,
        setting_type = "runtime-global",
        default_value = 180

    },
    {
        type = "double-setting",
        name = "exp_for_buildings-multiplier",
        minimum_value = 1.5,
        maximum_value = 5,
        setting_type = "runtime-global",
        default_value = 3

    },
    {
        type = "double-setting",
        name = "exp_for_buildings-divisor",
        minimum_value = 1,
        maximum_value = 100,
        setting_type = "runtime-global",
        default_value = 5
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_speed_multiplier",
        minimum_value = 0,
        maximum_value = 100,
        setting_type = "startup",
        default_value = 0.06
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_energy_multiplier",
        minimum_value = 0,
        maximum_value = 100,
        setting_type = "startup",
        default_value = 0.05
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_pollution_multiplier",
        minimum_value = 0,
        maximum_value = 100,
        setting_type = "startup",
        default_value = 0.04
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_max_health_multiplier",
        minimum_value = 0,
        maximum_value = 100,
        setting_type = "startup",
        default_value = 0.04
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_productivity_multiplier",
        minimum_value = 0,
        maximum_value = 100,
        setting_type = "startup",
        default_value = 0.02
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_furnace",
        minimum_value = 0,
        maximum_value = 90,
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_assembling_machine",
        minimum_value = 0,
        maximum_value = 90,
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_research",
        minimum_value = 0,
        maximum_value = 90,
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_mining_speed",
        minimum_value = 0,
        maximum_value = 90,
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_base_pollution",
        minimum_value = 0,
        maximum_value = 90,
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_energy_usage",
        minimum_value = 0,
        maximum_value = 90,
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "string-setting",
        name = "exp_for_buildings_skipped_entities",
        setting_type = "startup",
        default_value = "burner-lab,",
        allow_blank = true
    },
    {
        type = "int-setting",
        name = "exp_for_buildings_max_level",
        setting_type = "startup",
        default_value = 30,
        minimum_value = 0,
        maximum_value = 100,
    },
    {
        type = "bool-setting",
        name = "exp_for_buildings_calculate_onlythelast_mkbuildings",
        setting_type = "startup",
        default_value = true
    },
    {
		type = "bool-setting",
		name = "exp_for_buildings_revert_levels",
		setting_type = "runtime-global",
		default_value = false
	}
})
