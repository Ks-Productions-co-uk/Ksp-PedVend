local QBCore = exports['qb-core']:GetCoreObject()
local sellCooldown = {}
local cooldownTime = Config.SellCooldown

RegisterServerEvent('ksp-pedvend:completeSell')
AddEventHandler('ksp-pedvend:completeSell', function(item, quantity, price)
    local src = source
    local xPlayer = QBCore.Functions.GetPlayer(src)
    local currentTime = os.time()

    if sellCooldown[src] and (currentTime - sellCooldown[src].lastSellTime) < cooldownTime then
        local timeLeft = cooldownTime - (currentTime - sellCooldown[src].lastSellTime)
        TriggerClientEvent('ksp-pedvend:notifyCooldown', src, timeLeft)
        return
    end

    local itemConfig = nil
    for category, items in pairs(Config.Items) do
        for _, v in ipairs(items) do
            if v.name == item then
                itemConfig = v
                break
            end
        end
        if itemConfig then break end
    end

    if not itemConfig then
        TriggerClientEvent('QBCore:Notify', src, "Invalid item.", 'error')
        return
    end

    local playerItem = xPlayer.Functions.GetItemByName(item)
    if playerItem and playerItem.amount >= quantity then
        local totalPrice = price * quantity
        xPlayer.Functions.RemoveItem(item, quantity)
        xPlayer.Functions.AddMoney('cash', totalPrice)
        TriggerClientEvent('QBCore:Notify', src, 'You sold ' .. quantity .. ' of ' .. itemConfig.label .. ' for $' .. totalPrice, 'success')
        TriggerClientEvent('playCashSound', src)
        sellCooldown[src] = { lastSellTime = currentTime }
    else
        TriggerClientEvent('QBCore:Notify', src, "You don't have enough " .. itemConfig.label .. " to sell.", 'error')
    end
end)
