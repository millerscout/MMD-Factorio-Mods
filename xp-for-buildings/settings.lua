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

    }
})
