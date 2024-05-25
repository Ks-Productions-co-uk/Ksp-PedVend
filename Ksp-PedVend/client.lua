local QBCore = exports['qb-core']:GetCoreObject()
local callPoliceProbability = 30 -- 30% chance the ped will call the police
local sellDistance = 3.5
local inputOpen = false
local lastSellTime = 0
local cooldownNotified = false
local freezeDuration = 10000
local currentObjects = {}
local currentBlips = {}
local Items = Config.Items

function EnumeratePeds()
    return coroutine.wrap(function()
        local iter, ped = FindFirstPed()
        if not ped then return end
        local ok
        repeat
            if IsPedValidNPC(ped) then
                coroutine.yield(ped)
            end
            ok, ped = FindNextPed(iter)
        until not ok
        EndFindPed(iter)
    end)
end

function IsPedValidNPC(ped)
    return not IsPedAPlayer(ped) and IsPedHuman(ped) and not IsPedDeadOrDying(ped, true) and not IsPedInAnyVehicle(ped, true)
end

function OpenMainMenu()
    local mainMenuOptions = {
        {
            header = "Selling Menu",
            isMenuHeader = true
        }
    }

    for category, items in pairs(Items) do
        table.insert(mainMenuOptions, {
            header = string.format("<span style='margin-left: 10px;'>%s</span>", category),
            params = {
                event = "ksp-pedvend:openCategoryMenu",
                args = {
                    category = category
                }
            }
        })
    end

    table.insert(mainMenuOptions, {
        header = "<span style='margin-left: 10px;'>Close Menu</span>",
        params = {
            event = "ksp-pedvend:closeMenu"
        }
    })

    exports['qb-menu']:openMenu(mainMenuOptions)
end

function OpenCategoryMenu(category)
    local categoryMenuOptions = {
        {
            header = "<span style='margin-left: 10px;'>Back to Main Menu</span>",
            params = {
                event = "ksp-pedvend:openMainMenu"
            }
        }
    }

    for _, item in ipairs(Items[category]) do
        table.insert(categoryMenuOptions, {
            header = string.format("<span style='margin-left: 10px;'>%s - $%s</span>", item.label, item.price),
            params = {
                event = "ksp-pedvend:selectQuantity",
                args = {
                    item = item.name
                }
            }
        })
    end

    table.insert(categoryMenuOptions, {
        header = "<span style='margin-left: 10px;'>Close Menu</span>",
        params = {
            event = "ksp-pedvend:closeMenu"
        }
    })

    exports['qb-menu']:openMenu(categoryMenuOptions)
end

RegisterNetEvent('playCashSound')
AddEventHandler('playCashSound', function()
    PlaySoundFrontend(-1, "LOCAL_PLYR_CASH_COUNTER_COMPLETE", "DLC_HEISTS_GENERAL_FRONTEND_SOUNDS", true)
end)

RegisterNetEvent('ksp-pedvend:selectQuantity')
AddEventHandler('ksp-pedvend:selectQuantity', function(data)
    local currentTime = GetGameTimer()
    local timeLeft = (Config.SellCooldown * 1000) - (currentTime - lastSellTime)
    
    if timeLeft > 0 then
        TriggerEvent('QBCore:Notify', "You need to wait " .. math.ceil(timeLeft / 1000) .. " seconds before selling again.", 'error')
        return
    end

    if inputOpen then return end
    inputOpen = true
    local item = data.item
    local dialog = exports['qb-input']:ShowInput({
        header = "Sell " .. item,
        submitText = "Sell",
        inputs = {
            {
                text = "Quantity",
                name = "quantity",
                type = "number",
                isRequired = true
            }
        }
    })

    if dialog then
        local quantity = tonumber(dialog.quantity)
        if quantity and quantity > 0 then
            local itemConfig = nil
            for category, items in pairs(Items) do
                for _, v in ipairs(items) do
                    if v.name == item then
                        itemConfig = v
                        break
                    end
                end
                if itemConfig then break end
            end

            if itemConfig then
                local duration = math.min(itemConfig.price * quantity * 10, 60000) -- Adjust duration based on total price, with a max of 60 seconds
                TriggerEvent('ksp-pedvend:progressSell', duration, item, quantity, itemConfig.price)

                -- Call police with the specified probability
                if math.random(1, 100) <= callPoliceProbability then
                    TriggerEvent('ksp-pedvend:callPolice', item, quantity)
                end
            else
                TriggerEvent('QBCore:Notify', "Invalid item.", 'error')
            end
        else
            TriggerEvent('QBCore:Notify', "Invalid quantity.", 'error')
        end
    end
    inputOpen = false
end)

RegisterNetEvent('ksp-pedvend:closeMenu')
AddEventHandler('ksp-pedvend:closeMenu', function()
    exports['qb-menu']:closeMenu()
    lastMenuCloseTime = GetGameTimer()
end)

RegisterNetEvent('ksp-pedvend:openMainMenu')
AddEventHandler('ksp-pedvend:openMainMenu', function()
    OpenMainMenu()
end)

RegisterNetEvent('ksp-pedvend:openCategoryMenu')
AddEventHandler('ksp-pedvend:openCategoryMenu', function(data)
    OpenCategoryMenu(data.category)
end)

RegisterNetEvent('ksp-pedvend:notifyCooldown')
AddEventHandler('ksp-pedvend:notifyCooldown', function(timeLeft)
    if not cooldownNotified then
        TriggerEvent('QBCore:Notify', "You need to wait " .. timeLeft .. " seconds before selling again.", 'error')
        cooldownNotified = true
    end
end)

RegisterNetEvent('ksp-pedvend:progressSell')
AddEventHandler('ksp-pedvend:progressSell', function(duration, item, quantity, price)
    QBCore.Functions.Progressbar("sell_item", "Selling...", duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent('ksp-pedvend:completeSell', item, quantity, price)
        lastSellTime = GetGameTimer()
        cooldownNotified = false
    end, function() -- Cancel
        TriggerEvent('QBCore:Notify', "Sell canceled.", 'error')
        cooldownNotified = false
    end)
end)

RegisterNetEvent('ksp-pedvend:callPolice')
AddEventHandler('ksp-pedvend:callPolice', function(item, quantity)
    local playerCoords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent('police:server:policeAlert', 'Suspicious activity detected. Someone is trying to sell ' .. quantity .. ' of ' .. item)
end)

Citizen.CreateThread(function()
    for _, location in pairs(Config.SellLocations) do
        local object = CreateObject(GetHashKey(location.object), location.coords.x, location.coords.y, location.coords.z - 1, false, false, false)
        SetEntityHeading(object, location.coords.w)
        FreezeEntityPosition(object, true)

        local pedModel = GetHashKey("mp_m_shopkeep_01")
        RequestModel(pedModel)
        while not HasModelLoaded(pedModel) do
            Wait(1)
        end
        local ped = CreatePed(4, pedModel, location.coords.x, location.coords.y, location.coords.z - 1, (location.coords.w + 180.0) % 360, false, true)
        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedFleeAttributes(ped, 0, false)
        SetEntityInvincible(ped, true)

        -- Add target zone
        exports['qb-target']:AddBoxZone("sell_zone_" .. location.coords.x, vector3(location.coords.x, location.coords.y, location.coords.z + 1), 1.5, 1.5, {
            name = "sell_zone_" .. location.coords.x,
            heading = location.coords.w,
            debugPoly = false,
            minZ = location.coords.z,
            maxZ = location.coords.z + 2
        }, {
            options = {
                {
                    type = "client",
                    event = "ksp-pedvend:openMainMenu",
                    icon = "fas fa-cash-register",
                    label = "Sell Items",
                    action = function(entity)
                        FreezeEntityPosition(entity, true)
                        Citizen.SetTimeout(freezeDuration, function()
                            FreezeEntityPosition(entity, false)
                        end)
                        TriggerEvent("ksp-pedvend:openMainMenu")
                    end
                }
            },
            distance = 2.5
        })

        if Config.ShowBlips and location.blip then
            print("Creating blip for location: " .. location.blip.label)  -- Debug print
            local blip = AddBlipForCoord(location.coords.x, location.coords.y, location.coords.z)
            SetBlipSprite(blip, location.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, location.blip.scale)
            SetBlipColour(blip, location.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(location.blip.label)
            EndTextCommandSetBlipName(blip)
        else
            print("Blip creation skipped for location: " .. location.coords.x .. ", " .. location.coords.y)  -- Debug print
        end

        table.insert(currentObjects, object)
    end
end)

RegisterNetEvent('onResourceStop')
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, obj in ipairs(currentObjects) do
            DeleteObject(obj)
        end
    end
end)
