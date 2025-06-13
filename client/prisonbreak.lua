QBCore = exports['qb-core']:GetCoreObject()
local currentGate = 0
local inZone = false
local securityLockdown = false
local psvar = Config.PrisonBreak.Hack.PSVAR
local psthermite =  Config.PrisonBreak.Hack.PSThermite


local Gates = {
    [1] = {
        gatekey = 13,
        coords = vector3(1845.99, 2604.7, 45.58),
        hit = false,
    },
    [2] = {
        gatekey = 14,
        coords = vector3(1819.47, 2604.67, 45.56),
        hit = false,
    },
    [3] = {
        gatekey = 15,
        coords = vector3(1804.74, 2616.311, 45.61),
        hit = false,
    }
}

function CreatePrisonZone()
    local prisonBorder = PolyZone:Create({
        vector2(1852.1574707031, 2596.5754394531),
        vector2(1852.0979003906, 2612.2077636719),
        vector2(1850.8920898438, 2672.8083496094),
        vector2(1856.7648925781, 2698.2873535156),
        vector2(1852.0694580078, 2713.0505371094),
        vector2(1783.8123779297, 2767.5673828125),
        vector2(1771.2778320313, 2772.2001953125),
        vector2(1648.1174316406, 2765.9868164063),
        vector2(1638.9439697266, 2762.5756835938),
        vector2(1563.7023925781, 2688.1447753906),
        vector2(1559.0922851563, 2681.1066894531),
        vector2(1525.9407958984, 2591.955078125),
        vector2(1523.7772216797, 2584.5173339844),
        vector2(1530.6303710938, 2468.1130371094),
        vector2(1535.7664794922, 2457.2253417969),
        vector2(1642.4678955078, 2391.9787597656),
        vector2(1650.7147216797, 2387.1669921875),
        vector2(1762.7001953125, 2399.4523925781),
        vector2(1797.0977783203, 2424.48046875),
        vector2(1832.4201660156, 2464.2158203125),
        vector2(1857.7255859375, 2522.9143066406)
    }, {
        name="prisonBorder",
        debugPoly = false,
        minZ = 11.8,
        maxZ = 68.00
    })

    prisonBorder:onPlayerInOut(function(isPointInside)
        if not isPointInside then

            if LocalPlayer.state.inJail then
                TriggerServerEvent("frudy_prison:server:SecurityLockdown")
                exports['ps-dispatch']:PrisonBreak()
                TriggerEvent("frudy_prison:client:destroyAllTargets")
                QBCore.Functions.Notify("Escaped", "success")
                TriggerServerEvent("frudy_prison:server:GiveMoneyBack")
                TriggerServerEvent("QBCore:Server:SetMetaData", "jailtime", 0)
                TriggerServerEvent("QBCore:Server:SetMetaData", "jailstatus", "free")
                TriggerServerEvent("QBCore:Server:SetMetaData", "freedomitems", "empty")
                TriggerServerEvent("QBCore:Server:SetMetaData", "jailpockets", "empty")

                SetTimeout(60000 * 2, function()
                    if not LocalPlayer.state.inJail then TriggerEvent("frudy_prison:client:destroyAllTargets") end -- in case you get rejailed for some reason
                    if not LocalPlayer.state.prisonItems then
                        TriggerServerEvent("frudy_prison:server:GiveMoneyBack")
                        TriggerServerEvent("QBCore:Server:SetMetaData", "jailtime", 0)
                        TriggerServerEvent("QBCore:Server:SetMetaData", "jailstatus", "free")
                        TriggerServerEvent("QBCore:Server:SetMetaData", "freedomitems", "empty")
                        TriggerServerEvent("QBCore:Server:SetMetaData", "jailpockets", "empty")
                        LocalPlayer.state:set("prisonItems", true, true)
                        SetTimeout(60000 * 5, function() LocalPlayer.state:set("prisonItems", false, true) end)
                    end
                end)
            end

            inZone = false
            ClearPrisonStates()
            ClearPrisonBlips()

        elseif isPointInside then
            inZone = true
            if not LocalPlayer.state.inJail or QBCore.GetPlayer.Data().job.type ~= "leo" or not QBCore.GetPlayer.Data().job.name ~= "ambulance" then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    QBCore.Functions.Notify("Trespassing. 5 seconds to leave", "error")
                    SetTimeout(5000, function()
                        if inZone then
                            local vehicleCoords = GetEntityCoords(PlayerPedId())
                            AddExplosion(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, 5, 50.0, true, false, 1.0)
                        end
                    end)
                end
            end
        end
    end)
end

-- Events

RegisterNetEvent('frudy_prison:client:prisonBreak', function()
    if currentGate ~= 0 and not securityLockdown and not Gates[currentGate].hit then
        QBCore.Functions.Progressbar("hack_gate", "Setting up the prison break..", math.random(5000, 10000), false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = "anim@gangops@facility@servers@",
            anim = "hotwire",
            flags = 16,
        }, {}, {}, function() -- Done
            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
            local xtime = math.floor(exports["mc9-skills"]:getSkill("hacking").level / 2)
            if psvar.enable then
                exports['ps-ui']:VarHack(function(success)
                    if success then
                        QBCore.Functions.Progressbar("prisonbreak", "Hacking the gate...", (Config.PrisonBreak.Time * 1000), false, true, {
                            disableMovement = false,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "anim@gangops@facility@servers@",
                            anim = "hotwire",
                            flags = 0,
                        }, {}, {}, function()
                            ClearPedTasks(PlayerPedId())
                            TriggerServerEvent('frudy_prison:server:RemovePrisonBreakItems')
                            TriggerServerEvent("frudy_prison:server:SetGateHit", currentGate)
                            TriggerServerEvent('qb-doorlock:server:updateState', Gates[currentGate].gatekey, false)
                        end, function()
                            QBCore.Functions.Notify("Canceled...", "error")
                            ClearPedTasks(PlayerPedId())
                        end)
                    else
                        TriggerServerEvent("frudy_prison:server:SecurityLockdown")
                        QBCore.Functions.Notify("You failed the hack!", "error")
                        ClearPedTasks(PlayerPedId())
                    end
                    end, psvar.blocks, psvar.time + xtime) -- Number of Blocks, Time (seconds)
            elseif psthermite.enable then
                exports['ps-ui']:Thermite(function(success)
                    if success then
                        QBCore.Functions.Progressbar("prisonbreak", "Hacking the gate...", (Config.PrisonBreak.Time * 1000), false, true, {
                            disableMovement = false,
                            disableCarMovement = true,
                            disableMouse = false,
                            disableCombat = true,
                        }, {
                            animDict = "anim@gangops@facility@servers@",
                            anim = "hotwire",
                            flags = 0,
                        }, {}, {}, function()
                            ClearPedTasks(PlayerPedId())
                            TriggerServerEvent('frudy_prison:server:RemovePrisonBreakItems')
                            TriggerServerEvent("frudy_prison:server:SetGateHit", currentGate)
                            TriggerServerEvent('qb-doorlock:server:updateState', Gates[currentGate].gatekey, false)
                        end, function()
                            QBCore.Functions.Notify("Canceled...", "error")
                            ClearPedTasks(PlayerPedId())
                        end)
                    else
                        TriggerServerEvent("frudy_prison:server:SecurityLockdown")
                        QBCore.Functions.Notify("You failed the hack!", "error")
                        ClearPedTasks(PlayerPedId())
                    end
                end, psthermite.time + xtime, psthermite.grid, psthermite.incorrect + xtime)
            end
        end, function() -- Cancel
            StopAnimTask(PlayerPedId(), "anim@gangops@facility@servers@", "hotwire", 1.0)
        end)
    end
end)

RegisterNetEvent('frudy_prison:client:SetLockDown', function(isLockdown)
    securityLockdown = isLockdown
    QBCore.Functions.GetPlayerData(function(PlayerData)
        if securityLockdown and PlayerData.metadata.jailstatus == "jailed" then
            TriggerEvent("chatMessage", "HOSTAGE", "error", "Highest security level is active, stay with the cell blocks!")
        end
    end)
end)

RegisterNetEvent('frudy_prison:client:PrisonBreakAlert', function()
    TriggerEvent('qb-policealerts:client:AddPoliceAlert', {
        timeOut = 10000,
        alertTitle = "Prison outbreak",
        details = {
            [1] = {
                icon = '<i class="fas fa-lock"></i>',
                detail = "Boilingbroke Penitentiary",
            },
            [2] = {
                icon = '<i class="fas fa-globe-europe"></i>',
                detail = "Route 68",
            },
        },
        callSign = QBCore.Functions.GetPlayerData().metadata["callsign"],
    })

    local BreakBlip = AddBlipForCoord(Config.Locations.Lobby.coords.x, Config.Locations.Lobby.coords.y, Config.Locations.Lobby.coords.z)
    TriggerServerEvent('frudy_prison:server:JailAlarm')
	SetBlipSprite(BreakBlip , 161)
	SetBlipScale(BreakBlip , 3.0)
	SetBlipColour(BreakBlip, 3)
	PulseBlip(BreakBlip)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Wait(100)
    PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
    Wait(100)
    PlaySoundFrontend( -1, "Beep_Red", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1 )
    Wait((1000 * 60 * 5))
    RemoveBlip(BreakBlip)
end)

RegisterNetEvent('frudy_prison:client:SetGateHit', function(key, isHit)
    Gates[key].hit = isHit
end)

RegisterNetEvent('frudy_prison:client:JailAlarm', function(toggle)
    if toggle then
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004,2593.1984,45.7978, "int_prison_main")

        RefreshInterior(alarmIpl)
        EnableInteriorProp(alarmIpl, "prison_alarm")

        CreateThread(function()
            while not PrepareAlarm("PRISON_ALARMS") do
                Wait(100)
            end
            StartAlarm("PRISON_ALARMS", true)
        end)
    else
        local alarmIpl = GetInteriorAtCoordsWithType(1787.004,2593.1984,45.7978, "int_prison_main")
        RefreshInterior(alarmIpl)
        DisableInteriorProp(alarmIpl, "prison_alarm")
        CreateThread(function()
            while not PrepareAlarm("PRISON_ALARMS") do
                Wait(100)
            end
            StopAllAlarms(true)
        end)
    end
end)
