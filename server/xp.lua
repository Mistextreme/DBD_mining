-- XP addition, level resolution, XP bomb doubling, and level-up broadcast

local function getMaxLevel()
    local max = 1
    for k in pairs(Config.Mining.XP.Table) do
        if k > max then max = k end
    end
    return max
end

local function getLevelFromXP(xp)
    local maxLevel = getMaxLevel()
    for i = maxLevel, 1, -1 do
        if Config.Mining.XP.Table[i] and xp >= Config.Mining.XP.Table[i] then
            return i
        end
    end
    return 1
end

-- ─── Core XP event ───────────────────────────────────────────────────────────

AddEventHandler('dbd_mining:server:addXP', function(src, amount)
    if not src or not amount or amount <= 0 then return end

    local identifier = Framework.GetIdentifier(src)
    if not identifier then return end

    local data = PlayerStorage.GetCached(identifier)
    if not data then return end

    local finalAmount = amount

    -- XP bomb: double XP if player carries a bonus item
    if Config.Mining.XP.UseXPBomb then
        for _, bonusItem in ipairs(Config.Mining.XP.BonusItems or {}) do
            if Inventory.Has(src, bonusItem, 1) then
                finalAmount = finalAmount * 2
                break
            end
        end
    end

    -- External global XP multiplier export
    if Config.Mining.Tasks.GlobalXpBoostExport then
        local ok, mult = pcall(function()
            return exports[Config.Mining.Tasks.GlobalXpBoostExport]:GetXPMultiplier(src)
        end)
        if ok and type(mult) == 'number' and mult > 0 then
            finalAmount = math.floor(finalAmount * mult)
        end
    end

    local maxLevel = getMaxLevel()
    local oldLevel = data.level or 1
    local newXP    = (data.xp   or 0) + finalAmount
    local newLevel = getLevelFromXP(newXP)

    -- Cap at max level
    if newLevel >= maxLevel then
        newLevel = maxLevel
        newXP    = math.max(newXP, Config.Mining.XP.Table[maxLevel] or newXP)
    end

    local levelUp = newLevel > oldLevel

    data.xp    = newXP
    data.level = newLevel
    PlayerStorage.SetCached(identifier, data)
    PlayerStorage.Save(identifier, data)

    TriggerClientEvent('dbd_mining:client:xpGained', src, finalAmount, newXP, newLevel, levelUp)

    if Config.Core.Debug then
        print(('[DBD Mining] XP: src=%d  +%d (final)  total=%d  level=%d%s'):format(
            src, finalAmount, newXP, newLevel, levelUp and '  [LEVEL UP]' or ''))
    end
end)

-- ─── Exported helper for other resources ─────────────────────────────────────

exports('AddMiningXP', function(src, amount)
    TriggerEvent('dbd_mining:server:addXP', src, amount)
end)