QBCore = exports["qb-core"]:GetCoreObject()
InJail = false
JailTime = 0
PrisonBlips = {}
TargetsTable = {}
Inventory = exports.ox_inventory
PrisonStates = {
	inJail = false,
	jailTime = 0,
	prisonJob = nil
}

GetJailTime = function()
	return LocalPlayer.state.jailTime
end
exports("GetJailTime", GetJailTime)

VerifyState = function(name)
	if PrisonStates[name] ~= LocalPlayer.state[name] then
		PrisonStates[name] = LocalPlayer.state[name]
	end
end

UpdatePrisonState = function(name, state)
	PrisonStates[name] = state
	LocalPlayer.state:set(name, state, true)
end

UpdateAllPrisonStates = function(inJail, time, newJob)
	PrisonStates.inJail = inJail
	PrisonStates.jailTime = time
	PrisonStates.prisonJob = newJob

	LocalPlayer.state:set("inJail", inJail, true)
	LocalPlayer.state:set("jailTime", time, true)
	LocalPlayer.state:set("prisonJob", newJob, true)
end

ClearPrisonStates = function()
	PrisonStates.inJail = false
	PrisonStates.jailTime = 0
	PrisonStates.prisonJob = nil

	LocalPlayer.state:set("inJail", false, true)
	LocalPlayer.state:set("jailTime", 0, true)
	LocalPlayer.state:set("prisonJob", nil, true)
end

ClearPrisonBlips = function()
	for k,v in pairs(PrisonBlips) do RemoveBlip(v) end
	PrisonBlips = {}
	RemoveBlip(JobBlip)
end

CreateCellsBlip = function()
	ClearPrisonBlips()

	for k, blipData in pairs(Config.Blips) do
		k = AddBlipForCoord(blipData.coords)
		SetBlipSprite (k, blipData.sprite)
		SetBlipDisplay(k, 4)
		SetBlipScale  (k, 0.8)
		SetBlipAsShortRange(k, true)
		SetBlipColour(k, blipData.color)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentSubstringPlayerName(blipData.label)
		EndTextCommandSetBlipName(k)
		table.insert(PrisonBlips, k)
	end
end

IsLifer = function()
	for _, cid in pairs(Config.Lifers) do
		if QBCore.Functions.GetPlayerData().citizenid == cid then
			return true
		end
	end
	return false
end

HasPrisonBreakItems = function()
	local itemcheck = 0
	for _,v in pairs(Config.PrisonBreak.Hack.Items) do
		if Inventory:GetItemCount(v.item) >= v.amount then
            itemcheck = itemcheck + 1
            if itemcheck == #Config.PrisonBreak.Hack.Items then
                return true
            end
        else
			return false
        end
    end
end

PrisonClothes = function()
	if not Config.Outfits.enabled then return end
	local outfit = IsPedModel(PlayerPedId(), "mp_m_freemode_01") and Config.Outfits.Male or Config.Outfits.Female
	for _,v in pairs(outfit) do
		SetPedComponentVariation(PlayerPedId(), v.componentId, v.item, v.texture)
	end
end

EnterPrison = function()
	local randomSpawn = Config.Locations.Spawns[math.random(1, #Config.Locations.Spawns)]
	SetEntityCoords(PlayerPedId(), randomSpawn.coords.x, randomSpawn.coords.y, randomSpawn.coords.z, 0, 0, 0, false)
	SetEntityHeading(PlayerPedId(), randomSpawn.coords.w)
	Wait(1000)

	LocalPlayer.state:set("prisonItems", false, true)
	PrisonClothes()
	TriggerEvent("animations:client:EmoteCommandStart", {randomSpawn.animation})
end

GetBed = function(bedId)
    local pos = GetEntityCoords(PlayerPedId())
    local retval = nil
    if bedId == nil then
        for k, _ in pairs(Config.Beds) do
            if not Config.Beds[k].taken then
                if #(pos - vector3(Config.Beds[k].coords.x, Config.Beds[k].coords.y, Config.Beds[k].coords.z)) < 500 then
                    retval = k
                end
            end
        end
    else
        if not Config.Beds[bedId].taken then
            if #(pos - vector3(Config.Beds[bedId].coords.x, Config.Beds[bedId].coords.y, Config.Beds[bedId].coords.z))  < 500 then
                retval = bedId
            end
        end
    end
    return retval
end

GetRandomJob = function()
	local jobs = {}
	for k,_ in pairs(Config.PrisonJobs) do
		table.insert(jobs, k)
	end
	return jobs[math.random(#jobs)]
end

CraftItem = function(index)
	local craftedItem = Config.CraftingItems[index].receive
	QBCore.Functions.Progressbar("crafting_item", "Crafting "..QBCore.Shared.Items[craftedItem].label, 5000, false, false, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {
		animDict = "mini@repair",
		anim = "fixing_a_ped",
		}, {}, {}, function()
		QBCore.Functions.Notify("Crafted "..QBCore.Shared.Items[craftedItem].label, "success")
		TriggerServerEvent("frudy_prison:server:GetCraftedItem", craftedItem)
		TriggerServerEvent("frudy_prison:server:RemoveCraftingItems", index)
		TriggerEvent("animations:client:EmoteCommandStart", {"c"})
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end)
end

PourDrink = function(drink)
	local player = PlayerPedId()
	TriggerServerEvent("InteractSound_SV:PlayOnSource", "pour-drink", 0.1)
	TaskStartScenarioInPlace(player, "WORLD_HUMAN_HANG_OUT_STREET", 0, true)
	QBCore.Functions.Progressbar("whocares", "Pouring Drink", 10000, false, true, {
		disableMovement = false,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		ClearPedTasks(player)
		TriggerServerEvent("frudy_prison:server:drinkPoured", drink)
	end, function() -- Cancel
		ClearPedTasks(player)
	end)
end

OpenShop = function(shopName, shopItems)
	TriggerServerEvent("mc9-shops:server:openShop", shopName, shopItems)
end

LeaveJail = function()
	ClearPrisonBlips()
	ClearPrisonStates()
	JobLocations = {}
	TriggerServerEvent("frudy_prison:server:updateJailTime", 0)
	QBCore.Functions.Notify("Freedom! Retrieve your belongs at the desk", "success")
	DoScreenFadeOut(500)

	while not IsScreenFadedOut() do Wait(1) end

	SetEntityCoords(PlayerPedId(), Config.Locations.Lobby.coords.x, Config.Locations.Lobby.coords.y, Config.Locations.Lobby.coords.z, 0, 0, 0, false)
	SetEntityHeading(PlayerPedId(), Config.Locations.Lobby.coords.w)
	TriggerEvent("fivem-appearance:client:reloadSkin")
	TriggerServerEvent("QBCore:Server:SetMetaData", "jailpockets", QBCore.Functions.GetPlayerData().items)
	TriggerServerEvent("frudy_prison:server:yeetItems")
	Wait(500)
	DoScreenFadeIn(1000)
end

AddTarget = function(entity, options, coords, targetName)
    if entity then
        exports["mc9-interact"]:AddLocalEntityInteraction({
            entity = entity,
            id = entity,
            distance = 3.0,
            interactDst = 1.5,
            options = options,
        })
    else
		exports["mc9-interact"]:AddInteraction({
			coords = coords,
			distance = 20.0,
			interactDst = 2.0,
			id = targetName,
			name = targetName,
			options = options
		})
		table.insert(TargetsTable, targetName)
    end
end

CreateAllTargets = function()
	for k,coords in pairs(Config.Locations.Possessions) do
		local id = "prisonPossessions"..k
		local options = {
			{
				label = "Receive Possessions",
				action = function() TriggerServerEvent("frudy_prison:server:GiveFreedomItems") end,
			}
		}

		AddTarget(_, options, coords, id)
	end

	for k,coords in pairs(Config.Locations.CheckTime) do
		local id = "prisonCheckTime"..k
		local options = {
			{
				label = "Check Time",
				action = function() TriggerEvent("frudy_prison:client:checkTime") end,
				canInteract = function()
					local playerData = QBCore.Functions.GetPlayerData()
					return playerData.metadata.jailstatus == "jailed" or LocalPlayer.state.inJail
				end,
			}
		}

		AddTarget(_, options, coords, id)
	end

	for k,coords in pairs(Config.Locations.JobBoards) do
		local id = "prisonJobBoard"..k
		local options = {
			{
				label = "Job Assignments",
				action = function() TriggerEvent("frudy_prison:client:jobMenu") end,
				canInteract = function()
					local playerData = QBCore.Functions.GetPlayerData()
					return playerData.metadata.jailstatus == "jailed" or LocalPlayer.state.inJail
				end,
			},
		}

		AddTarget(_, options, coords, id)
	end

	for k,coords in pairs(Config.Locations.Infirmary) do
		local id = "prisonInfirmary"..k
		local options = {
			{
				label = "Open Infirmary",
				action = function() OpenShop("prisonInfirmary", Config.Shops.Infirmary) end,
				canInteract = function()
					local playerData = QBCore.Functions.GetPlayerData()
					return playerData.metadata.jailstatus == "jailed" or LocalPlayer.state.inJail or playerData.job.type == "leo"
				end,
			},
			{
				label = "Check In",
				action = function() TriggerEvent("frudy_prison:client:checkIn") end,
				canInteract = function()
					local playerData = QBCore.Functions.GetPlayerData()
					return playerData.metadata.jailstatus == "jailed" or LocalPlayer.state.inJail or playerData.job.type == "leo"
				end,
			},
		}

		AddTarget(_, options, coords, id)
	end

	for k,coords in pairs(Config.Locations.Canteens) do
		local id = "prisonCanteen"..k
		local options = {
			{
				label = "Canteen",
				action = function() OpenShop("prisonCanteen", Config.Shops.Canteen) end,
				canInteract = function() return QBCore.Functions.GetPlayerData().metadata.jailstatus == "jailed" or LocalPlayer.state.inJail or QBCore.Functions.GetPlayerData().job.type == "leo" end
			},
		}

		AddTarget(_, options, coords, id)
	end

	for k,coords in pairs(Config.Locations.Slushy) do
		local id = "prisonSlushy"..k
		local options = {
			{
				label = "Make Slushy",
				action = function() PourDrink("slushy") end,
				canInteract = function() return QBCore.Functions.GetPlayerData().metadata.jailstatus == "jailed" or LocalPlayer.state.inJail or QBCore.Functions.GetPlayerData().job.type == "leo" end
			},
		}

		AddTarget(_, options, coords, id)
	end

	for k,coords in pairs(Config.Locations.Coffee) do
		local id = "prisonCoffee"..k
		local options = {
			{
				label = "Make Coffee",
				action = function() PourDrink("coffee") end,
				canInteract = function() return QBCore.Functions.GetPlayerData().metadata.jailstatus == "jailed" or LocalPlayer.state.inJail or QBCore.Functions.GetPlayerData().job.type == "leo" end
			},
		}

		AddTarget(_, options, coords, id)
	end

	for k,coords in pairs(Config.Locations.Drinks) do
		local id = "prisonDrinks"..k
		local options = {
			{
				label = "Get Drink",
				action = function() OpenShop("prisonCanteenDrinks", Config.Shops.Drinks) end,
				canInteract = function() return QBCore.Functions.GetPlayerData().metadata.jailstatus == "jailed" or LocalPlayer.state.inJail or QBCore.Functions.GetPlayerData().job.type == "leo" end
			},
		}

		AddTarget(_, options, coords, id)
	end

	for k,coords in pairs(Config.Locations.Crafting) do
		local id = "prisonCrafting"..k
		local options = {
			{
				event = "frudy_prison:client:craftingMenu",
				targeticon = "fas fa-toolbox",
				label = "Prison Crafting",
				canInteract = function() return QBCore.Functions.GetPlayerData().metadata.jailstatus == "jailed" or LocalPlayer.state.inJail end,
			},
		}

		AddTarget(_, options, coords, id)
	end

	for k,coords in pairs(Config.Locations.WorkOuts.ChinUps) do
		local id = "prisonChinUps"..k
		local options = {
			{
				event = "frudy_prison:client:DoChinUp",
				label = "Chin-Ups",
			},
		}

		AddTarget(_, options, coords, id)
	end

	for k,coords in pairs(Config.Locations.OutfitLockers) do
		local id = "prisonOutfits"..k
		local options = {
			{
				event = "qb-clothing:client:openMenu",
				label = "Change Clothes",
			},
		}

		AddTarget(_, options, coords, id)
	end

	for k,v in pairs(Config.Locations.PrisonBreak) do
		local id = "prisonBreak"..k
		local options = {
			{
				label = "Break Out",
				event = "frudy_prison:client:prisonBreak",
				canInteract = function() return HasPrisonBreakItems() and QBCore.Functions.GetPlayerData().metadata.jailstatus == "jailed" or InJail end
			},
		}

		AddTarget(_, options, vector3(v.coords.x, v.coords.y, v.coords.z), id)
	end
end
