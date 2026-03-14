-- XP gain display and level-up notification

RegisterNetEvent('dbd_mining:client:xpGained', function(xpAmount, newXp, newLevel, levelUp)
    Mining.PlayerData.xp    = newXp
    Mining.PlayerData.level = newLevel

    if levelUp then
        Notify(('Level up! You are now level %d'):format(newLevel), 'success', 5000)
    end

    if xpAmount and xpAmount > 0 then
        local maxLevel = GetMaxLevel()
        BeginTextCommandDisplayHelp('STRING')
        AddTextComponentSubstringPlayerName(
            ('+%d XP  |  Level %d / %d'):format(xpAmount, newLevel, maxLevel)
        )
        EndTextCommandDisplayHelp(0, false, true, 2500)
    end
end)