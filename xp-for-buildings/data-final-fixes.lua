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
function IncludeEntity(name)
    local item = data.raw.item[name]
    if item ~= nil and item.place_result and mmddata.included_entities[item.place_result] == nil then
        mmddata.included_entities[item.place_result] = 0
    end
end

function CheckResultItemAndAdd(recipe)
    if recipe.result ~= nil then
        IncludeEntity(recipe.result)
    elseif recipe.results ~= nil then
        for _, r in pairs(recipe.results) do
            if r.name ~= nil then
                IncludeEntity(r.name)
            elseif r[1] ~= nil and type(r[1]) == "string" then
                IncludeEntity(r[1])
            end
        end
    end
    if recipe.normal ~= nil then
        if recipe.normal.result ~= nil then
            if mmddata.included_entities[recipe.normal.result] == nil then
                mmddata.included_entities[recipe.normal.result] = 0
            end
        else
            for _, r in pairs(recipe.normal.results) do
                if r.name ~= nil then
                    IncludeEntity(r.name)
                elseif r[1] ~= nil and type(r[1]) == "string" then
                    IncludeEntity(r[1])
                end
            end
        end
    end
    if recipe.expensive ~= nil then
        if recipe.expensive.result ~= nil then
            if mmddata.included_entities[recipe.expensive.result] == nil then
                mmddata.included_entities[recipe.expensive.result] = 0
            end
        else
            for _, r in pairs(recipe.expensive.results) do
                if r.name ~= nil then
                    IncludeEntity(r.name)
                elseif r[1] ~= nil and type(r[1]) == "string" then
                    IncludeEntity(r[1])
                end
            end
        end
    end
end

for _, value in pairs(data.raw["recipe"]) do
    local available = (not value.hidden or value.hidden == nil)
    if available then
        -- log(serpent.block(value))
        CheckResultItemAndAdd(value)
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
