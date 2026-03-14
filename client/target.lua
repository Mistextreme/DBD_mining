-- Target registration helpers for ore nodes and the task NPC

local targetType = Config.Integrations.Target.Type

-- ─── Ore node targets ────────────────────────────────────────────────────────

--- Attach a mining interaction to a spawned ore entity.
function RegisterOreTarget(entity, zoneId, oreIdx)
    local name = ('dbd_ore_%d_%d'):format(zoneId, oreIdx)

    if targetType == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, {
            {
                name     = name,
                label    = _L('target.mine-ore'),
                icon     = 'fa-solid fa-hammer',
                distance = 3.0,
                onSelect = function()
                    TriggerEvent('dbd_mining:client:startMining', zoneId, oreIdx, entity)
                end,
            },
        })

    elseif targetType == 'qb-target' then
        exports['qb-target']:AddEntityZone(
            name,
            entity,
            { name = name, debugPoly = Config.Core.Debug },
            {
                options = {
                    {
                        type   = 'client',
                        event  = 'dbd_mining:client:startMining',
                        icon   = 'fa-solid fa-hammer',
                        label  = _L('target.mine-ore'),
                        zoneId = zoneId,
                        oreIdx = oreIdx,
                        entity = entity,
                    },
                },
                distance = 3.0,
            }
        )

    elseif targetType == 'qtarget' then
        exports['qtarget']:AddEntityZone(
            name,
            entity,
            { name = name, debugPoly = Config.Core.Debug },
            {
                options = {
                    {
                        type   = 'client',
                        event  = 'dbd_mining:client:startMining',
                        icon   = 'fa-solid fa-hammer',
                        label  = _L('target.mine-ore'),
                        zoneId = zoneId,
                        oreIdx = oreIdx,
                        entity = entity,
                    },
                },
                distance = 3.0,
            }
        )
    end
end

--- Remove mining interaction from an ore entity (called before despawn).
function RemoveOreTarget(entity, zoneId, oreIdx)
    local name = ('dbd_ore_%d_%d'):format(zoneId, oreIdx)

    if targetType == 'ox_target' then
        exports.ox_target:removeLocalEntity(entity, name)

    elseif targetType == 'qb-target' then
        exports['qb-target']:RemoveZone(name)

    elseif targetType == 'qtarget' then
        exports['qtarget']:RemoveZone(name)
    end
end

-- ─── Task NPC target ─────────────────────────────────────────────────────────

--- Attach a task interaction to the spawned NPC ped.
function RegisterTaskNpcTarget(ped)
    if not Config.Mining.Tasks.Enabled then return end

    if targetType == 'ox_target' then
        exports.ox_target:addLocalEntity(ped, {
            {
                name     = 'dbd_mining_tasks_npc',
                label    = _L('target.mining-tasks'),
                icon     = 'fa-solid fa-list-check',
                distance = 3.0,
                onSelect = function()
                    TriggerEvent('dbd_mining:client:openTasksMenu')
                end,
            },
        })

    elseif targetType == 'qb-target' then
        exports['qb-target']:AddEntityZone(
            'dbd_mining_tasks_npc',
            ped,
            { name = 'dbd_mining_tasks_npc', debugPoly = Config.Core.Debug },
            {
                options = {
                    {
                        type  = 'client',
                        event = 'dbd_mining:client:openTasksMenu',
                        icon  = 'fa-solid fa-list-check',
                        label = _L('target.mining-tasks'),
                    },
                },
                distance = 3.0,
            }
        )

    elseif targetType == 'qtarget' then
        exports['qtarget']:AddEntityZone(
            'dbd_mining_tasks_npc',
            ped,
            { name = 'dbd_mining_tasks_npc', debugPoly = Config.Core.Debug },
            {
                options = {
                    {
                        type  = 'client',
                        event = 'dbd_mining:client:openTasksMenu',
                        icon  = 'fa-solid fa-list-check',
                        label = _L('target.mining-tasks'),
                    },
                },
                distance = 3.0,
            }
        )
    end
end