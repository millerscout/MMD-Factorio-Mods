local ReferenceBuildings = require("__" .. "xp-for-buildings" .. "__.mmddata")()

function getUniqueCategory(proto)
    category = ""
    if proto.crafting_categories == nil then return proto.type end
    for i, name in pairs(proto.crafting_categories) do
        category = category .. "_" .. name
    end
    return category .. "_"
end

function has_value(tab, val)
    for _, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function DetermineAndSetPollutionValues(tab, value)
    numberValue = ""
    Unit = ""

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
    table.insert(tab.base_consumption, numberValue)
    table.insert(tab.consumption_unit, Unit)
end

function CalculateTierAndSet(tab)
    qtd = #tab.base_machine_names
    maxLevelPerTier = 100 / qtd
    tab.tiers = qtd
    for i = 1, qtd, 1 do
        table.insert(tab.levels, math.ceil(maxLevelPerTier * i))
    end
end

function CalculateModulesAndSet(tab)
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

function CalculatePolutionMultiplierAndSet(tab)
    base_multiplier = 0.2
    nextVal = 0
    for i = 1, #tab.base_machine_names, 1 do
        nextVal = nextVal + base_multiplier * i;
        table.insert(tab.consumption_multipliers, nextVal)
    end
end

function CalculateMultipliersAndSet(tab)
    base_multiplier = 0.2

    for i = 1, #tab.base_machine_names, 1 do
        table.insert(tab.speed_multipliers, base_multiplier * i)
    end
end

function Calculate(tab)
    CalculateTierAndSet(tab)
    CalculateMultipliersAndSet(tab)
    CalculateModulesAndSet(tab)
    CalculatePolutionMultiplierAndSet(tab)
end

function CalculateTierAndSetReferences(proto)
    if ReferenceBuildings.types == nil then ReferenceBuildings.types = {} end
    if proto.name == "bi-arboretum" then
        return
    end
    category = getUniqueCategory(proto)
    if ReferenceBuildings.types[category] == nil then
        ReferenceBuildings.types[category] = {
            type = proto.type,
            tiers = 0,
            base_machine_names = {},
            levels = {},
            base_speeds = {},
            speed_multipliers = {},
            base_consumption = {},
            consumption_multipliers = {},
            consumption_unit = {},
            base_pollution = {},
            pollution_multipliers = {},
            base_productivity = {},
            productivity_multipliers = {},
            levels_per_module_slots = {},
            base_module_slots = {},
            bonus_module_slots = {}
        }
    end

    table.insert(ReferenceBuildings.types[category].base_machine_names, proto.name)
    if proto["crafting_speed"] ~= nil then
        table.insert(ReferenceBuildings.types[category].base_speeds, proto["crafting_speed"])
    elseif proto["mining_speed"] ~= nil then
        table.insert(ReferenceBuildings.types[category].base_speeds, proto["mining_speed"])
    elseif proto["researching_speed"] ~= nil then
        table.insert(ReferenceBuildings.types[category].base_speeds, proto["researching_speed"])
    end
    DetermineAndSetPollutionValues(ReferenceBuildings.types[category], proto.energy_usage)
    if proto.energy_source == nil or proto.energy_source.emissions_per_minute == nil then
        table.insert(ReferenceBuildings.types[category].base_pollution, 0)
    else
        table.insert(ReferenceBuildings.types[category].base_pollution, proto.energy_source.emissions_per_minute)
    end

    if proto.productivity_bonus == nil then
        productivity_bonus = 0
    else
        productivity_bonus = proto.productivity_bonus
    end
    table.insert(ReferenceBuildings.types[category].base_productivity, productivity_bonus)
    table.insert(ReferenceBuildings.types[category].pollution_multipliers, 0.04)      ---TODO: calculate it properly
    table.insert(ReferenceBuildings.types[category].productivity_multipliers, 0.0025) ---TODO: calculate it properly

    if proto.module_specification == nil or proto.module_specification.module_slots == nil then
        table.insert(ReferenceBuildings.types[category].base_module_slots, 0)
    else
        table.insert(ReferenceBuildings.types[category].base_module_slots,
            proto.module_specification.module_slots)
    end
end
