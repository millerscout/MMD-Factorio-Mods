if mods["Krastorio2"] then
    data:extend(
        {{
            type = "recipe",
            name = "Steel-from-ore",
            category = "smelting",
            energy_required = 16,
            enabled = true,
            allow_productivity = true,
            ingredients = {
                { "iron-ore", 20 },
                { "coke",     2 }
            },
            result = "steel-plate",
            result_count = 5,
        } })
end
