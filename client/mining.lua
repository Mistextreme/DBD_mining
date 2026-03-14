-- Core mining: zone proximity, ore prop lifecycle, and mining sequence

-- [zoneId][oreIdx] = { entity=number, depleted=bool, respawnAt=number(ms) }
local spawnedOres    = {}
local activeZoneId   = nil
local lastGlobalMine = 0

-- ─── Prop helpers ────────────────────────────────────────────────────────────

local function spawnOreProp(zoneId, oreIdx, coords)
    local zone      = Config.Mining.Zones[zoneId]
    local modelName = (zone.models and zone.models[1]) or 'prop_rock_2_a'
    local hash      = GetHashKey(modelName)

    RequestModel(hash)
    local t = 0
    while not HasModelLoaded(hash) do
        Citizen.Wait(50)
        t = t + 50
        if t > 5000 then return nil end
    end

    local ent = CreateObject(hash, coords.x, coords.y, coords.z, false, false, false)
    SetEntityAsMissionEntity(ent, true, true)
    FreezeEntityPosition(ent, true)
    PlaceObjectOnGroundProperly(ent)
    SetModelAsNoLongerNeeded(hash)
    return ent
end

local function despawnOreProp(zoneId, oreIdx)
    local record = spawnedOres[zoneId] and spawnedOres[zoneId][oreIdx]
    if not record then return end

    RemoveOreTarget(record.entity, zoneId, oreIdx)

    if record.entity and DoesEntityExist(record.entity) then
        SetEntityAsMissionEntity(record.entity, false, true)
        DeleteEntity(record.entity)
    end
    record.entity = nil
end

local function initZoneOres(zoneId)
    local zone = Config.Mining.Zones[zoneId]
    if not zone then return end

    spawnedOres[zoneId] = spawnedOres[zoneId] or {}

    for idx, coords in pairs(zone.ores) do
        local existing = spawnedOres[zoneId][idx]
        if not existing or not existing.entity or not DoesEntityExist(existing.entity) then
            local ent = spawnOreProp(zoneId, idx, coords)
            if ent then
                spawnedOres[zoneId][idx] = { entity = ent, depleted = false, respawnAt = 0 }
                RegisterOreTarget(ent, zoneId, idx)
            end
        end
    end
end

local function teardownZoneOres(zoneId)
    if not spawnedOres[zoneId] then return end
    for oreIdx in pairs(spawnedOres[zoneId]) do
        despawnOreProp(zoneId, oreIdx)
    end
    spawnedOres[zoneId] = nil
end

-- ─── Zone proximity thread ───────────────────────────────────────────────────

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2500)

        local pedCoords   = GetEntityCoords(PlayerPedId())
        local nearest     = nil
        local nearestDist = 120.0

        for zoneId, meta in pairs(Config.Mining.Meta) do
            if type(zoneId) == 'number' and meta.Center then
                local inTime = true
                local hours  = meta.Hours
                if hours and hours.Enabled then
                    local h = GetClockHours()
                    if hours.Open <= hours.Close then
                        inTime = h >= hours.Open and h < hours.Close
                    else
                        inTime = h >= hours.Open or h < hours.Close
                    end
                end

                if inTime then
                    local dist = #(pedCoords - meta.Center)
                    if dist < nearestDist then
                        nearestDist = dist
                        nearest     = zoneId
                    end
                end
            end
        end

        if nearest ~= activeZoneId then
            if activeZoneId then
                teardownZoneOres(activeZoneId)
            end
            activeZoneId = nearest
            if nearest then
                initZoneOres(nearest)
            end
        end

        -- Respawn depleted ores in the active zone
        if activeZoneId and spawnedOres[activeZoneId] then
            local zone = Config.Mining.Zones[activeZoneId]
            local now  = GetGameTimer()
            for oreIdx, record in pairs(spawnedOres[activeZoneId]) do
                if record.depleted and record.respawnAt > 0 and now >= record.respawnAt then
                    local coords = zone.ores[oreIdx]
                    if coords then
                        local ent = spawnOreProp(activeZoneId, oreIdx, coords)
                        if ent then
                            record.entity    = ent
                            record.depleted  = false
                            record.respawnAt = 0
                            RegisterOreTarget(ent, activeZoneId, oreIdx)
                        end
                    end
                end
            end
        end
    end
end)

-- ─── Client-side ore depletion ───────────────────────────────────────────────

local function markOreDepleted(zoneId, oreIdx)
    local record = spawnedOres[zoneId] and spawnedOres[zoneId][oreIdx]
    if not record then return end

    local zone = Config.Mining.Zones[zoneId]
    despawnOreProp(zoneId, oreIdx)

    record.depleted  = true
    record.respawnAt = GetGameTimer() + (zone.respawn or 30000)
    spawnedOres[zoneId][oreIdx] = record
end

-- ─── Mining start ─────────────────────────────────────────────────────────────
-- ox_target fires TriggerEvent(event, zoneId, oreIdx, entity) — three separate args.
-- qb-target and qtarget fire TriggerEvent(event, optionTable) — one table arg.
-- The handler detects which format was used and unpacks accordingly.

AddEventHandler('dbd_mining:client:startMining', function(zoneIdOrData, oreIdxArg, entityArg)
    local zoneId, oreIdx, entity

    if type(zoneIdOrData) == 'table' then
        -- qb-target / qtarget: entire options table passed as first argument
        zoneId = zoneIdOrData.zoneId
        oreIdx = zoneIdOrData.oreIdx
        entity = zoneIdOrData.entity
    else
        -- ox_target: three separate arguments
        zoneId = zoneIdOrData
        oreIdx = oreIdxArg
        entity = entityArg
    end

    if not zoneId or not oreIdx then return end
    if Mining.IsMining then return end

    -- Global cooldown
    if Config.Mining.Cooldowns.Global > 0 then
        if (GetGameTimer() - lastGlobalMine) < (Config.Mining.Cooldowns.Global * 1000) then
            Notify(_L('notify.missing-item'), 'error')
            return
        end
    end

    local zone = Config.Mining.Zones[zoneId]
    if not zone then return end

    -- Level gate
    if Mining.PlayerData.level < zone.level then
        Notify(_L('notify.not-experienced'), 'error')
        return
    end

    -- Tool gate
    local tool = GetEquippedPickaxeTool()
    if not tool then
        Notify(_L('notify.missing-pickaxe'), 'error')
        return
    end

    Mining.IsMining = true

    local duration = math.random(zone.duration.min, zone.duration.max)

    PlayMiningAnimation()

    ShowProgress(_L('target.mine-ore'), duration, function(completed)
        StopMiningAnimation()
        Mining.IsMining = false

        if not completed then return end

        markOreDepleted(zoneId, oreIdx)
        lastGlobalMine = GetGameTimer()

        TriggerServerEvent('dbd_mining:server:mine', zoneId, oreIdx, tool.item)
    end)
end)

-- ─── Mine result from server ─────────────────────────────────────────────────

RegisterNetEvent('dbd_mining:client:mineResult', function(success, payload)
    if not success then
        if payload and payload.reason then
            Notify(payload.reason, 'error')
        end
        return
    end

    if Config.Animations.Pickup.dict ~= '' then
        Citizen.CreateThread(function()
            PlayPickupAnimation()
        end)
    end

    if payload and payload.items then
        for _, item in ipairs(payload.items) do
            Notify(('+ %d %s'):format(item.amount, item.item), 'success', 2500)
        end
    end
end)