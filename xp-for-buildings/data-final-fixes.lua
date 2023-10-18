require("util_mmd")
require("__" .. "xp-for-buildings" .. "__.mmddata")

for key, value in pairs(data.raw["technology"]) do
    if value.effects ~= nil then
        for _, effect in pairs(value.effects) do
            if not Disable_turret then
                if effect.type == "turret-attack" then
                    if TechnologyUpdate[key] == nil then TechnologyUpdate[key] = {} end
                    table.insert(TechnologyUpdate[key], effect)
                end
            end
        end
    end
end
for _, value in pairs(data.raw["recipe"]) do
    if value.hidden and value.result ~= nil then
        mmddata.skipped_entities[value.result] = 0
    end
end
if IsDebug then
    mmddata.qtd = 0
    for key, value in pairs(data.raw) do
        -- print("raw" .. key)
        for keyS, _ in pairs(data.raw[key]) do
            -- print("raw-inner" .. keyS)
            mmddata.qtd = mmddata.qtd + 1
        end
    end
    -- deleteEntities

    print("prototype_count:" .. mmddata.qtd)
end

for _, type in pairs(EnabledTypes) do
    for key, value in pairs(data.raw[type]) do
        CalculateTierAndSetReferences(data.raw[type][key])
    end
end

for _, value in pairs(ReferenceBuildings.types) do
    Calculate(value)
    exp_for_buildings.create_leveled_machines(value)
    exp_for_buildings.fix_productivity(value)
end

if IsDebug then
    print("prototype_count:" .. mmddata.qtd)
end
