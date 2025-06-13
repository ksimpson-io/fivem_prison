local resting = false
local training = false
local pedSpawned = false
local bikesOut = 0

---------------------------------------------------------------------- FUNCTIONS
function CreatePrisonBikeZone()
    local bikeZone = BoxZone:Create(
        vector3(1631.37, 2590.46, 45.55), 3.0, 5.0, {
        minZ = 44.55,
        maxZ = 48.55,
        heading = 0,
        debugPoly = false,
    })
    bikeZone:onPlayerInOut(function(isPointInside)
        if isPointInside then
        local text = " [E] Store Bike"
            exports['qb-core']:DrawText(text, 'left')
            InputIn = true
        else
            exports['qb-core']:HideText()
            InputIn = false
        end
    end)
end

function Hang()
    if not training and not resting then
        local ped = PlayerPedId()
        SetPedCoordsKeepVehicle(ped, 1775.83, 2497.6, 45.82)
        SetEntityHeading(ped, 219.2)
        training = true
        QBCore.Functions.Progressbar('doing_hang', 'Doing Pullups', (Config.Workout.Chinup.time * 1000), false, false, {
            disableMovement = true, --
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "amb@prop_human_muscle_chin_ups@male@base",
            anim = "base",
            flags = 8,
        }, {}, {}, function()
            training = false
            resting = true
            ClearPedTasks(PlayerPedId())
            SetTimeout(Config.Workout.Cooldown * 1000, function() resting = false end)
            QBCore.Functions.Notify("Work out completed", "success")
        end, function() -- Cancel
            QBCore.Functions.Notify("Just Breathe First", "error")
        end)
    else
        QBCore.Functions.Notify('Resting', 'primary')
    end
end

---------------------------------------------------------------------- EVENTS
RegisterNetEvent("prison:client:DoChinUp", function()
    if not training and not resting then
        Hang()
    else
        QBCore.Functions.Notify('You\'re resting', 'primary')
    end
end)

RegisterNetEvent('prison:client:DoYoga', function()
    local ped = PlayerPedId()

    if not training and not resting then
        FreezeEntityPosition(ped, true)
        if Config.psUI then
            exports['ps-ui']:Circle(function(success)
                if success then
                    TriggerEvent('animations:client:EmoteCommandStart', {"yoga"})
                    QBCore.Functions.Progressbar('doing_yoga', 'Doing Yoga', (Config.Workout.Yoga.time * 1000), false, false, {
                        disableMovement = true,
                        disableCarMovement = true,
                        disableMouse = false,
                        disableCombat = true,
                    }, {}, {}, {}, function()
                        training = false
                        resting = true
                        ClearPedTasks(ped)
                        FreezeEntityPosition(ped, false)
                        TriggerServerEvent('hud:server:RelieveStress', Config.Workout.Yoga.stress)
                        QBCore.Functions.Notify("You have a bit less stress", "success")
                    end, function()
                        LocalPlayer.state:set("inv_busy", false, true)
                        QBCore.Functions.Notify("Just Breathe First..", "error")
                    end)
                else
                    ClearPedTasks(ped)
                    FreezeEntityPosition(ped, false)
                    QBCore.Functions.Notify("Failed, focus..", "error")
                    SetPedToRagdollWithFall(ped, 1000, 2000, 1, GetEntityForwardVector(ped), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
                end
            end, Config.Workout.Yoga.Minigame.circles, Config.Workout.Yoga.Minigame.trime)
        else
            TriggerEvent('animations:client:EmoteCommandStart', {"yoga"})
            QBCore.Functions.Progressbar('doing_yoga', 'Doing Yoga', (Config.Workout.Yoga.time * 1000), false, false, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                ClearPedTasks(ped)
                FreezeEntityPosition(ped, false)
                TriggerServerEvent('hud:server:RelieveStress', Config.Workout.Yoga.stress)
                QBCore.Functions.Notify("You have a bit less stress", "success")
                training = false
                resting = true
            end, function()
                LocalPlayer.state:set("inv_busy", false, true)
                QBCore.Functions.Notify("Just Breathe First..", "error")
            end)
        end
    else
        QBCore.Functions.Notify('You\'re resting', 'primary')
    end
end)

RegisterNetEvent("prison:client:BikeMenu", function ()
    local header = {
        { isMenuHeader = true, icon = "fas fa-person-biking", header = "<strong>Rent a Bike<strong>" },
        {
            icon = "fas fa-bicycle",
            header = "<strong>BMX : $90<strong>",
            params = { event = "prison:client:SpawnBike", }
        },
        {
            icon = "fas fa-xmark",
            header = "<strong>Close Menu<strong>",
            params = { event = exports['qb-menu']:closeMenu(), }
        },
    }
    exports["qb-menu"]:openMenu(header)
end)

RegisterNetEvent('prison:client:SpawnBike', function(bmx)
    if bikesOut == 5 then
        QBCore.Functions.Notify("There are too many bikes out", "error")
    else
        QBCore.Functions.TriggerCallback("prison:server:TakeMoney", function(cb)
        local paid = cb
            if paid then
                local vehicle = "bmx"
                local coords = { ['x'] = 1630.73, ['y'] = 2589.35, ['z'] = 45.55, ['h'] = 175.79 }
                QBCore.Functions.SpawnVehicle(vehicle, function(veh)
                    SetEntityHeading(veh, coords.h)
                    SetVehicleEngineOn(veh, false, false)
                end, coords, true)
                QBCore.Functions.Notify("Return it when you're done!", "success")
                bikesOut = bikesOut + 1
            end
        end)
    end
end)

---------------------------------------------------------------------- THREADS
CreateThread(function()
    exports['qb-target']:AddTargetModel({-1978741854, -232023078}, {
        options = {
            {
                type = "client",
                event = "prison:client:DoYoga",
                icon = "fas fa-yin-yang",
                label = "Do yoga",
            },
        },
        distance = 2.5
    })

    if pedSpawned then return end
    local bikeSeller = "s_m_m_prisguard_01"
    RequestModel(bikeSeller)
    while not HasModelLoaded(bikeSeller) do Wait(1) end

    bikePed = CreatePed(0, bikeSeller, 1635.27, 2586.79, 44.79, 349.61, false, false)
    TaskStartScenarioInPlace(bikePed, "WORLD_HUMAN_DRINKING", 0, true)
    FreezeEntityPosition(bikePed, true)
    SetEntityInvincible(bikePed, true)
    SetBlockingOfNonTemporaryEvents(bikePed, true)
    PlaceObjectOnGroundProperly(bikePed)

    local options = {
        {
            label = "Rent a Bike",
            event ="prison:client:BikeMenu",
			canInteract = function() return LocalPlayer.state.inJail or QBCore.Functions.GetPlayerData().job.type == "leo" end,
        }
    }
    AddTarget(bikePed, options)
    pedSpawned = true
end)

