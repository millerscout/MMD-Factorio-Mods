for key, value in pairs(mods) do print(key) end
--for key, value in pairs(data.raw.technology) do print(key) end

if mods["Krastorio2"] then
    if data.raw.recipe["kr-greenhouse"] then data.raw.recipe["kr-greenhouse"].hidden = true end
    if data.raw.recipe["kr-vc-greenhouse-rampant-industry"] then data.raw.recipe["kr-vc-greenhouse-rampant-industry"].hidden = true end
    if data.raw.recipe["kr-vc-kr-greenhouse"] then data.raw.recipe["kr-vc-kr-greenhouse"].hidden = true end
    if data.raw.recipe["craft-kr-greenhouse"] then data.raw.recipe["craft-kr-greenhouse"].hidden = true end
    if data.raw.technology["kr-greenhouse"] then data.raw.technology["kr-greenhouse"].hidden = true end
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

if mods["SteamEngineExtra"] and mods["aai-industry"]then
    data_util = require '__aai-industry__/data-util'
    if data.raw["fuel-category"]["processed-chemical"] then
        data_util.add_fuel_category(data.raw["boiler"]["adikings-boiler-mk2"].energy_source, "vehicle-fuel")
    end
end
