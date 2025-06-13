QBCore = exports["qb-core"]:GetCoreObject()

AddEventHandler("QBCore:Server:UpdateObject", function()
    if (source ~= "") then return false end
	QBCore = exports["qb-core"]:GetCoreObject()
end)

local validPrisoner = function(source)
    local prisoner = QBCore.Functions.GetPlayer(source)
    if (not prisoner) or (not Player(source).state.inJail) then return false end
    return prisoner
end

local getRandomCraftingItem = function(prisonJob)
    local rewards = Config.PrisonJobs[prisonJob].rewards
    local jobItem = math.random(1, #rewards)
    return rewards[jobItem].item, rewards[jobItem].amount
end

local AlarmActivated = false

RegisterNetEvent("mc9-prison:server:jobDone", function()
    local prisoner = validPrisoner(source)
    if (not prisoner) then return end

    local job = Player(source).state.prisonJob
    if not job then return end

    local high, low
    local time = Player(source).state.jailTime
    local chance = math.random(1,100)

    prisoner.Functions.AddMoney("cash", Config.PrisonWage)

    if chance <= Config.TimeReductionChance then
        if job == "janitor" or job == "electrician" then
            low = 2 ; high = 4
        elseif job == "cook" then
            low = 1; high = 2
        elseif job == "health" or job == "gardener" then
            low = 2 ; high = 3
        end
        time = math.max(0, time - math.random(low, high))
        Player(source).state:set("jailTime", time, true)
        prisoner.Functions.Notify("Time reduced. "..time.. "months remaining")
    end

    if chance <= Config.CraftingItemChance then
        local item, amount = getRandomCraftingItem(job)
        prisoner.Functions.AddItem(item, amount)
        TriggerClientEvent("qb-inventory:client:ItemBox", source, QBCore.Shared.Items[item], "add")
    elseif chance <= 5 then
        prisoner.Functions.AddItem("phone", 1)
        TriggerClientEvent("qb-inventory:client:ItemBox", source, QBCore.Shared.Items["phone"], "add")
    end

    TriggerClientEvent("mc9-prison:client:newTask", source)
end)

RegisterNetEvent("prison:server:drinkPoured", function(drink)
    local prisoner = validPrisoner(source)
    if (not prisoner) then return end

    prisoner.Functions.AddItem(drink, 1)
    TriggerClientEvent("qb-inventory:client:ItemBox", source, QBCore.Shared.Items[drink], "add")
end)

RegisterNetEvent("prison:server:updateJailTime", function(jailTime)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("jailtime", jailTime)
    if jailTime <= 0 then return end
    if Config.RemoveJobs then
        TriggerClientEvent("mc9-prison:client:setupJobs", src)
    end
end)

RegisterNetEvent("prison:server:SetFreedomStatus", function(status)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.SetMetaData("jailstatus", status)
end)

RegisterNetEvent("prison:server:SaveFreedomItems", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.SetMetaData("jailstatus", "jailed")

    if Player.PlayerData.metadata.freedomitems == nil or Player.PlayerData.metadata.freedomitems == "empty" then
        Player.Functions.SetMetaData("freedomitems", Player.PlayerData.items)
        Player.Functions.SetMetaData("jailmoneybank", Player.PlayerData.money.bank)
        Player.Functions.SetMetaData("jailmoneycash", Player.PlayerData.money.cash)
        Player.Functions.SetMoney("bank", 0)
        Player.Functions.SetMoney("cash", 50)
        Wait(1000)
        Player.Functions.ClearInventory()
        for _, v in pairs(Player.PlayerData.metadata.jailpockets) do -- if theyve never been to jail then set locker, else set locker to current inv
            Player.Functions.AddItem(v.name, v.amount, false, v.info)
        end
    end
end)

RegisterNetEvent("prison:server:yeetItems", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.ClearInventory()
end)

RegisterNetEvent("prison:server:GiveFreedomItems", function()
    local src = source
    local prisoner = QBCore.Functions.GetPlayer(src)
    if Player(source).state.prisonItems then return end

    Player(source).state:set("prisonItems", true, true)
    SetTimeout(60000 * 5, function() Player(source).state:set("prisonItems", false, true) end)
    prisoner.Functions.SetMetaData("jailstatus", "free")
    prisoner.Functions.ClearInventory()
    if type(prisoner.PlayerData.metadata["freedomitems"]) == "table" and prisoner.PlayerData.metadata["freedomitems"] ~= nil then
        for k, v in pairs(prisoner.PlayerData.metadata["freedomitems"]) do
            prisoner.Functions.AddItem(v.name, v.amount, false, v.info)
        end
    end
    Wait(100)
    prisoner.Functions.SetMetaData("freedomitems", "empty")
    if prisoner.PlayerData.metadata["jailmoneybank"] ~= nil then
        prisoner.Functions.SetMoney("bank", prisoner.PlayerData.metadata["jailmoneybank"])
        prisoner.PlayerData.metadata["jailmoneybank"] = 0
    end
    if prisoner.PlayerData.metadata["jailmoneycash"] ~= nil then
        prisoner.Functions.SetMoney("cash", prisoner.PlayerData.metadata["jailmoneycash"])
        prisoner.PlayerData.metadata["jailmoneycash"] = 0
    end
    TriggerClientEvent("prison:client:ChangeStatus", src)
    TriggerClientEvent("prison:client:destroyAllTargets", src)
    TriggerClientEvent("QBCore:Client:Notify", src, "Possessions received!", "success")
end)

RegisterNetEvent("prison:server:GiveMoneyBack", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Wait(1000)
    if Player.PlayerData.metadata["jailmoneybank"] ~= nil then
        Player.Functions.SetMetaData("jailstatus", "free")
        Player.Functions.SetMoney("bank", Player.PlayerData.metadata["jailmoneybank"])
        Player.PlayerData.metadata["jailmoneybank"] = 0
    end
end)

RegisterNetEvent("prison:server:CheckRecordStatus", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local CriminalRecord = Player.PlayerData.metadata["criminalrecord"]
    local currentDate = os.date("*t")

    if (CriminalRecord["date"].month + 1) == 13 then
        CriminalRecord["date"].month = 0
    end

    if CriminalRecord["hasRecord"] then
        if currentDate.month == (CriminalRecord["date"].month + 1) or currentDate.day == (CriminalRecord["date"].day - 1) then
            CriminalRecord["hasRecord"] = false
            CriminalRecord["date"] = nil
        end
    end
end)

RegisterNetEvent("prison:server:GetCraftingItems", function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local itemamount = tonumber(amount)
    local craftingitem = tostring(item)
    Player.Functions.AddItem(craftingitem, itemamount)
    TriggerClientEvent("qb-inventory:client:ItemBox", src, QBCore.Shared.Items[craftingitem], "add", itemamount)
end)

RegisterNetEvent("prison:server:GetCraftedItem", function(item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem(item, 1)
    TriggerClientEvent("qb-inventory:client:ItemBox", src, QBCore.Shared.Items[item], "add", 1)
end)

RegisterNetEvent("prison:server:RemoveCraftingItems", function(index)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    for k, v in pairs(Config.CraftingItems[index].materials) do
        Player.Functions.RemoveItem(v.mat, v.amount)
        TriggerClientEvent("qb-inventory:client:ItemBox", src, QBCore.Shared.Items[v.mat], "remove", v.amount)
    end
end)

RegisterNetEvent("prison:server:RemovePrisonBreakItems", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    exports["mc9-skills"]:addXP(src, "hacking", 10)
    for k,v in pairs(Config.PrisonBreak.Hack.Items) do
        Player.Functions.RemoveItem(v.item, v.amount)
        TriggerClientEvent("qb-inventory:client:ItemBox", src, QBCore.Shared.Items[v.item], "remove", v.amount)
    end
end)

RegisterNetEvent("prison:server:JailAlarm", function()
    if not AlarmActivated then
        TriggerClientEvent("prison:client:JailAlarm", -1, true)
        SetTimeout(5 * (60 * 1000), function()
            TriggerClientEvent("prison:client:JailAlarm", -1, false)
        end)
    end
end)

RegisterNetEvent("prison:server:SecurityLockdown", function()
    TriggerClientEvent("prison:client:SetLockDown", -1, true)
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        if Player ~= nil then
            if (Player.PlayerData.job.type == "leo" and Player.PlayerData.job.onduty) then
                TriggerClientEvent("prison:client:PrisonBreakAlert", v)
            end
        end
	end
end)

RegisterNetEvent("prison:server:SetGateHit", function(key)
    TriggerClientEvent("prison:client:SetGateHit", -1, key, true)
    if math.random(1, 100) <= 50 then
        for k, v in pairs(QBCore.Functions.GetPlayers()) do
            local Player = QBCore.Functions.GetPlayer(v)
            if Player ~= nil then
                if (Player.PlayerData.job.type == "leo" and Player.PlayerData.job.onduty) then
                    TriggerClientEvent("prison:client:PrisonBreakAlert", v)
                end
            end
        end
    end
end)

------------------------------------------------------------------------------  Callbacks
mc9.callback.create("prison:server:IsAlarmActive", function(source)
    return AlarmActivated
end)

mc9.callback.create("prison:server:isInJail", function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    while not Player do Wait(1000) end
    if Player.PlayerData.metadata.jailtime > 0 or Player.PlayerData.metadata.jailstatus == "jailed" then
        return Player.PlayerData.metadata.jailtime
    end

    return false
end)

QBCore.Functions.CreateCallback("prison:server:IsAlarmActive", function(source, cb)
    cb(AlarmActivated)
end)

QBCore.Functions.CreateCallback("prison:server:DoesStashExist", function(source, cb, stashID) -- Check if stash exist
    local retval = false
    local result = MySQL.Sync.fetchSingle("SELECT * from stashitems WHERE stash = ?", {stashID})
    if result then retval = true end
    cb(retval)
end)

QBCore.Functions.CreateCallback("prison:server:TakeMoney", function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player.PlayerData.job.type == "leo" then
        cb(true)
    elseif Player.PlayerData.money.cash >= 90 then
        Player.Functions.RemoveMoney("cash", 90)
        cb(true)
    else
        TriggerClientEvent("QBCore:Client:Notify", src, "It's 90 or nothing, fool", "error")
        cb(false)
    end
end)

QBCore.Functions.CreateCallback("prison:server:hasMats", function(source, cb, materials)
    local src = source
    local hasItems = false
    local matscheck = 0
    local player = QBCore.Functions.GetPlayer(source)
    for k, v in pairs(materials) do
        if player.Functions.GetItemByName(v.mat) and player.Functions.GetItemByName(v.mat).amount >= v.amount then
            matscheck = matscheck + 1
            if matscheck == #materials then
                cb(true)
            end
        else
            cb(false)
            return
        end
    end
end)
