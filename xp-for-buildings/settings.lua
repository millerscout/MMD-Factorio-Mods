data:extend({
    {
        type = "int-setting",
        name = "exp_for_buildings-baseExp",
        order = "a",
        minimum_value = 1,
        maximum_value = 5000,
        setting_type = "runtime-global",
        default_value = 250

    },
    {
        type = "double-setting",
        name = "exp_for_buildings-multiplier",
        order = "b",
        minimum_value = 1.5,
        maximum_value = 5,
        setting_type = "runtime-global",
        default_value = 3

    },
    {
        type = "double-setting",
        name = "exp_for_buildings-divisor",
        order = "c",
        minimum_value = 1,
        maximum_value = 100,
        setting_type = "runtime-global",
        default_value = 5
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_speed_multiplier",
        order = "d",
        minimum_value = 0,
        maximum_value = 100,
        setting_type = "startup",
        default_value = 0.2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_energy_multiplier",
        order = "e",
        minimum_value = 0,
        maximum_value = 100,
        setting_type = "startup",
        default_value = 0.2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_pollution_multiplier",
        order = "f",
        minimum_value = 0,
        maximum_value = 100,
        setting_type = "startup",
        default_value = 0.04
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_productivity_multiplier",
        order = "g",
        minimum_value = 0,
        maximum_value = 100,
        setting_type = "startup",
        default_value = 0.004
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_furnace",
        order = "h",
        minimum_value = 0,
        maximum_value = 90,
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_assembling_machine",
        order = "i",
        minimum_value = 0,
        maximum_value = 90,
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_research",
        order = "j",
        minimum_value = 0,
        maximum_value = 90,
        setting_type = "startup",
        default_value = 2
    },
    {
        type = "double-setting",
        name = "exp_for_buildings_reduce_crafting_speed_by_mining_speed",
        order = "k",
        minimum_value = 0,
        maximum_value = 90,
        setting_type = "startup",
        default_value = 2
    }
})
