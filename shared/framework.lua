-- Server-side framework abstraction
-- Exposes: Framework.GetPlayer(src), Framework.GetIdentifier(src), Framework.GetName(src)

Framework = {}

local fw = Config.Core.Framework

if fw == 'esx' then
    local ESX
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    if not ESX then
        local ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
        if ok then ESX = obj end
    end

    function Framework.GetPlayer(src)
        return ESX and ESX.GetPlayerFromId(src) or nil
    end

    function Framework.GetIdentifier(src)
        local p = Framework.GetPlayer(src)
        return p and p.identifier or nil
    end

    function Framework.GetName(src)
        local p = Framework.GetPlayer(src)
        return p and p.getName() or 'Unknown'
    end

elseif fw == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()

    function Framework.GetPlayer(src)
        return QBCore.Functions.GetPlayer(src)
    end

    function Framework.GetIdentifier(src)
        local p = Framework.GetPlayer(src)
        return p and p.PlayerData.citizenid or nil
    end

    function Framework.GetName(src)
        local p = Framework.GetPlayer(src)
        if not p then return 'Unknown' end
        local ci = p.PlayerData.charinfo
        return ci and (ci.firstname .. ' ' .. ci.lastname) or 'Unknown'
    end

elseif fw == 'qbx' or fw == 'abx' then
    function Framework.GetPlayer(src)
        return exports.qbx_core:GetPlayer(src)
    end

    function Framework.GetIdentifier(src)
        local p = Framework.GetPlayer(src)
        return p and p.PlayerData.citizenid or nil
    end

    function Framework.GetName(src)
        local p = Framework.GetPlayer(src)
        if not p then return 'Unknown' end
        local ci = p.PlayerData.charinfo
        return ci and (ci.firstname .. ' ' .. ci.lastname) or 'Unknown'
    end

elseif fw == 'ox' then
    function Framework.GetPlayer(src)
        return exports.ox_core:GetPlayer(src)
    end

    function Framework.GetIdentifier(src)
        local p = Framework.GetPlayer(src)
        return p and p.identifier or nil
    end

    function Framework.GetName(src)
        local p = Framework.GetPlayer(src)
        return p and (p.firstName .. ' ' .. p.lastName) or 'Unknown'
    end
end