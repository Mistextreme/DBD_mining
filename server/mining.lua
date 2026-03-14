-- Server-authoritative mining reward: validate level/tool, give items, update stats

-- [zoneId_oreIdx] = os.time() of last mine (server-side cooldown guard)
local nodeCooldowns = {}

local function nodeKey(zoneId, oreIdx)
    return ('%d_%d'):format(zoneId, oreIdx)
end

local function nodeOnCooldown(zoneId, oreIdx)
    if Config.Mining.Cooldowns.Node <= 0 then return false end
    local last = nodeCooldowns[nodeKey(zoneId, oreIdx)]
    return last and (os.time() - last) < Config.Mining.Cooldowns.Node
end

local function setNodeCooldown(zoneId, oreIdx)
    nodeCooldowns[nodeKey(zoneId, oreIdx)] = os.time()
end

-- ─── Main mine event ─────────────────────────────────────────────────────────

RegisterNetEvent('dbd_mining:server:mine', function(zoneId, oreIdx, toolItem)
    local src        = source
    local identifier = Framework.GetIdentifier(src)

    if not identifier then return end

    -- Zone existence
    local zone = Config.Mining.Zones[zoneId]
    if not zone then
        TriggerClientEvent('dbd_mining:client:mineResult', src, false,
            { reason = _L('notify.missing-item') })
        return
    end

    -- Node cooldown
    if nodeOnCooldown(zoneId, oreIdx) then
        TriggerClientEvent('dbd_mining:client:mineResult', src, false,
            { reason = _L('notify.missing-item') })
        return
    end

    -- Cached player data
    local data = PlayerStorage.GetCached(identifier)
    if not data then
        TriggerClientEvent('dbd_mining:client:mineResult', src, false,
            { reason = _L('notify.missing-item') })
        return
    end

    -- Level check
    if (data.level or 1) < zone.level then
        TriggerClientEvent('dbd_mining:client:mineResult', src, false,
            { reason = _L('notify.not-experienced') })
        return
    end

    -- Tool validation
    local toolEntry = nil
    local toolUpper = string.upper(toolItem or '')
    for _, t in ipairs(Config.Mining.Tools) do
        if string.upper(t.item) == toolUpper then
            toolEntry = t
            break
        end
    end

    if not toolEntry then
        TriggerClientEvent('dbd_mining:client:mineResult', src, false,
            { reason = _L('notify.missing-pickaxe') })
        return
    end

    if (data.level or 1) < toolEntry.level then
        TriggerClientEvent('dbd_mining:client:mineResult', src, false,
            { reason = _L('notify.missing-pickaxe') })
        return
    end

    -- Give reward items and tally the actual ore count
    local givenItems  = {}
    local totalOreSum = 0

    for _, reward in ipairs(zone.reward) do
        local base   = math.random(reward.min, reward.max)
        local bonus  = math.random(toolEntry.bonus.min, toolEntry.bonus.max)
        local amount = base + bonus
        if amount > 0 then
            Inventory.Give(src, reward.item, amount)
            givenItems[#givenItems + 1] = { item = reward.item, amount = amount }
            totalOreSum = totalOreSum + amount
        end
    end

    -- Update player stats:
    --   mined      = number of rock nodes mined (always +1 per action)
    --   total_ores = cumulative sum of all individual ores received
    data.mined      = (data.mined      or 0) + 1
    data.total_ores = (data.total_ores or 0) + totalOreSum
    PlayerStorage.SetCached(identifier, data)

    -- XP
    local xpAmount = math.random(zone.xp.min, zone.xp.max)
    TriggerEvent('dbd_mining:server:addXP', src, xpAmount)

    -- Cooldown
    setNodeCooldown(zoneId, oreIdx)

    -- Respond to client
    TriggerClientEvent('dbd_mining:client:mineResult', src, true, { items = givenItems })

    -- Update task widget if applicable
    if Config.Mining.Tasks.Enabled then
        UpdatePlayerTaskWidget(src)
    end

    if Config.Core.Debug then
        print(('[DBD Mining] %s (src:%d) mined zone %d ore %d  |  +%dxp  |  ores given: %d'):format(
            Framework.GetName(src), src, zoneId, oreIdx, xpAmount, totalOreSum))
    end
end)