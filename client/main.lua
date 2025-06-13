PlayerJob = nil
local nursePed
local nurseCalled

---------------------------------------------------------------------- EVENTS
RegisterNetEvent("QBCore:Client:OnJobUpdate", function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent("frudy_prison:client:destroyAllTargets", function()
	for _,v in pairs(TargetsTable) do
		exports["mc9-interact"]:RemoveInteraction(v)
	end
end)

RegisterNetEvent("QBCore:Client:OnPlayerUnload", function()
	CurrentJob = nil
	JobLocations = {}
	ClearPrisonBlips()
	TriggerEvent("frudy_prison:client:RemoveLockers")
end)

AddEventHandler("onResourceStop", function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
	ClearPrisonBlips()
	TriggerEvent("frudy_prison:client:RemoveLockers")
end)

RegisterNetEvent("frudy_prison:client:ChangeStatus", function()
	UpdatePrisonState("inJail", false)
end)

RegisterNetEvent("frudy_prison:client:Enter", function(time)
	local sentence = IsLifer() and "life" or time.." months"
	QBCore.Functions.Notify("In jail for " ..sentence, "error")

	Wait(1250)
	QBCore.Functions.Notify("Your property, assests, and $$ have been seized, you'll get everything back when your time is up", "error")
	DoScreenFadeOut(1000)
	while not IsScreenFadedOut() do Wait(10) end

	EnterPrison()

	local randomJob = GetRandomJob()
	local jobData = Config.PrisonJobs[randomJob]
	CurrentJob = randomJob
	JobLocations = Config.PrisonJobs[CurrentJob].locations

	UpdateAllPrisonStates(true, time, CurrentJob)
	TriggerServerEvent("QBCore:Server:SetMetaData", "jailstatus", "jailed")
	TriggerServerEvent("frudy_prison:server:updateJailTime", PrisonStates.jailTime)
	TriggerServerEvent("frudy_prison:server:SaveFreedomItems")
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "jail", 0.5)
	CreateCellsBlip()
	CreateAllTargets()
	CreatePrisonBikeZone()
	Wait(2000)
	DoScreenFadeIn(1000)
	QBCore.Functions.Notify("You've been assigned "..jobData.label)
	CreatePrisonJob()
	StartJailTIme()
end)

RegisterNetEvent("frudy_prison:client:checkTime", function()
	VerifyState("jailTime")
	if PrisonStates.jailTime <= 0 then LeaveJail() return end
	QBCore.Functions.Notify(PrisonStates.jailTime .. " months left", "error")
end)

RegisterNetEvent("frudy_prison:client:UnjailPerson", function()
	if QBCore.Functions.GetPlayerData().metadata.jailstatus == "jailed" or LocalPlayer.state.inJail then
		LeaveJail()
	end
end)

RegisterNetEvent("frudy_prison:client:jobMenu", function()
	local jobMenu = {
		{ isHeader = true, header = "Prison Work", isMenuHeader = true },
	}
	for k,v in pairs(Config.PrisonJobs) do
		jobMenu[#jobMenu+1] = {
			header = v.label,
			txt = v.desc,
			icon = v.icon,
			params = { event = "frudy_prison:client:getJob", args = k }
		}
	end
	jobMenu[#jobMenu+1] = {
		header = "Close",
		icon = "fas fa-x",
		params = { event = "qb-menu:client:closeMenu" }
	}
    exports["qb-menu"]:openMenu(jobMenu)
end)

RegisterNetEvent("frudy_prison:client:getJob", function(newJob)
	if not Config.PrisonJobs[newJob] then return end
	if (LocalPlayer.state.prisonJob == newJob) then QBCore.Functions.Notify("You're already a(n) "..Config.PrisonJobs[CurrentJob].label, "error") return end

	CurrentJob = newJob
	LocalPlayer.state:set("prisonJob", CurrentJob, true)
	JobLocations = Config.PrisonJobs[CurrentJob].locations
	QBCore.Functions.Notify("New Job: "..Config.PrisonJobs[CurrentJob].label)
	CreatePrisonJob()
end)

RegisterNetEvent("frudy_prison:client:craftingMenu", function()
	local crafting = {
		{ header = "Prison Crafting", isMenuHeader = true, },
	}
	for k, v in pairs(Config.CraftingItems) do
		local item = Config.CraftingItems[k]
		local text = ""
		for j,_ in pairs(item.materials) do
			local material = item.materials[j]
			text = text .. "- " .. QBCore.Shared.Items[material.mat].label .. ": " .. material.amount .. "x <br>"
		end
		crafting[#crafting+1] = {
			header = QBCore.Shared.Items[ v.receive].label,
			text = text,
			img = v.receive,
			params = { event = "frudy_prison:client:craft", args = k },
		}
	end
	exports["qb-menu"]:openMenu(crafting)
end)

RegisterNetEvent("frudy_prison:client:craft", function(index)
	QBCore.Functions.TriggerCallback("frudy_prison:server:hasMats", function(hasMaterials)
		if (hasMaterials) then
			CraftItem(index)
		else
			QBCore.Functions.Notify("You do not have the correct items", "error")
			return
		end
	end, Config.CraftingItems[index].materials)
end)

RegisterNetEvent("frudy_prison:client:checkIn", function()
	TriggerEvent("animations:client:EmoteCommandStart", {"notepad"})
	QBCore.Functions.Progressbar("hospital_checkin", "Checking Into Infirmary", 2000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		TriggerEvent("animations:client:EmoteCommandStart", {"c"})
		local bedId = GetBed()
		if bedId then
			Config.Beds[bedId].taken = true
			TriggerEvent("frudy_prison:client:getTreated", bedId)
		else
			QBCore.Functions.Notify("All beds are taken", "error")
		end
	end, function() -- Cancel
		TriggerEvent("animations:client:EmoteCommandStart", {"c"})
	end)
end)

RegisterNetEvent("frudy_prison:client:getTreated", function(bedData)
	local data = Config.Beds[bedData]
	local player = PlayerPedId()

	RequestModel(GetHashKey("s_f_y_scrubs_01"))
	while not HasModelLoaded(GetHashKey("s_f_y_scrubs_01")) do Wait(10) end
	RequestAnimDict("missarmenian2")
	while not HasAnimDictLoaded("missarmenian2") do Wait(10) end
	RequestAnimDict("missheistfbi3b_ig8_2")
	while not HasAnimDictLoaded("missheistfbi3b_ig8_2") do Wait(10) end

	local docPed = CreatePed(5, GetHashKey("s_f_y_scrubs_01") , 1766.03, 2599.33, 45.73, 180.42, true, true)
	SetEntityCoords(player, data.coords.x, data.coords.y, data.coords.z, 0, 0, 0, false)
	SetEntityHeading(player, data.heading)
	TaskPlayAnim(player, "missarmenian2", "corpse_search_exit_ped", 1.0, 1.0, -1, 1, 0, 0, 0, 0)
	local pos = data.docCoords
	local pedPos = GetEntityCoords(docPed)
	local pedDist = #(pos - pedPos)
	while pedDist > 1.5 do
		pos = data.docCoords
		pedPos = GetEntityCoords(docPed)
		TaskGoStraightToCoord(docPed, data.docCoords.x, data.docCoords.y, data.docCoords.z, 2.0, -1, 0, 0)
		pedDist = #(pos - pedPos)
		Wait(100)
	end
	SetEntityHeading(docPed, data.docHeading)
	TaskStartScenarioInPlace(docPed, "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true)
	QBCore.Functions.Progressbar("inf_checkin", "Being Treated", 7000, false, false, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		QBCore.Functions.Notify("Go to the canteen if you need some food","success")
		ClearPedTasks(docPed)
		SetPedAsNoLongerNeeded(docPed)
		StopAnimTask(player, "missarmenian2", "corpse_search_exit_ped", 1.0)
		TriggerEvent("hospital:client:Revive")
		DeleteEntity(docPed)
		Config.Beds[bedData].taken = false
	end)
end)

---------------------------------------------------------------------- THREADS

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
	CreatePrisonZone()
	TriggerEvent("frudy_prison:client:SpawnLockers")

	local active = lib.callback.await("frudy_prison:server:IsAlarmActive", false)
	if active then TriggerEvent("frudy_prison:client:JailAlarm", true) end
	LocalPlayer.state.jailTime = lib.callback.await("frudy_prison:server:isInJail", false)

	if LocalPlayer.state.jailTime then
		TriggerEvent("frudy_prison:client:Enter", LocalPlayer.state.jailTime)
		if IsLifer() then TriggerServerEvent("frudy_prison:server:updateJailTime", 999) end
	end
end)

function StartJailTIme()
	CreateThread(function()
		while true do
			local sleep = 1000
				if (LocalPlayer.state.inJail) and (LocalPlayer.state.jailTime and LocalPlayer.state.jailTime > 0) then
					Wait(1000 * 60)
					sleep = 0
					if LocalPlayer.state.jailTime > 0 and LocalPlayer.state.inJail then
						UpdatePrisonState("jailTime", LocalPlayer.state.jailTime - 1)
						if LocalPlayer.state.jailTime <= 0 then
							UpdatePrisonState("jailTime", 0)
							QBCore.Functions.Notify("Time is up! Check yourself out at the visitors center", "success", 10000)
						end
						TriggerServerEvent("frudy_prison:server:updateJailTime", LocalPlayer.state.jailTime)
					end
				else
					Wait(sleep)
				end
		end
	end)
end

RegisterCommand("jailtime", function()
	VerifyState("jailTime")
	if not PrisonStates.inJail then QBCore.Functions.Notify("Not in jail", "error") return end
	if IsLifer() then QBCore.Functions.Notify("Life", "error") return end

	QBCore.Functions.Notify(PrisonStates.jailTime.." months left", "error")
end)

RegisterCommand("killnurse", function()
	VerifyState("inJail")
	if not PrisonStates.inJail then QBCore.Functions.Notify("Not in jail", "error") return end
	if not nurseCalled then QBCore.Functions.Notify("No nurse called","error") return end

	DeleteEntity(nursePed)
	nurseCalled = false
	QBCore.Functions.Notify("Nurse recalled", "error")
end)

RegisterCommand("helpjail", function()
	VerifyState("inJail")
	if not PrisonStates.inJail then QBCore.Functions.Notify("Not in jail", "error") return end
	if nurseCalled then QBCore.Functions.Notify("Nurse is already on the way","error") return end

	nurseCalled = true
	QBCore.Functions.Notify("Nurse is on the way", "success")
	RequestModel(GetHashKey("s_f_y_scrubs_01"))
	while not HasModelLoaded(GetHashKey("s_f_y_scrubs_01")) do Wait(10) end
	local thirst = QBCore.Functions.GetPlayerData().metadata["thirst"]
	local hunger = QBCore.Functions.GetPlayerData().metadata["hunger"]
	local pos = GetEntityCoords(PlayerPedId())
	nursePed = CreatePed(5, GetHashKey("s_f_y_scrubs_01") , pos.x+3.0, pos.y-1.0, pos.z, 180.42, true, true)
	local pedPos = GetEntityCoords(nursePed)
	local pedDist = #(pos - pedPos)

	while pedDist > 1.5 do
		pos = GetEntityCoords(PlayerPedId())
		pedPos = GetEntityCoords(nursePed)
		TaskGoStraightToCoord(nursePed, pos, 2.0, -1, 0, 0)
		pedDist = #(pos - pedPos)
		Wait(100)
	end

	TaskStartScenarioInPlace(nursePed, "CODE_HUMAN_MEDIC_TEND_TO_DEAD", 0, true)
	QBCore.Functions.Progressbar("inf_checkin", "Being Treated", 15000, false, false, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		ClearPedTasks(nursePed)
		SetPedAsNoLongerNeeded(nursePed)
		TriggerEvent("hospital:client:Revive")
		TriggerServerEvent("QBCore:Server:SetMetaData", "thirst", thirst)
		TriggerServerEvent("QBCore:Server:SetMetaData", "hunger", hunger)
		SetEntityHealth(PlayerPedId(), 150)
		nurseCalled = false
		QBCore.Functions.Notify("Check in at the infirmary for full treatment", "success")
		Wait(5000)
		DeleteEntity(nursePed)
	end)
end)
