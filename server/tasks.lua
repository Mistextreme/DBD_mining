-- Task accept / hand-in / cancel with server-authoritative validation

-- [identifier] = taskId (number) or nil
local playerTasks = {}

-- ─── Helpers ─────────────────────────────────────────────────────────────────

local function buildTaskPayload(src, identifier, currentId)
    local counts        = {}
    local progressLines = {}

    for _, item in ipairs(Config.Mining.Tasks.OreItems) do
        counts[item] = Inventory.GetCount(src, item)
    end

    if currentId and Config.Mining.Tasks.List[currentId] then
        for _, req in ipairs(Config.Mining.Tasks.List[currentId].requirements) do
            progressLines[#progressLines + 1] = {
                item     = req.item,
                required = req.amount,
                current  = counts[req.item] or 0,
            }
        end
    end

    return counts, progressLines
end

-- ─── Request tasks menu ──────────────────────────────────────────────────────

RegisterNetEvent('dbd_mining:server:requestTasks', function()
    local src        = source
    local identifier = Framework.GetIdentifier(src)
    if not identifier then return end

    local currentId             = playerTasks[identifier]
    local counts, progressLines = buildTaskPayload(src, identifier, currentId)

    TriggerClientEvent('dbd_mining:client:openTasksNUI', src, {
        tasks         = Config.Mining.Tasks.List,
        currentTaskId = currentId,
        counts        = counts,
        progressLines = progressLines,
    })
end)

-- ─── Accept task ─────────────────────────────────────────────────────────────

RegisterNetEvent('dbd_mining:server:taskAccept', function(taskId)
    local src        = source
    local identifier = Framework.GetIdentifier(src)
    if not identifier then return end

    if not Config.Mining.Tasks.List[taskId] then return end

    -- Already has an active task
    if playerTasks[identifier] then
        TriggerClientEvent('dbd_mining:client:notify', src, _L('notify.missing-item'), 'error')
        return
    end

    playerTasks[identifier] = taskId

    local counts, progressLines = buildTaskPayload(src, identifier, taskId)

    TriggerClientEvent('dbd_mining:client:openTasksNUI', src, {
        tasks         = Config.Mining.Tasks.List,
        currentTaskId = taskId,
        counts        = counts,
        progressLines = progressLines,
    })

    TriggerClientEvent('dbd_mining:client:updateTaskProgress', src, true, progressLines)
end)

-- ─── Hand in task ────────────────────────────────────────────────────────────

RegisterNetEvent('dbd_mining:server:taskHandIn', function()
    local src        = source
    local identifier = Framework.GetIdentifier(src)
    if not identifier then return end

    local taskId = playerTasks[identifier]
    if not taskId then return end

    local task = Config.Mining.Tasks.List[taskId]
    if not task then
        playerTasks[identifier] = nil
        return
    end

    -- Validate all requirements
    for _, req in ipairs(task.requirements) do
        if not Inventory.Has(src, req.item, req.amount) then
            TriggerClientEvent('dbd_mining:client:notify', src, _L('notify.no-item'), 'error')
            return
        end
    end

    -- Consume items
    for _, req in ipairs(task.requirements) do
        Inventory.Remove(src, req.item, req.amount)
    end

    -- Award XP
    local xpReward = task.xp or 0

    if Config.Mining.Tasks.GlobalXpBoostExport then
        local ok, mult = pcall(function()
            return exports[Config.Mining.Tasks.GlobalXpBoostExport]:GetXPMultiplier(src)
        end)
        if ok and type(mult) == 'number' and mult > 0 then
            xpReward = math.floor(xpReward * mult)
        end
    end

    TriggerEvent('dbd_mining:server:addXP', src, xpReward)

    playerTasks[identifier] = nil

    TriggerClientEvent('dbd_mining:client:closeTasksNUI', src)
    TriggerClientEvent('dbd_mining:client:updateTaskProgress', src, false, {})
end)

-- ─── Cancel task ─────────────────────────────────────────────────────────────

RegisterNetEvent('dbd_mining:server:taskCancel', function()
    local src        = source
    local identifier = Framework.GetIdentifier(src)
    if not identifier then return end

    playerTasks[identifier] = nil

    TriggerClientEvent('dbd_mining:client:closeTasksNUI', src)
    TriggerClientEvent('dbd_mining:client:updateTaskProgress', src, false, {})
end)

-- ─── Update task widget (called from mining.lua after a successful mine) ──────

function UpdatePlayerTaskWidget(src)
    local identifier = Framework.GetIdentifier(src)
    if not identifier then return end

    local taskId = playerTasks[identifier]
    if not taskId then return end

    local task = Config.Mining.Tasks.List[taskId]
    if not task then return end

    local _, progressLines = buildTaskPayload(src, identifier, taskId)
    TriggerClientEvent('dbd_mining:client:updateTaskProgress', src, true, progressLines)
end