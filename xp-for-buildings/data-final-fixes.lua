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
    local available = (not value.hidden or value.hidden == nil)
    if available then
        -- log(serpent.block(value))
        if value.result ~= nil then
            mmddata.included_entities[value.result] = 0
        elseif value.results ~= nil then
            for _, r in pairs(value.results) do
                if r.name ~= nil and mmddata.included_entities[r.name] == nil then
                    mmddata.included_entities[r.name] = 0
                end
            end
        end
        if value.normal ~= nil then
            if value.normal.result ~= nil then
                if mmddata.included_entities[value.normal.result] == nil then
                    mmddata.included_entities[value.normal.result] = 0
                end
            else
                for _, r in pairs(value.normal.results) do
                    
                    if r.name ~= nil and mmddata.included_entities[r.name] == nil then
                        mmddata.included_entities[r.name] = 0
                    end
                end
            end
        end
        if value.expensive ~= nil then
            if value.expensive.result ~= nil then
                if mmddata.included_entities[value.expensive.result] == nil then
                    mmddata.included_entities[value.expensive.result] = 0
                end
            else
                for _, r in pairs(value.expensive.results) do
                    if r.name ~= nil and mmddata.included_entities[r.name] == nil then
                        mmddata.included_entities[r.name] = 0
                    end
                end
            end
        end
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

    log("prototype_count:" .. mmddata.qtd)
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
    log("prototype_count:" .. mmddata.qtd)
end
