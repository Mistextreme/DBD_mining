-- Leaderboard query: returns sorted top-N rows to the requesting client

local SORT_MAP = {
    xp          = 'xp',
    total_ores  = 'total_ores',
    nodes_mined = 'mined',
}

RegisterNetEvent('dbd_mining:server:requestLeaderboard', function(sortKey)
    local src = source

    local col   = SORT_MAP[sortKey] or SORT_MAP[Config.UI.Leaderboard.DefaultSort] or 'xp'
    local limit = math.max(1, Config.UI.Leaderboard.Limit or 50)

    MySQL.query(
        ('SELECT identifier, name, xp, level, total_ores, mined FROM dbs_mining ORDER BY %s DESC LIMIT %d'):format(col, limit),
        {},
        function(result)
            TriggerClientEvent('dbd_mining:client:receiveLeaderboard', src, result or {}, sortKey)
        end
    )
end)