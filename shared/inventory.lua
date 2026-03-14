-- Server-side inventory abstraction
-- Exposes: Inventory.Give, Inventory.Remove, Inventory.Has, Inventory.GetCount

Inventory = {}

local invType = Config.Integrations.Inventory.Type

if invType == 'ox' then
    function Inventory.Give(src, item, amount)
        exports.ox_inventory:AddItem(src, item, amount)
    end

    function Inventory.Remove(src, item, amount)
        return exports.ox_inventory:RemoveItem(src, item, amount)
    end

    function Inventory.Has(src, item, amount)
        return exports.ox_inventory:GetItemCount(src, item) >= (amount or 1)
    end

    function Inventory.GetCount(src, item)
        return exports.ox_inventory:GetItemCount(src, item) or 0
    end

elseif invType == 'qb' then
    local QBCore = exports['qb-core']:GetCoreObject()

    function Inventory.Give(src, item, amount)
        local p = QBCore.Functions.GetPlayer(src)
        if not p then return end
        p.Functions.AddItem(item, amount)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[item], 'add')
    end

    function Inventory.Remove(src, item, amount)
        local p = QBCore.Functions.GetPlayer(src)
        if not p then return false end
        return p.Functions.RemoveItem(item, amount)
    end

    function Inventory.Has(src, item, amount)
        local p = QBCore.Functions.GetPlayer(src)
        if not p then return false end
        local d = p.Functions.GetItemByName(item)
        return d ~= nil and d.amount >= (amount or 1)
    end

    function Inventory.GetCount(src, item)
        local p = QBCore.Functions.GetPlayer(src)
        if not p then return 0 end
        local d = p.Functions.GetItemByName(item)
        return d and d.amount or 0
    end

elseif invType == 'qs' then
    function Inventory.Give(src, item, amount)
        exports['qs-inventory']:AddItem(src, item, amount)
    end

    function Inventory.Remove(src, item, amount)
        return exports['qs-inventory']:RemoveItem(src, item, amount)
    end

    function Inventory.Has(src, item, amount)
        return exports['qs-inventory']:GetItemCount(src, item) >= (amount or 1)
    end

    function Inventory.GetCount(src, item)
        return exports['qs-inventory']:GetItemCount(src, item) or 0
    end

elseif invType == 'esx' then
    local ESX
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    if not ESX then
        local ok, obj = pcall(function() return exports['es_extended']:getSharedObject() end)
        if ok then ESX = obj end
    end

    function Inventory.Give(src, item, amount)
        local p = ESX and ESX.GetPlayerFromId(src)
        if p then p.addInventoryItem(item, amount) end
    end

    function Inventory.Remove(src, item, amount)
        local p = ESX and ESX.GetPlayerFromId(src)
        if not p then return false end
        p.removeInventoryItem(item, amount)
        return true
    end

    function Inventory.Has(src, item, amount)
        local p = ESX and ESX.GetPlayerFromId(src)
        if not p then return false end
        local d = p.getInventoryItem(item)
        return d ~= nil and d.count >= (amount or 1)
    end

    function Inventory.GetCount(src, item)
        local p = ESX and ESX.GetPlayerFromId(src)
        if not p then return 0 end
        local d = p.getInventoryItem(item)
        return d and d.count or 0
    end
end