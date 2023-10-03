if mods["Electric Furnaces"] then
    data:extend(
        {
            {
                type = "recipe",
                name = "steel-furnace downgrade",
                ingredients = {
                    { "electric-steel-furnace", 1 },
                    { "electronic-circuit",     2 },
                    { "iron-plate",             2 }
                },
                result = "steel-furnace",
                energy_required = 3,
                enabled = true
            },
            {
                type = "recipe",
                name = "electric-stone-furnace downgrade",
                ingredients = {
                    { "electric-stone-furnace", 1 }
                },
                result = "stone-furnace",
                enabled = true
            }
        })
end
