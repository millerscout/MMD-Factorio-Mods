data:extend({
    {
        type = "int-setting",
        name = "exp_for_buildings-baseExp",
        minimum_value = 1,
        maximum_value = 5000,
		order = "a",
        setting_type = "runtime-global",
        default_value = 180

    },
    {
        type = "int-setting",
        name = "exp_for_buildings-baseExp_for_assemblies",
        minimum_value = 1,
        maximum_value = 5000,
		order = "b",
        setting_type = "runtime-global",
        default_value = 100

    },
    {
        type = "int-setting",
        name = "exp_for_buildings-baseExp_for_furnaces",
        minimum_value = 1,
        maximum_value = 5000,
		order = "c",
        setting_type = "runtime-global",
        default_value = 100

    },
    {
        type = "double-setting",
        name = "exp_for_buildings-multiplier",
        minimum_value = 1.5,
        maximum_value = 5,
		order = "d",
        setting_type = "runtime-global",
        default_value = 3

    },
    {
        type = "double-setting",
        name = "exp_for_buildings-divisor",
        minimum_value = 1,
        maximum_value = 100,
		order = "e",
        setting_type = "runtime-global",
        default_value = 5
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_range_multiplier",
        minimum_value = 0,
        maximum_value = 100,
		order = "bg",
        setting_type = "startup",
        default_value = 0.5
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_speed_multiplier",
        minimum_value = 0,
        maximum_value = 1000,
		order = "ba",
        setting_type = "startup",
        default_value = 6
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_energy_multiplier",
        minimum_value = 0,
        maximum_value = 1000,
		order = "bd",
        setting_type = "startup",
        default_value = 5
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_pollution_multiplier",
        minimum_value = 0,
        maximum_value = 1000,
		order = "be",
        setting_type = "startup",
        default_value = 4
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_damage_multiplier",
        minimum_value = 0,
        maximum_value = 1000,
		order = "bf",
        setting_type = "startup",
        default_value = 4
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_max_health_multiplier",
        minimum_value = 0,
        maximum_value = 1000,
		order = "bb",
        setting_type = "startup",
        default_value = 4
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_productivity_multiplier",
        minimum_value = 0,
        maximum_value = 100,
		order = "bc",
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_furnace",
        minimum_value = 0,
        maximum_value = 100,
		order = "cc",
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_assembling_machine",
        minimum_value = 0,
        maximum_value = 100,
		order = "cd",
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_research",
        minimum_value = 0,
        maximum_value = 100,
		order = "ce",
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_mining_speed",
        minimum_value = 0,
        maximum_value = 100,
		order = "cf",
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_base_pollution",
        minimum_value = 0,
        maximum_value = 100,
		order = "ca",
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_energy_usage",
        minimum_value = 0,
        maximum_value = 100,
		order = "cb",
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "string-setting",
        name = "exp_for_buildings_skipped_entities",
        setting_type = "startup",
		order = "ea",
        default_value = "burner-lab,",
        allow_blank = true
    },
    {
        type = "int-setting",
        name = "exp_for_buildings_max_level",
        setting_type = "startup",
		order = "aa",
        default_value = 30,
        minimum_value = 0,
        maximum_value = 100,
    },
    {
        type = "int-setting",
        name = "exp_for_buildings_max_range_for_turrets",
        setting_type = "startup",
		order = "bh",
        default_value = 30,
        minimum_value = 0,
        maximum_value = 100,
    },
    {
        type = "bool-setting",
        name = "exp_for_buildings_calculate_onlythelast_mkbuildings",
        setting_type = "startup",
		order = "ab",
        default_value = true
    },
    {
        type = "bool-setting",
        name = "exp_for_buildings_revert_levels",
        setting_type = "runtime-global",
		order = "z",
        default_value = false
    },
    {
        type = "bool-setting",
        name = "exp_for_buildings_debug",
		order = "za",
        setting_type = "startup",
        default_value = false
    },
    {
        type = "bool-setting",
        name = "exp_for_buildings_disable_turret",
		order = "de",
        setting_type = "startup",
        default_value = false
    },
    {
        type = "bool-setting",
        name = "exp_for_buildings_disable_assembling_machine",
		order = "db",
        setting_type = "startup",
        default_value = false
    }
    ,
    {
        type = "bool-setting",
        name = "exp_for_buildings_disable_furnace",
		order = "da",
        setting_type = "startup",
        default_value = false
    }
    ,
    {
        type = "bool-setting",
        name = "exp_for_buildings_disable_lab",
		order = "dc",
        setting_type = "startup",
        default_value = false
    },
    {
        type = "bool-setting",
        name = "exp_for_buildings_disable_mining-drill",
		order = "dd",
        setting_type = "startup",
        default_value = false
    }

})
