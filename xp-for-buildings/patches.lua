aa ={}
function ResetAttackTechnology()
    if not Disable_turret then
        for key, v in pairs(game.forces.player.technologies) do
            if v.effects ~= nil then
                for _, effect in pairs(v.effects) do
                    if effect.type == "turret-attack" then
                        if v.researched then
                            v.researched = false
                            table.insert(aa, key)
                            break;
                        end
                        break
                    end
                end
            end
        end
    end
end

function MigrateToExpTable(stored, type)
    for _, xpCount in pairs(stored) do
        level = Determine_level(0, type, xpCount)
        table.insert(global.ExpTable[type], { level = level, xpCount = xpCount })
    end
end

function MigrateExpTables()
    if global.ExpTable == nil then
        global.ExpTable = {}
    end

    for _, type in pairs(EnabledTypes) do
        if global.ExpTable[type] == nil then
            global.ExpTable[type] = {}
        end
        if type == "assembling-machine" and global.stored_products_finished_assemblers ~= nil then
            MigrateToExpTable(global.stored_products_finished_assemblers, type)
            global.stored_products_finished_assemblers = nil
        elseif type == "furnace" and global.stored_products_finished_furnaces ~= nil then
            MigrateToExpTable(global.stored_products_finished_furnaces, type)
            global.stored_products_finished_furnaces = nil
        elseif type == "lab" and global.stored_research_count ~= nil then
            MigrateToExpTable(global.stored_research_count, type)
            global.stored_research_count = nil
        elseif type == "mining-drill" and global.stored_mining_count ~= nil then
            MigrateToExpTable(global.stored_mining_count, type)
            global.stored_mining_count = nil
        elseif type == "ammo-turret" and global.stored_damage_dealt ~= nil then
            MigrateToExpTable(global.stored_damage_dealt, type)
            global.stored_damage_dealt = nil
        end
    end
end

Patches = {}
Patches[1] = Get_built_machines
