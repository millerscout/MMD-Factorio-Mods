if mods["Krastorio2"] then
    if data.raw.recipe["kr-greenhouse"] then data.raw.recipe["kr-greenhouse"].hidden = true end
    if data.raw.recipe["kr-vc-greenhouse-rampant-industry"] then data.raw.recipe["kr-vc-greenhouse-rampant-industry"].hidden = true end
    if data.raw.recipe["kr-vc-kr-greenhouse"] then data.raw.recipe["kr-vc-kr-greenhouse"].hidden = true end
    if data.raw.recipe["craft-kr-greenhouse"] then data.raw.recipe["craft-kr-greenhouse"].hidden = true end
    if data.raw.technology["kr-greenhouse"] then data.raw.technology["kr-greenhouse"].hidden = true end
    data.raw["item"]["sand"].stack_size = 1000
end


if mods["RampantIndustry"] then
    if data.raw.recipe["greenhouse-rampant-industry"] then data.raw.recipe["greenhouse-rampant-industry"].hidden = true end
    if data.raw.recipe["craft-greenhouse-rampant-industry"] then data.raw.recipe["craft-greenhouse-rampant-industry"].hidden = true end
    if data.raw.technology["rampant-industry-technology-greenhouse"] then data.raw.technology["rampant-industry-technology-greenhouse"].hidden = true end
    if data.raw.technology["rampant-industry-technology-greenhouse-2"] then data.raw.technology["rampant-industry-technology-greenhouse-2"].hidden = true end
end

if mods["Natural_Evolution_Buildings"] then
    if data.raw.recipe["Artifact-collector"] then data.raw.recipe["Artifact-collector"].hidden = true end
end

if mods["RampantArsenal"] then
    if data.raw.recipe["mortar-gun-rampant-arsenal"] then data.raw.recipe["mortar-gun-rampant-arsenal"].hidden = true end
end

if mods["SteamEngineExtra"] and mods["aai-industry"] then
    data_util = require '__aai-industry__/data-util'
    if data.raw["fuel-category"]["processed-chemical"] then
        data_util.add_fuel_category(data.raw["boiler"]["adikings-boiler-mk2"].energy_source, "vehicle-fuel")
    end
end



if mods["aai-industry"] then
    data.raw["item"]["stone-tablet"].stack_size = 500
    data.raw["item"]["electric-motor"].stack_size = 500
    data.raw["item"]["engine-unit"].stack_size = 500
    data.raw["item"]["motor"].stack_size = 500
    data.raw["item"]["processed-fuel"].stack_size = 500
end
if mods["Bio_Industries"] then
    data.raw["item"]["bi-woodpulp"].stack_size = 1000
end

if mods["SchallAlienLoot"] then
    data.raw["item"]["alien-ore-1"].stack_size = 500
    data.raw["item"]["alien-ore-2"].stack_size = 500
    data.raw["item"]["alien-ore-3"].stack_size = 500
    data.raw["item"]["small-alien-artifact"].stack_size = 500
    
end
data.raw["item"]["iron-stick"].stack_size = 500

if mods["Electric Furnace"] then
    data.raw["item"]["bi-woodpulp"].stack_size = 1000
end