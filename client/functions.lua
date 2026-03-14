-- Client-side utilities: notify, progress bar, animations, tool and level helpers

local notifyType   = Config.Integrations.Notify.Type
local progressType = Config.Integrations.Progress.Type

-- ─── Notifications ───────────────────────────────────────────────────────────

function Notify(msg, nType, duration)
    nType    = nType    or 'inform'
    duration = duration or 4000

    if notifyType == 'ox' then
        lib.notify({
            title       = 'Mining',
            description = msg,
            type        = nType,
            duration    = duration,
        })

    elseif notifyType == 'qb' then
        local t = (nType == 'error') and 'error' or (nType == 'success') and 'success' or 'primary'
        exports['qb-core']:Notify(msg, t, duration)

    elseif notifyType == 'esx' then
        local t = (nType == 'error') and 'error' or 'success'
        exports['es_extended']:ShowNotification(msg, t)

    elseif notifyType == 'brutal' then
        exports['brutal_notification']:SendTextNotification(msg, nType, duration)

    else
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(true, false)
    end
end

-- ─── Progress bar ────────────────────────────────────────────────────────────

--- Displays a progress bar and calls onDone(true) on completion, onDone(false) on cancel.
--- Always runs the callback from its own thread so the caller never blocks.
function ShowProgress(label, duration, onDone)
    if progressType == 'ox' then
        Citizen.CreateThread(function()
            local completed = lib.progressBar({
                duration     = duration,
                label        = label,
                useWhileDead = false,
                canCancel    = true,
                disable      = { move = false, car = true, combat = true },
            })
            onDone(completed)
        end)

    elseif progressType == 'qb' then
        exports['qb-core']:Progressbar(
            'dbd_mining_progress',
            label,
            duration,
            false,  -- useWhileDead
            true,   -- canCancel
            { disableMovement = false, disableCarMovement = true, disableMouse = false, disableCombat = true },
            {},
            {},
            {},
            function() onDone(true)  end,
            function() onDone(false) end
        )

    else
        -- Fallback: time-based manual progress
        Citizen.CreateThread(function()
            Citizen.Wait(duration)
            onDone(true)
        end)
    end
end

-- ─── Animations ──────────────────────────────────────────────────────────────

function PlayMiningAnimation()
    local anim = Config.Animations.Mining
    if not anim or anim.dict == '' then return end

    RequestAnimDict(anim.dict)
    local t = 0
    while not HasAnimDictLoaded(anim.dict) do
        Citizen.Wait(20)
        t = t + 20
        if t > 4000 then return end
    end

    local ped = PlayerPedId()
    -- Pass -1 for duration so the loop flag keeps it playing until StopMiningAnimation is called
    TaskPlayAnim(ped, anim.dict, anim.clip, 8.0, -8.0, -1, anim.flag or 1, 0, false, false, false)
end

function StopMiningAnimation()
    local anim = Config.Animations.Mining
    if not anim or anim.dict == '' then return end
    StopAnimTask(PlayerPedId(), anim.dict, anim.clip, 3.0)
end

function PlayPickupAnimation()
    local anim = Config.Animations.Pickup
    if not anim or anim.dict == '' then return end

    RequestAnimDict(anim.dict)
    local t = 0
    while not HasAnimDictLoaded(anim.dict) do
        Citizen.Wait(20)
        t = t + 20
        if t > 4000 then return end
    end

    local ped = PlayerPedId()
    TaskPlayAnim(ped, anim.dict, anim.clip, 8.0, -8.0, anim.duration or 2000, anim.flag or 49, 0, false, false, false)
    Citizen.Wait(anim.duration or 2000)
    StopAnimTask(ped, anim.dict, anim.clip, 3.0)
end

-- ─── Tool detection ──────────────────────────────────────────────────────────

--- Returns the highest-tier eligible pickaxe currently in the player's weapon wheel, or nil.
function GetEquippedPickaxeTool()
    local ped = PlayerPedId()
    for i = #Config.Mining.Tools, 1, -1 do
        local tool = Config.Mining.Tools[i]
        if HasPedGotWeapon(ped, GetHashKey(tool.weapon), false) then
            if Mining.PlayerData.level >= tool.level then
                return tool
            end
        end
    end
    return nil
end

-- ─── XP / level helpers ──────────────────────────────────────────────────────

function GetMaxLevel()
    local max = 1
    for k in pairs(Config.Mining.XP.Table) do
        if k > max then max = k end
    end
    return max
end

function GetLevelFromXP(xp)
    local maxLevel = GetMaxLevel()
    for i = maxLevel, 1, -1 do
        if Config.Mining.XP.Table[i] and xp >= Config.Mining.XP.Table[i] then
            return i
        end
    end
    return 1
end