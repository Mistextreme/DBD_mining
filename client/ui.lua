-- Leaderboard open/close, NUI focus management, and NUI callback bindings

local leaderboardOpen = false

-- ─── Leaderboard helpers ─────────────────────────────────────────────────────

local function openLeaderboard(rows, sortKey)
    if leaderboardOpen then return end
    leaderboardOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action  = 'open',
        rows    = rows    or {},
        sortKey = sortKey or Config.UI.Leaderboard.DefaultSort,
    })
end

local function closeLeaderboard()
    leaderboardOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end

-- ─── Leaderboard command ─────────────────────────────────────────────────────

if Config.UI.Leaderboard.Enabled then
    RegisterCommand(Config.UI.Leaderboard.Command, function()
        if leaderboardOpen then
            closeLeaderboard()
            return
        end
        TriggerServerEvent('dbd_mining:server:requestLeaderboard', Config.UI.Leaderboard.DefaultSort)
    end, false)

    if Config.UI.Leaderboard.Keybind then
        RegisterKeyMapping(
            Config.UI.Leaderboard.Command,
            'Open Mining Leaderboard',
            'keyboard',
            Config.UI.Leaderboard.Keybind
        )
    end
end

-- ─── Receive leaderboard data ────────────────────────────────────────────────

RegisterNetEvent('dbd_mining:client:receiveLeaderboard', function(rows, sortKey)
    openLeaderboard(rows, sortKey)
end)

-- ─── Task UI net events ──────────────────────────────────────────────────────

RegisterNetEvent('dbd_mining:client:openTasksNUI', function(data)
    -- Close leaderboard if somehow open
    if leaderboardOpen then closeLeaderboard() end
    SetNuiFocus(true, true)
    SendNUIMessage({
        action        = 'openTasks',
        tasks         = data.tasks         or {},
        currentTaskId = data.currentTaskId,
        counts        = data.counts        or {},
        progressLines = data.progressLines or {},
    })
end)

RegisterNetEvent('dbd_mining:client:closeTasksNUI', function()
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeTasks' })
end)

RegisterNetEvent('dbd_mining:client:updateTaskProgress', function(visible, progressLines)
    SendNUIMessage({
        action             = 'updateTaskProgress',
        showProgressWidget = visible,
        progressLines      = progressLines or {},
    })
end)

-- ─── NUI callbacks ───────────────────────────────────────────────────────────

RegisterNUICallback('close', function(_, cb)
    closeLeaderboard()
    cb({})
end)

RegisterNUICallback('closeTasks', function(_, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeTasks' })
    cb({})
end)

RegisterNUICallback('taskAccept', function(data, cb)
    TriggerServerEvent('dbd_mining:server:taskAccept', tonumber(data.taskId))
    cb({})
end)

RegisterNUICallback('taskHandIn', function(_, cb)
    TriggerServerEvent('dbd_mining:server:taskHandIn')
    cb({})
end)

RegisterNUICallback('taskCancel', function(_, cb)
    TriggerServerEvent('dbd_mining:server:taskCancel')
    cb({})
end)