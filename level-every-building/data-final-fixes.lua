require("util_mmd")
for key, value in pairs(data.raw["item"]) do
    print("item: " .. key)
    for itemKey, value in pairs(data.raw["item"][key]) do
        print("itemKey: " .. key .. " " .. itemKey)
    end
end
for key, value in pairs(data.raw["character"]) do
    print("character: " .. key)
end
for key, value in pairs(data.raw["furnace"]) do
    data.raw.furnace[key].crafting_speed = data.raw.furnace[key].crafting_speed / 3
    CalculateTierAndSetReferences(data.raw.furnace[key])
end

for key, value in pairs(data.raw["offshore-pump"]) do
    print("offshore-pump: " .. key)
    data.raw["offshore-pump"][key]["pumping_speed"] = data.raw["offshore-pump"][key]["pumping_speed"] / 3
end

for key, value in pairs(data.raw["radar"]) do
    print("radar: " .. key)
end
for key, value in pairs(data.raw["assembling-machine"]) do
    data.raw["assembling-machine"][key].crafting_speed = data.raw["assembling-machine"][key].crafting_speed / 3

    CalculateTierAndSetReferences(data.raw["assembling-machine"][key])
end

for key, value in pairs(data.raw["lab"]) do
    data.raw["lab"][key]["researching_speed"] = data.raw["lab"][key]["researching_speed"] / 3
    CalculateTierAndSetReferences(data.raw["lab"][key])
end

for key, value in pairs(data.raw["mining-drill"]) do
    data.raw["mining-drill"][key]["mining_speed"] = data.raw["mining-drill"][key]["mining_speed"] / 3
    CalculateTierAndSetReferences(data.raw["mining-drill"][key])
end
for key, value in pairs(data.raw["resource"]) do
    print("resource: " .. key)
end

for _, value in pairs(ReferenceBuildings.types) do
    Calculate(value)
    factory_levels.create_leveled_machines(value)
    factory_levels.fix_productivity(value)
end



