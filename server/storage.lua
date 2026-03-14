-- MySQL CRUD and in-memory cache for dbd_mining player records

PlayerStorage = {}

local cache = {}   -- [identifier] = data table (live copy)

-- ─── Internal DB ops ─────────────────────────────────────────────────────────

local function dbLoad(identifier, cb)
    MySQL.query('SELECT * FROM dbs_mining WHERE identifier = ?', { identifier }, function(result)
        cb(result and result[1] or nil)
    end)
end

local function dbInsert(identifier, name, cb)
    MySQL.insert(
        [[INSERT INTO dbs_mining
            (identifier, xp, level, name, mined, total_ores, best_streak, rare_finds, last_seen)
          VALUES (?, 0, 1, ?, 0, 0, 0, 0, NOW())]],
        { identifier, name },
        function()
            cb({
                identifier  = identifier,
                xp          = 0,
                level       = 1,
                name        = name,
                mined       = 0,
                total_ores  = 0,
                best_streak = 0,
                rare_finds  = 0,
            })
        end
    )
end

local function dbSave(identifier, data)
    MySQL.update(
        [[UPDATE dbs_mining
          SET xp = ?, level = ?, name = ?, mined = ?, total_ores = ?,
              best_streak = ?, rare_finds = ?, last_seen = NOW()
          WHERE identifier = ?]],
        {
            data.xp          or 0,
            data.level       or 1,
            data.name        or 'Unknown',
            data.mined       or 0,
            data.total_ores  or 0,
            data.best_streak or 0,
            data.rare_finds  or 0,
            identifier,
        }
    )
end

-- ─── Public API ──────────────────────────────────────────────────────────────

function PlayerStorage.GetCached(identifier)
    return cache[identifier]
end

function PlayerStorage.SetCached(identifier, data)
    cache[identifier] = data
end

function PlayerStorage.Save(identifier, data)
    if not data then return end
    dbSave(identifier, data)
end

function PlayerStorage.FlushCache(identifier)
    local data = cache[identifier]
    if data then
        dbSave(identifier, data)
        cache[identifier] = nil
    end
end

--- Load player from DB (or insert defaults) then populate the cache and call cb(data).
function PlayerStorage.CreateOrLoad(identifier, name, cb)
    dbLoad(identifier, function(row)
        if row then
            cache[identifier] = row
            cb(row)
        else
            dbInsert(identifier, name, function(newRow)
                cache[identifier] = newRow
                cb(newRow)
            end)
        end
    end)
end

-- ─── Auto-save loop (every 5 minutes) ───────────────────────────────────────

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        for id, data in pairs(cache) do
            dbSave(id, data)
        end
        if Config.Core.Debug then
            print('[DBD Mining] Auto-save tick completed.')
        end
    end
end)

-- ─── Player connect / disconnect ─────────────────────────────────────────────

RegisterNetEvent('dbd_mining:server:requestPlayerData', function()
    local src        = source
    local identifier = Framework.GetIdentifier(src)
    local name       = Framework.GetName(src)

    if not identifier then
        if Config.Core.Debug then
            print('[DBD Mining] requestPlayerData: could not resolve identifier for src ' .. src)
        end
        return
    end

    local cached = PlayerStorage.GetCached(identifier)
    if cached then
        TriggerClientEvent('dbd_mining:client:receivePlayerData', src, cached)
        return
    end

    PlayerStorage.CreateOrLoad(identifier, name, function(data)
        TriggerClientEvent('dbd_mining:client:receivePlayerData', src, data)
    end)
end)

AddEventHandler('playerDropped', function()
    local identifier = Framework.GetIdentifier(source)
    if identifier then
        PlayerStorage.FlushCache(identifier)
    end
end)