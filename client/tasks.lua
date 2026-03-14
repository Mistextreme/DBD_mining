-- Task NPC: spawn, targeting, and local event routing

local taskNpcHandle = nil

-- ─── NPC spawn ───────────────────────────────────────────────────────────────

local function spawnTaskNpc()
    if not Config.Mining.Tasks.Enabled then return end

    local cfg = Config.Mining.Meta.TaskNpc
    if not cfg then
        print('[DBD Mining] Warning: Config.Mining.Meta.TaskNpc is not defined.')
        return
    end

    local hash = GetHashKey(cfg.model)
    RequestModel(hash)

    local t = 0
    while not HasModelLoaded(hash) do
        Citizen.Wait(100)
        t = t + 100
        if t > 10000 then
            print('[DBD Mining] Failed to load task NPC model: ' .. cfg.model)
            return
        end
    end

    taskNpcHandle = CreatePed(
        4,
        hash,
        cfg.coords.x,
        cfg.coords.y,
        cfg.coords.z - 1.0,
        cfg.coords.w,
        false,
        true
    )

    SetEntityHeading(taskNpcHandle, cfg.coords.w)
    SetBlockingOfNonTemporaryEvents(taskNpcHandle, true)
    SetPedDiesWhenInjured(taskNpcHandle, false)
    SetPedCanRagdoll(taskNpcHandle, false)
    FreezeEntityPosition(taskNpcHandle, true)
    SetEntityInvincible(taskNpcHandle, true)
    SetPedFleeAttributes(taskNpcHandle, 0, false)
    SetPedCombatAttributes(taskNpcHandle, 17, true)
    SetModelAsNoLongerNeeded(hash)

    RegisterTaskNpcTarget(taskNpcHandle)
end

-- ─── Local event: open tasks menu ───────────────────────────────────────────

AddEventHandler('dbd_mining:client:openTasksMenu', function()
    TriggerServerEvent('dbd_mining:server:requestTasks')
end)

-- ─── Lifecycle ───────────────────────────────────────────────────────────────

AddEventHandler('onClientResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    Citizen.Wait(1500)
    spawnTaskNpc()
end)

AddEventHandler('onClientResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if taskNpcHandle and DoesEntityExist(taskNpcHandle) then
        DeleteEntity(taskNpcHandle)
    end
    taskNpcHandle = nil
end)