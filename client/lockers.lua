QBCore = exports['qb-core']:GetCoreObject()
local locker = {}

RegisterNetEvent('prison:client:Locker', function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData.metadata.jailstatus == "jailed" then
        QBCore.Functions.Progressbar('opening_prisonlocker', 'OPENING', 2000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'anim@gangops@facility@servers@',
            anim = 'hotwire',
            flags = 16,
        }, {}, {}, function()
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent("qb-inventory:server:OpenInventory", "stash", "prisonstash_"..QBCore.Functions.GetPlayerData().citizenid)
            TriggerEvent("qb-inventory:client:SetCurrentStash", "prisonstash_"..QBCore.Functions.GetPlayerData().citizenid)
        end, function() end)
    end
end)

RegisterNetEvent('prison:client:ForceOpenLocker', function()
    local lockerInfo = exports['qb-input']:ShowInput({
        header = "Locker",
        submitText = "Open Locker",
        inputs = {
            {
                text = "Citizen ID",
                name = 'citizenid',
                type = 'text',
                isRequired = true,
            }
        }
    })
    if lockerInfo then
        if not lockerInfo.citizenid then return end
        QBCore.Functions.TriggerCallback('prison:server:DoesStashExist', function(stashExist)
            if stashExist then
                QBCore.Functions.Progressbar('opening_prisonlocker', 'OPENING', 2000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                    animDict = 'anim@gangops@facility@servers@',
                    anim = 'hotwire',
                    flags = 16,
                }, {}, {}, function()
                    ClearPedTasks(PlayerPedId())
                    TriggerServerEvent("qb-inventory:server:OpenInventory", "stash", "prisonstash_"..lockerInfo.citizenid)
                    TriggerEvent("qb-inventory:client:SetCurrentStash", "prisonstash_"..lockerInfo.citizenid)
                end, function() end)
            else
                QBCore.Functions.Notify('Locker is empty', 'error')
            end
        end, "prisonstash_"..locker.citizenid)
    else
        exports['qb-menu']:closeMenu()
    end
end)

RegisterNetEvent('prison:client:RemoveLockers', function()
    for _,v in pairs(locker) do DeleteObject(v) end
end)

RegisterNetEvent('prison:client:SpawnLockers', function()
	for k, v in pairs(Config.Lockers) do
		RequestModel(`p_cs_locker_01_s`)
        while not HasModelLoaded(`p_cs_locker_01_s`) do Wait(1) end
        locker[#locker+1] = CreateObject(`p_cs_locker_01_s`, v.coords.x, v.coords.y, v.coords.z - 1, false, false, false)
        SetEntityHeading(locker[#locker], v.coords.w - 180)
        FreezeEntityPosition(locker[#locker], true)

        exports['qb-target']:AddBoxZone("lockers"..k, v.coords, 1.5, 1.6, {
            name = "lockers"..k,
            heading = v.coords.w,
            debugPoly = false,
            minZ = v.coords.z-1,
            maxZ = v.coords.z+1.4,
        }, {
            options = {
                {
                    type = "client",
                    event = "prison:client:Locker",
                    icon = "fas fa-box-open",
                    label = "Locker",
                    canInteract = function() return QBCore.Functions.GetPlayerData().metadata.jailstatus == "jailed" end,
                },
                {
                    type = "client",
                    event = "prison:client:ForceOpenLocker",
                    icon = "fas fa-box-open",
                    label = "Force Open Locker",
                    job = { ['police'] = 0, ['lspd'] = 0, ['fib'] = 0, ['bcso'] = 0, },
                }
            },
            distance = 2.5,
        })
    end
end)
