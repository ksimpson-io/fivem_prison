QBCore = exports['qb-core']:GetCoreObject()
CurrentJob = nil
JobBlip = nil
local currLocation = 0

local newLocation = function()
    local newLocation = math.random(1, #JobLocations)
    while (newLocation == currLocation) do
        newLocation = math.random(1, #JobLocations)
        Wait(0)
    end
    return newLocation
end

function CreatePrisonJob()
    currLocation = currLocation and newLocation() or math.random(1, #JobLocations) -- if theres already a location, we need to gen a new one based off it, otherwise randomize it
    if DoesBlipExist(JobBlip) then RemoveBlip(JobBlip) end

    local coords = JobLocations[currLocation].coords.xyz
    JobBlip = AddBlipForCoord(coords.x, coords.y, coords.z)

    SetBlipSprite (JobBlip, 402)
    SetBlipDisplay(JobBlip, 4)
    SetBlipScale  (JobBlip, 0.8)
    SetBlipAsShortRange(JobBlip, true)
    SetBlipColour(JobBlip, 11)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Job Task")
    EndTextCommandSetBlipName(JobBlip)

    CreatePrisonTask()
end

local function CompleteTask(anim, bartext, targetId)
    TriggerEvent("animations:client:EmoteCommandStart", {anim})
    exports["mc9-interact"]:RemoveInteraction(targetId)
    QBCore.Functions.Progressbar("whocares", bartext, math.random(5000, 8000), false, false, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerEvent("animations:client:EmoteCommandStart", {"c"})
        TriggerServerEvent("mc9-prison:server:jobDone")
    end, function() end)
end

function CreatePrisonTask()
    local currJobSpot = JobLocations[currLocation]
    local anim = currJobSpot.anim
    local bartext = currJobSpot.txt

    local targetId = 'currentPrisonTask'..CurrentJob..currLocation
    exports["mc9-interact"]:AddInteraction({
		coords = vec3(currJobSpot.coords.x, currJobSpot.coords.y, currJobSpot.coords.z+1.0),
		distance = 15.0,
		interactDst = 3.0,
		id = targetId,
		name = targetId,
		options = {
			{
				label = 'Complete Task',
				action = function() CompleteTask(anim, bartext, targetId) end,
			},
		},
	})
end

RegisterNetEvent("mc9-prison:client:newTask", function()
    CreatePrisonJob()
end)
