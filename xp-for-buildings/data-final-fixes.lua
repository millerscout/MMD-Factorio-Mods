require("util_mmd")

local reduce_crafting_speed_by_furnace = settings.startup["exp_for_buildings_reduce_crafting_speed_by_furnace"].value
local reduce_crafting_speed_by_assembling_machine = settings.startup
    ["exp_for_buildings_reduce_crafting_speed_by_assembling_machine"].value
local reduce_crafting_speed_by_research = settings.startup
    ["exp_for_buildings_reduce_crafting_speed_by_research"].value
local reduce_crafting_speed_by_mining_speed = settings.startup
    ["exp_for_buildings_reduce_crafting_speed_by_mining_speed"].value

-- for key, value in pairs(data.raw["item"]) do
--     print("item: " .. key)
--     for itemKey, value in pairs(data.raw["item"][key]) do
--         print("itemKey: " .. key .. " " .. itemKey)
--     end
-- end
for key, value in pairs(data.raw["furnace"]) do
    data.raw.furnace[key].crafting_speed = data.raw.furnace[key].crafting_speed / reduce_crafting_speed_by_furnace
    CalculateTierAndSetReferences(data.raw.furnace[key])
end
-- for key, value in pairs(data.raw["offshore-pump"]) do
--     print("offshore-pump: " .. key)
--     data.raw["offshore-pump"][key]["pumping_speed"] = data.raw["offshore-pump"][key]["pumping_speed"] / 3
-- end

-- for key, value in pairs(data.raw["radar"]) do
--     print("radar: " .. key)
-- end
for key, value in pairs(data.raw["assembling-machine"]) do
    data.raw["assembling-machine"][key].crafting_speed = data.raw["assembling-machine"][key].crafting_speed /
        reduce_crafting_speed_by_assembling_machine
    CalculateTierAndSetReferences(data.raw["assembling-machine"][key])
end

for key, value in pairs(data.raw["lab"]) do
    if data.raw["lab"][key]["researching_speed"] ~= nil then
        data.raw["lab"][key]["researching_speed"] = data.raw["lab"][key]["researching_speed"] /
            reduce_crafting_speed_by_research
    end
    CalculateTierAndSetReferences(data.raw["lab"][key])
end

for key, value in pairs(data.raw["mining-drill"]) do
    data.raw["mining-drill"][key]["mining_speed"] = data.raw["mining-drill"][key]["mining_speed"] /
        reduce_crafting_speed_by_mining_speed
    CalculateTierAndSetReferences(data.raw["mining-drill"][key])
end

for key, value in pairs(data.raw["ammo-turret"]) do
    CalculateTierAndSetReferences(data.raw["ammo-turret"][key])
end
for _, value in pairs(ReferenceBuildings.types) do
    Calculate(value)
    factory_levels.create_leveled_machines(value)
    factory_levels.fix_productivity(value)
end
