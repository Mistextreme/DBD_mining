-- Client-side bootstrap: shared state, framework init, player data

Mining = Mining or {}
Mining.PlayerData = {
    level      = 1,
    xp         = 0,
    identifier = nil,
}
Mining.IsMining       = false
Mining.CooldownActive = false

local fw = Config.Core.Framework

-- ─── Framework-specific hooks ────────────────────────────────────────────────

if fw == 'esx' then
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        Mining.PlayerData.identifier = xPlayer.identifier
        TriggerServerEvent('dbd_mining:server:requestPlayerData')
    end)

    AddEventHandler('esx:onPlayerLogout', function()
        Mining.PlayerData = { level = 1, xp = 0, identifier = nil }
    end)

elseif fw == 'qb' then
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        TriggerServerEvent('dbd_mining:server:requestPlayerData')
    end)

    AddEventHandler('QBCore:Client:OnPlayerUnload', function()
        Mining.PlayerData = { level = 1, xp = 0, identifier = nil }
    end)

elseif fw == 'qbx' or fw == 'abx' then
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        TriggerServerEvent('dbd_mining:server:requestPlayerData')
    end)

    AddEventHandler('QBCore:Client:OnPlayerUnload', function()
        Mining.PlayerData = { level = 1, xp = 0, identifier = nil }
    end)

elseif fw == 'ox' then
    AddEventHandler('ox:playerLoaded', function()
        TriggerServerEvent('dbd_mining:server:requestPlayerData')
    end)
end

-- ─── Resource start fallback ─────────────────────────────────────────────────

AddEventHandler('onClientResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    Citizen.Wait(500)
    TriggerServerEvent('dbd_mining:server:requestPlayerData')
end)

-- ─── Receive player data from server ─────────────────────────────────────────

RegisterNetEvent('dbd_mining:client:receivePlayerData', function(data)
    if not data then return end
    Mining.PlayerData.level = data.level or 1
    Mining.PlayerData.xp    = data.xp    or 0
    if Config.Core.Debug then
        print(('[DBD Mining] Player data received — Level: %d | XP: %d'):format(
            Mining.PlayerData.level, Mining.PlayerData.xp))
    end
end)

-- ─── Server-side notify forwarding ───────────────────────────────────────────

RegisterNetEvent('dbd_mining:client:notify', function(msg, nType)
    Notify(msg, nType or 'inform')
end)

if Config.Core.Debug then
    print('[DBD Mining] Client init loaded — framework: ' .. fw)
end