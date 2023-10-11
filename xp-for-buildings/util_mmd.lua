local ReferenceBuildings = require("__" .. "xp-for-buildings" .. "__.mmddata")()

local speed_multiplier = settings.startup["exp_for_buildings_speed_multiplier"].value
local energy_multiplier = settings.startup["exp_for_buildings_energy_multiplier"].value
local pollution_multiplier = settings.startup["exp_for_buildings_pollution_multiplier"].value
local productivity_multipliers = settings.startup["exp_for_buildings_productivity_multiplier"].value
local exp_for_buildings_skipped_entities = settings.startup["exp_for_buildings_skipped_entities"].value
local exp_for_buildings_calculate_onlythelast_mkbuildings = settings.startup
    ["exp_for_buildings_calculate_onlythelast_mkbuildings"].value
local reduce_base_pollution = settings.startup
    ["exp_for_buildings_reduce_base_pollution"].value
local reduce_energy_usage = settings.startup
    ["exp_for_buildings_reduce_energy_usage"].value

local max_level = settings.startup["exp_for_buildings_max_level"].value

local skippedEntities = {}

for field in exp_for_buildings_skipped_entities:gmatch('([^,]+)') do
    skippedEntities[field] = 0
end


function getUniqueId(proto)
    return proto.type .. "_" .. proto.name
end

function has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function GetEnergyValues(value)
    local numberValue = ""
    local Unit = ""
    if value == nil then return end
    for i = 1, #value do
        local c = value:sub(i, i)
        if c == "." then
            numberValue = numberValue .. c
        elseif type(tonumber(c)) == "number" then
            numberValue = numberValue .. c
        else
            Unit = Unit .. c
        end
    end
    return numberValue, Unit
end

function DetermineAndSetPollutionValues(tab, value)
    local numberValue, Unit = GetEnergyValues(value)
    table.insert(tab.base_consumption, numberValue)
    table.insert(tab.consumption_unit, Unit)
end

function SetLevels(tab)
    table.insert(tab.levels, math.ceil(max_level))
end

function SetModules(tab)
    qtd = #tab.base_machine_names
    tab.tiers = qtd
    levels_per_module_slots = { 20, 25, 30 }
    for i = 1, qtd, 1 do
        if i > 3 then
            default = 30
        else
            default = levels_per_module_slots[i]
        end

        table.insert(tab.levels_per_module_slots, default)
        table.insert(tab.bonus_module_slots, 1) ---TODO: calculate it properly
    end
end

function SetEnergy(tab)
    nextVal = 0
    for i = 1, #tab.base_machine_names, 1 do
        nextVal = nextVal + energy_multiplier * i;
        table.insert(tab.energy_multiplier, nextVal)
    end
end

function SetSpeedMultipliers(tab)
    for i = 1, #tab.base_machine_names, 1 do
        table.insert(tab.speed_multipliers, speed_multiplier * i)
    end
end

function Calculate(tab)
    SetLevels(tab)
    SetSpeedMultipliers(tab)
    SetModules(tab)
    SetEnergy(tab)
end

function CalculateTierAndSetReferences(proto)
    if ReferenceBuildings.types == nil then ReferenceBuildings.types = {} end
    if skippedEntities[proto.name] ~= nil then return end
    if proto.minable == nil or type(proto.minable.result) ~= "string" then return end

    if proto.energy_source ~= nil and proto.energy_source.emissions_per_minute ~= nil then
        proto.energy_source.emissions_per_minute = proto.energy_source.emissions_per_minute / reduce_base_pollution
    end
    if proto.energy_usage ~= nil then
        local numberValue, Unit = GetEnergyValues(proto.energy_usage)
        proto.energy_usage = (numberValue / reduce_energy_usage) .. Unit
    end

    if exp_for_buildings_calculate_onlythelast_mkbuildings then
        if string.match(proto.name, "mk01") then
            last = ""
            if string.find(proto.name, 'mk01') then
                start, _ = string.find(proto.name, 'mk01', 1, true)
                refName = string.sub(proto.name, 0, start - 1)

                last = proto.name
                for i = 1, 8, 1 do
                    exists = data.raw[proto.type][refName .. "mk0" .. i]
                    if exists ~= nil then
                        last = exists
                    else
                        break
                    end
                end
            end
            proto = last
        end
    end



    uniqueId = getUniqueId(proto)
    if ReferenceBuildings.types[uniqueId] == nil then
        ReferenceBuildings.types[uniqueId] = {
            type = proto.type,
            tiers = 0,
            base_machine_names = {},
            levels = {},
            base_speeds = {},
            speed_multipliers = {},
            base_consumption = {},
            energy_multiplier = {},
            consumption_unit = {},
            base_pollution = {},
            pollution_multipliers = {},
            base_productivity = {},
            productivity_multipliers = {},
            levels_per_module_slots = {},
            base_module_slots = {},
            bonus_module_slots = {},
            item = {}
        }
    else
        return
    end

    table.insert(ReferenceBuildings.types[uniqueId].base_machine_names, proto.name)
    table.insert(ReferenceBuildings.types[uniqueId].item, proto.minable.result)
    if proto["crafting_speed"] ~= nil then
        table.insert(ReferenceBuildings.types[uniqueId].base_speeds, proto["crafting_speed"])
    elseif proto["mining_speed"] ~= nil then
        table.insert(ReferenceBuildings.types[uniqueId].base_speeds, proto["mining_speed"])
    elseif proto["researching_speed"] ~= nil then
        table.insert(ReferenceBuildings.types[uniqueId].base_speeds, proto["researching_speed"])
    end
    DetermineAndSetPollutionValues(ReferenceBuildings.types[uniqueId], proto.energy_usage)
    if proto.energy_source == nil or proto.energy_source.emissions_per_minute == nil then
        table.insert(ReferenceBuildings.types[uniqueId].base_pollution, 0)
    else
        table.insert(ReferenceBuildings.types[uniqueId].base_pollution, proto.energy_source.emissions_per_minute)
    end

    if proto.productivity_bonus == nil then
        productivity_bonus = 0
    else
        productivity_bonus = proto.productivity_bonus
    end
    table.insert(ReferenceBuildings.types[uniqueId].base_productivity, productivity_bonus)
    table.insert(ReferenceBuildings.types[uniqueId].pollution_multipliers, pollution_multiplier)
    table.insert(ReferenceBuildings.types[uniqueId].productivity_multipliers, productivity_multipliers)

    if proto.module_specification == nil or proto.module_specification.module_slots == nil then
        table.insert(ReferenceBuildings.types[uniqueId].base_module_slots, 0)
    else
        table.insert(ReferenceBuildings.types[uniqueId].base_module_slots,
            proto.module_specification.module_slots)
    end
end
