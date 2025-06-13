Config = {}

Config.DebugPoly = false -- Set to true to debug PolyZones
Config.Crafting = true -- Set to false to disable crafting
Config.RemoveJobs = false -- Set to false if you don't want to remove player's job.
Config.psUI = true
Config.PrisonWage = 5
Config.CraftingItemChance = 15 -- 15% Chance to Receive Crafting Item when doing jobs
Config.TimeReductionChance = 40 -- % Time gets taken off each task

Config.Lifers = {}

Config.Workout = {
    Cooldown = 20, -- Cooldown between workouts
    Chinup = {
        coords = vector3(1775.82, 2497.52, 45.82),
        time = math.random(10, 20) -- How long to do chinups (Seconds)
    },
    Yoga = {
        Minigame = {
            circles = 5,
            time = math.random(25, 35) },
        time = math.random(10, 20), -- How long to do yoga (Seconds)
        stress = 5 -- How much stress is removed
    }
}

Config.Outfits = {
    enabled = true,
    Male = {
        mask = { item = 0, texture = 0, componentId = 1 },
        arms = { item = 1, texture = 0, componentId = 3 },
        shirt = { item = 15, texture = 0, componentId = 8 },
        jacket = { item = 364, texture = 0, componentId = 11 },
        pants = { item = 135, texture = 0, componentId = 4 },
        shoes = { item = 132, texture = 0, componentId = 6 },
        accessories = { item = 0, texture = 0, componentId = 7 },
    },
    Female = {
        mask = { item = 0, texture = 0, componentId = 1 },
        arms = { item = 3, texture = 0, componentId = 3 },
        shirt = { item = 14, texture = 0, componentId = 8 },
        jacket = { item = 383, texture = 0, componentId = 11 },
        pants = { item = 142, texture = 0, componentId = 4 },
        shoes = { item = 132, texture = 0, componentId = 6 },
        accessories = { item = 0, texture = 0, componentId = 7 },
    },
}

Config.PrisonBreak = {
    Time = math.random(10, 20),
    Hack = {
        PSVAR = {
            enable = true,
            blocks = 2,
            time = 20
        },
        PSThermite = {
            enable = true,
            time = 20,
            grid = 5,
            incorrect = 3
        },
        Items = {
            [1] = {
                item = 'trojan_usb',
                amount = 1
            },
            [2] = {
                item = 'electronickit',
                amount = 1
            },
        }
    }
}

Config.Lockers = {
---- Cell Block 7, main cell room that has the fitness room inside. facing the wall with the trooper on it
    --bottom right 7
    { coords = vector4(1763.39, 2497.55, 45.82, 299.78), }, -- Cell 1
    { coords = vector4(1760.4, 2495.88, 45.82, 299.32), }, -- Cell 2
    { coords = vector4(1754.38, 2492.38, 45.82, 297.2), }, -- Cell 3
    { coords = vector4(1751.32, 2490.67, 45.82, 297.46), }, -- Cell 4
    { coords = vector4(1748.36, 2488.91, 45.82, 300.36), }, -- Cell 5
    { coords = vector4(1745.37, 2487.07, 45.82, 297.78), }, -- Cell 6
    { coords = vector4(1742.35, 2485.38, 45.82, 297.07), }, -- Cell 7, cell w boombox
    -- top right 8
    { coords = vector4(1763.38, 2497.57, 50.43, 298.18), }, -- Cell 8
    { coords = vector4(1760.42, 2495.74, 50.43, 296.39), }, -- Cell 9
    { coords = vector4(1757.35, 2494.12, 50.42, 295.18), }, -- Cell 10
    { coords = vector4(1754.35, 2492.44, 50.42, 286.06), }, -- Cell 11, cell w hole in wall
    { coords = vector4(1751.38, 2490.69, 50.42, 292.84), }, -- Cell 12
    { coords = vector4(1747.71, 2492.83, 50.42, 211.79), }, -- Cell 13
    { coords = vector4(1745.3, 2487.18, 50.42, 297.38), }, -- Cell 14
    { coords = vector4(1742.45, 2485.4, 50.42, 301.21), }, -- Cell 15, cell w the leopard sheets
    -- bottom left 8
    { coords = vector4(1773.55, 2484.65, 45.82, 123.81), }, -- Cell 16
    { coords = vector4(1770.61, 2482.94, 45.82, 118.62), }, -- Cell 17
    { coords = vector4(1767.56, 2481.01, 45.82, 123.36), }, -- Cell 18
    { coords = vector4(1764.43, 2479.3, 45.82, 119.39), }, -- Cell 19, cell w chang gang poster
    { coords = vector4(1761.55, 2477.58, 45.81, 118.65), }, -- Cell 20
    { coords = vector4(1758.48, 2475.87, 45.81, 114.88), }, -- Cell 21, cell w red HA
    { coords = vector4(1755.58, 2474.21, 45.81, 116.12), }, -- Cell 22
    { coords = vector4(1752.52, 2472.49, 45.81, 119.61), }, -- Cell 23
    -- top left 8
    { coords = vector4(1773.55, 2484.47, 50.42, 124.13), }, -- Cell 24
    { coords = vector4(1770.6, 2482.92, 50.42, 122.2), }, -- Cell 25, cell w leanbois poster
    { coords = vector4(1767.36, 2481.0, 50.42, 121.38), }, -- Cell 26
    { coords = vector4(1764.41, 2479.35, 50.42, 116.9), }, -- Cell 27
    { coords = vector4(1761.5, 2477.64, 50.42, 112.71), }, -- Cell 28
    { coords = vector4(1758.44, 2475.8, 50.42, 122.5), }, -- Cell 29, cell w flat screen tv??? LMFAO
    { coords = vector4(1755.41, 2474.05, 50.42, 121.72), }, -- Cell 30
    { coords = vector4(1752.5, 2472.31, 50.42, 122.06), }, -- Cell 31
----- Cell Block 6, other cells, has the library in it. facing wall w army woman on it
    --bottom right 7
    { coords = vector4(1698.62, 2461.07, 45.85, 264.81), }, -- Cell 1
    { coords = vector4(1695.15, 2461.17, 45.85, 267.14), }, -- Cell 2
    { coords = vector4(1688.2, 2461.09, 45.84, 264.29), }, -- Cell 3
    { coords = vector4(1684.76, 2461.25, 45.84, 269.2), }, -- Cell 4
    { coords = vector4(1681.22, 2461.12, 45.84, 268.02), }, -- Cell 5
    { coords = vector4(1677.79, 2461.26, 45.84, 268.31), }, -- Cell 6
    { coords = vector4(1674.27, 2461.23, 45.84, 266.38), }, -- Cell 7,
    -- top right 8
    { coords = vector4(1698.7, 2460.99, 50.45, 266.86), }, -- Cell 8
    { coords = vector4(1695.18, 2461.01, 50.45, 269.54), }, -- Cell 9
    { coords = vector4(1691.7, 2461.15, 50.45, 271.65), }, -- Cell 10
    { coords = vector4(1688.2, 2461.09, 50.45, 279.89), }, -- Cell 11,
    { coords = vector4(1684.74, 2461.26, 50.45, 271.53), }, -- Cell 12
    { coords = vector4(1681.22, 2461.04, 50.45, 267.75), }, -- Cell 13
    { coords = vector4(1677.79, 2461.09, 50.45, 267.1), }, -- Cell 14
    { coords = vector4(1674.27, 2461.23, 50.45, 266.38), }, -- Cell 15,
    -- bottom left 8
    { coords = vector4(1701.02, 2444.67, 45.84, 95.56), }, -- Cell 16
    { coords = vector4(1697.54, 2444.76, 45.84, 85.01), }, -- Cell 17
    { coords = vector4(1694.06, 2444.68, 45.84, 91.46), }, -- Cell 18
    { coords = vector4(1690.61, 2444.77, 45.84, 87.71), }, -- Cell 19,
    { coords = vector4(1687.05, 2444.68, 45.84, 86.96), }, -- Cell 20
    { coords = vector4(1683.49, 2444.63, 45.84, 85.45), }, -- Cell 21,
    { coords = vector4(1680.16, 2444.8, 45.84, 88.7), }, -- Cell 22
    { coords = vector4(1676.69, 2444.75, 45.84, 89.96), }, -- Cell 23
    -- top left 8
    { coords = vector4(1700.86, 2444.83, 50.45, 87.71), }, -- Cell 24
    { coords = vector4(1697.33, 2444.69, 50.45, 86.3), }, -- Cell 25,
    { coords = vector4(1693.82, 2444.77, 50.45, 89.58), }, -- Cell 26
    { coords = vector4(1690.33, 2444.74, 50.44, 88.62), }, -- Cell 27
    { coords = vector4(1686.95, 2444.73, 50.44, 83.04), }, -- Cell 28
    { coords = vector4(1683.44, 2444.72, 50.44, 93.77), }, -- Cell 29,
    { coords = vector4(1680.16, 2444.76, 50.44, 92.87), }, -- Cell 30
    { coords = vector4(1676.6, 2444.77, 50.44, 90.53), }, -- Cell 31
}

Config.Locations = {
    Lobby = { coords = vector4(1836.91, 2588.72, 46.01, 183.37) }, -- where you spawn after being released
    Possessions = { -- locations to get items after release
        vector3(1840.3, 2578.47, 46.01),
    },
    CheckTime = { -- locations to check time
        vector3(1828.84, 2580.18, 46.01),
    },
    JobBoards = { -- locations to switch jobs
        vector3(1780.64, 2502.31, 50.43),
    },
    Infirmary = { -- locations for infirmary
        vector3(1769.04, 2571.03, 45.73),
    },
    Canteens = { -- locations for canteens
        vector3(1780.95, 2560.05, 45.67),
    },
    Slushy = { -- locations for slushy machines
        vector3(1777.64, 2559.97, 45.67),
    },
    Coffee = { -- locations for coffee machines
        vector3(1778.83, 2560.04, 45.67),
    },
    Drinks = { -- locations for drink machines
        vector3(1778.26, 2560.02, 45.67),
    },
    Crafting = { -- locations for crafting
        vector3(1840.3, 2578.47, 46.01),
    },
    OutfitLockers = { -- locations to change clothes
        vector3(1741.23, 2496.82, 45.82),
        vector3(1678.92, 2471.56, 45.85),
    },
    WorkOuts = { -- locations for diff workouts
        ChinUps = {
            vector3(1775.82, 2497.52, 45.82),
        },
    },
    PrisonBreak = { -- Polyzones for prison break locations
        { coords = vector4(1817.47, 2602.68, 45.6, 0), length = 0.5, width = 0.5, },
        { coords = vector4(1819.49, 2604.7, 45.58, 0), length = 0.5, width = 0.5, },
        { coords = vector4(1846.01, 2604.7, 45.58, 0), length = 0.5, width = 0.5, },
        { coords = vector4(1843.97, 2602.67, 45.6, 0), length = 0.5, width = 0.5, },
        { coords = vector4(1804.78, 2616.29, 45.54, 0), length = 0.5, width = 0.5, },
        { coords = vector4(1804.79, 2617.49, 45.54, 0), length = 0.5, width = 0.5, },
    },
    Spawns = {
        { animation = "tennisplay", coords = vector4(1674.52, 2499.47, 45.55, 357.85) }, -- Cell Block 7, workout room wall
        { animation = "sitchair4", coords = vector4(1763.41, 2499.36, 45.82, 298.68) }, -- Cell Block 7, main cells - bottom 1
        { animation = "pushup", coords = vector4(1754.85, 2494.88, 45.82, 205.02) }, -- Cell Block 7, main cells - bottom 3
        { animation = "passout", coords = vector4(1747.52, 2490.92, 47.41, 123.15) }, -- Cell Block 7, main cells - bottom 5
        { animation = "sit", coords = vector4(1742.41, 2488.04, 45.82, 123.92) }, -- Cell Block 7, main cells - bottom 7
        { animation = "pee2", coords = vector4(1763.99, 2501.24, 50.43, 36.13) }, -- Cell Block 7, main cells - top 1
        { animation = "superhero", coords = vector4(1757.64, 2497.3, 50.43, 85.43) }, -- Cell Block 7, main cells - top 3
        { animation = "nervous3", coords = vector4(1748.46, 2488.75, 50.42, 327.99) }, -- Cell Block 7, main cells - top 6
        { animation = "guitar2", coords = vector4(1742.55, 2487.58, 50.42, 264.79) }, -- Cell Block 7, main cells - top 7
        { animation = "clown", coords = vector4(1755.29, 2471.81, 45.81, 33.86) }, -- Cell Block 7, main cells - bottom 8
        { animation = "gangsign2", coords = vector4(1760.91, 2476.21, 45.81, 28.88) },-- Cell Block 7, main cells - bottom 10
        { animation = "prone", coords = vector4(1768.96, 2478.74, 47.4, 20.84) },-- Cell Block 7, main cells - bottom 12
        { animation = "mechanic", coords = vector4(1753.72, 2496.24, 50.59, 36.04) },-- Cell Block 7, main cells - top w hole
        { animation = "leanbar", coords = vector4(1770.39, 2492.65, 50.43, 123.59) },-- Cell Block 7, main cells - top middle
        { animation = "sitchair", coords = vector4(1705.51, 2457.42, 45.85, 268.29) },-- Cell Block 6, other cells - cpu room
        { animation = "book", coords = vector4(1713.95, 2456.81, 50.45, 184.51) },-- Cell Block 6, other cells - library
        { animation = "meditate", coords = vector4(1682.93, 2463.45, 45.84, 179.34) },-- Cell Block 6, other cells - bottom
        { animation = "jumpingjacks", coords = vector4(1695.94, 2443.07, 50.45, 7.34) },-- Cell Block 6, other cells - top
        { animation = "sitchair", coords = vector4(1640.57, 2530.53, 45.97, 313.14) },-- outside - couch
        { animation = "flip2", coords = vector4(1647.91, 2591.97, 50.34, 357.09) },-- skate park rmap
        { animation = "foodtraye", coords = vector4(1782.9, 2559.07, 45.67, 355.53) },-- canteen line
        { animation = "drink", coords = vector4(1784.44, 2546.15, 45.67, 1.25) },-- canteen wall kinda
        { animation = "clipboard", coords = vector4(1768.23, 2570.44, 45.73, 309.95) },-- infirmary - desk
        { animation = "sitchair", coords = vector4(1763.96, 2571.02, 45.73, 275.45) },-- infirmary - chair
        { animation = "knucklecrunch", coords = vector4(1651.69, 2547.71, 45.55, 233.4) },-- outside boxing thing
        { animation = "chinup", coords = vector4(1673.41, 2528.07, 45.55, 311.84) },-- outside pull up poles
        { animation = "bball", coords = vector4(1692.63, 2506.95, 45.56, 359.6) },-- basketball court
        { animation = "sitchair2", coords = vector4(1668.34, 2498.83, 45.55, 326.13) },-- Tennis court
        { animation = "situp", coords = vector4(1777.29, 2494.26, 45.84, 205.34) },-- Training Room
        { animation = "showerm2", coords = vector4(1731.65, 2498.14, 45.82, 160.36) },-- Training Room
        { animation = "sitchair4", coords = vector4(1677.88, 2452.08, 45.84, 0.77) },-- Break Room
        { animation = "sitchair", coords = vector4(1575.63, 2568.61, 45.99, 129.69) },-- Cell Block 4, tv room
        { animation = "chinup", coords = vector4(1584.66, 2570.48, 45.99, 176.53) },-- Cell Block 4, workout room
        { animation = "idle4", coords = vector4(1582.23, 2549.69, 45.99, 177.53) },-- Cell Block 4, workout room
        { animation = "idle4", coords = vector4(1644.77, 2610.4, 45.55, 274.37) },-- skate park
    },
}

Config.Shops = {
    Canteen = {
        label = "Canteen",
        items = {
            { name = "jailfood", price = 10, amount = 999, info = {}, type = "item" },
        }
    },
    Drinks = {
        label = "Drink Machine",
        items = {
            { name = "water_bottle", price = 10, amount = 999, info = {}, type = "item" },
        }
    },
    Infirmary = {
        label = "Infirmary",
        items = {
            { name = "bandage", price = 35, amount = 999, info = {}, type = "item" },
            { name = "painkillers", price = 35, amount = 999, info = {}, type = "item" },
        }
    },
}

Config.CraftingItems = {
    {
        receive = "weapon_shiv",
        materials = {
            { mat = "steel", amount = 20 },
            { mat = "rubber", amount = 20 },
        },
    },
    {
        receive = "trojan_usb",
        materials = {
            { mat = "steel", amount = 10 },
            { mat = "plastic", amount = 15 },
        },
    },
    {
        receive = "lockpick",
        materials = {
            { mat = "metalscrap", amount = 15 },
        },
    }
}

Config.Beds = {
    {coords = vector3(1762.21, 2591.48, 46.66), heading = 95.37, taken = false, model = 2117668672, docCoords = vector3(1762.13, 2590.54, 45.73), docHeading = 5.27},
    {coords = vector3(1761.97, 2594.6, 46.66), heading = 95.37, taken = false, model = 2117668672, docCoords = vector3(1761.9, 2593.68, 45.73), docHeading = 5.27},
    {coords = vector3(1761.96, 2597.73, 46.66), heading = 95.37, taken = false, model = 2117668672, docCoords = vector3(1762.01, 2596.7, 45.73), docHeading = 5.27},
    {coords = vector3(1771.95, 2597.99, 46.66), heading = 295.34, taken = false, model = 2117668672, docCoords = vector3(1771.68, 2597.12, 45.73), docHeading = 5.27},
    {coords = vector3(1771.85, 2594.84, 46.66), heading = 295.34, taken = false, model = 2117668672, docCoords = vector3(1771.78, 2593.94, 45.73), docHeading = 5.27},
    {coords = vector3(1771.95, 2591.88, 46.66), heading = 295.34, taken = false, model = -2117668672, docCoords = vector3(1771.94, 2590.86, 45.73), docHeading = 5.27},
}

Config.Blips = {
    {coords = vector3(1763.75, 2488.16, 45.82), sprite = 238, color = 4, label = "Cell Block 7" },
    {coords = vector3(1693.14, 2452.83, 45.84), sprite = 238, color = 4, label = "Cell Block 6" },
    {coords = vector3(1581.34, 2553.2, 45.99), sprite = 238, color = 4, label = "Abandoned Cells" },
    {coords = vector3(1828.8, 2579.62, 46.01), sprite = 466, color = 33, label = "Check Time" },
    {coords = vector3(1786.19, 2557.77, 45.62), sprite = 417, color = 44, label = "Canteen" },
    {coords = vector3(1780.19, 2501.94, 50.43), sprite = 498, color = 12, label = "Job Board" },
    {coords = vector3(1766.82, 2569.47, 45.73), sprite = 489, color = 6, label = "Infirmary" },
    {coords = vector3(1635.37, 2588.3, 45.55), sprite = 435, color = 13, label ="Skate Park" },
    {coords = vector3(1828.97, 2588.8, 46.01), sprite = 817, color = 53, label = "Visitation Center" },
    {coords = vector3(1740.59, 2497.2, 46.5), sprite = 73, color = 50, label = "Locker Room" },
    {coords = vector3(1678.09, 2471.97, 45.85), sprite = 73, color = 50, label = "Locker Room" },
}

Config.PrisonJobs = {
    electrician = {
        label = "Electrician", desc = "Repair stuff around the yard", icon = "fas fa-bolt",
        rewards = {
            { item = 'metalscrap', amount = math.random(1,3) },
            { item = 'rubber', amount = math.random(2,4) },
            { item = 'stickynote', amount = 1 },
            { item = 'cement', amount = math.random(1,2) },
        },
        locations = {
            { coords = vector4(1765.6, 2529.92, 44.55, 209.23), anim = "weld", txt = "Working on Electricity.." }, -- between cell block 7 and canteen
            { coords = vector4(1776.99, 2488.1, 49.43, 220.63), anim = "inspect", txt = "Performing Inspection.." }, -- cell block 7, upstairs office/rec room thingy 1
            { coords = vector4(1771.23, 2497.12, 49.91, 119.68), anim = "type3", txt = "Flipping Random Switches.." }, -- cell block 7, upstairs office/rec room thingy 2
            { coords = vector4(1714.92, 2533.93, 44.55, 114.11), anim = "weld", txt = "Working on Electricity.." }, -- outside no climbing wall
            { coords = vector4(1777.57, 2561.96, 44.67, 89.21), anim = "type3", txt = "Flipping Random Switches.." }, -- canteen
            { coords = vector4(1684.09, 2509.5, 44.56, 64.2), anim = "weld", txt = "Working on Electricity.." }, -- basketball court
            { coords = vector4(1705.53, 2446.09, 49.45, 167.82), anim = "weld", txt = "Working on Electricity.." }, -- cell block 6 library
            { coords = vector4(1708.49, 2459.06, 44.85, 323.26), anim = "inspect", txt = "Performing Inspection.." }, -- cell block 6 cpu room
            { coords = vector4(1626.96, 2490.22, 44.63, 150.53), anim = "weld", txt = "Working on Electricity.." }, -- cell block 5 light
            { coords = vector4(1574.69, 2567.92, 44.99, 134.16), anim = "inspect", txt = "Performing Inspection.." }, -- cell block 4 tv room
            { coords = vector4(1732.85, 2563.37, 44.55, 6.3), anim = "type3", txt = "Flipping Random Switches.." }, -- phone between infirmary and gardening thingy
            { coords = vector4(1772.74, 2571.86, 44.73, 301.43), anim = "type3", txt = "Flipping Random Switches.." }, -- phone in infirmary office
            { coords = vector4(1764.47, 2599.23, 44.73, 6.25), anim = "inspect", txt = "Performing Inspection.." }, -- idk what this is in back of infirmary
            { coords = vector4(1768.64, 2586.87, 44.73, 88.83), anim = "type3", txt = "Flipping Random Switches.." }, -- some machine in infirmary side room
            { coords = vector4(1631.67, 2609.24, 44.55, 173.01), anim = "weld", txt = "Working on Electricity.." } -- skate park
        }
    },
    cook = {
        label = "Cook", desc = "Work in the kitchen", icon = "fas fa-utensils",
        rewards = {
            { item = 'whipcream', amount = math.random(1,3) },
            { item = 'glass', amount = math.random(2,4) },
            { item = 'steel', amount = math.random(3,5) },
            { item = 'plastic', amount = math.random(1,2) },
        },
        locations = {
            { coords = vector4(1780.17, 2564.23, 44.67, 3.83), anim = "bbqf", txt = "Cooking Slop..." }, -- stove
            { coords = vector4(1777.57, 2561.91, 44.67, 92.91), anim = "idle11", txt = "Checking Timers..." }, -- microwaves
            { coords = vector4(1784.56, 2564.17, 44.67, 355.81), anim = "bbqf", txt = "Grabbing Ingredients..." }, -- fridge
            { coords = vector4(1786.54, 2564.33, 44.67, 356.82), anim = "mechanic2", txt = "Organizing Shelf..." }, -- cans
            { coords = vector4(1780.19, 2560.78, 44.67, 180.96), anim = "bbqf", txt = "Serving Slop..." }, -- counter
            { coords = vector4(1778.6, 2564.33, 44.67, 357.17), anim = "cleanhands", txt = "Washing Dishes..." }, -- sink
            { coords = vector4(1782.17, 2560.7, 44.67, 183.52), anim = "bbqf", txt = "Serving Slop..." }, -- counter mac n cheese
            { coords = vector4(1780.97, 2559.07, 44.67, 9.13), anim = "clean", txt = "Wiping Counter..." }, -- counter otherside
            { coords = vector4(1786.34, 2551.03, 44.67, 183.23), anim = "clean", txt = "Wiping Table..." }, -- counter mac n cheese
            { coords = vector4(1788.18, 2556.11, 44.67, 269.28), anim = "clean", txt = "Wiping Table..." } -- counter mac n cheese
        }
    },
    janitor = {
        label = "Janitor", desc = "Clean around the yard", icon = "fas fa-trash-can",
        rewards = {
            { item = 'metalscrap', amount = math.random(1,3) },
            { item = 'copper', amount = math.random(2,4) },
            { item = 'iron', amount = math.random(1,4) },
            { item = 'plastic', amount = math.random(1,2) },
        },
        locations = {
            { coords = vector4(1730.72, 2529.24, 44.55, 298.35), anim = "broom", txt = "Sweeping..." }, --outside no climbing wall benches
            { coords = vector4(1778.77, 2498.51, 44.82, 153.56), anim = "mop2", txt = "Mopping Floor..." }, -- cell 7 training room
            { coords = vector4(1776.56, 2555.31, 44.67, 90.9), anim = "clean2", txt = "Cleaning Window..." }, -- canteen window
            { coords = vector4(1759.01, 2546.45, 44.56, 20.94), anim = "clean", txt = "Cleaning Table..." }, --outside lunch table 1
            { coords = vector4(1754.1, 2549.02, 44.55, 120.57), anim = "clean", txt = "Cleaning Table..." }, --outside lunch table 2
            { coords = vector4(1684.21, 2450.99, 44.84, 88.1), anim = "clean", txt = "Cleaning Table..." }, -- cell 6 lunch table
            { coords = vector4(1672.32, 2472.95, 44.85, 104.6), anim = "mop2", txt = "Mopping Floor..."  }, --cell 6 showers
            { coords = vector4(1714.83, 2453.84, 44.84, 275.7), anim = "trashr", txt = "Pulling Trash Bags..." }, --cell 6 cpu room trash
            { coords = vector4(1646.25, 2530.33, 44.55, 149.86), anim = "trashr", txt = "Pulling Trash Bags..." }, --construction trash
            { coords = vector4(1580.22, 2557.01, 44.99, 346.03), anim = "clean", txt = "Cleaning Table..." },  --clean
            { coords = vector4(1625.07, 2619.18, 46.47, 246.53), anim = "broom2", txt = "Sweeping..." }, --skate park
            { coords = vector4(1785.2, 2555.24, 44.67, 96.49), anim = "broom3", txt = "Sweeping..." }, --canteen floor
            { coords = vector4(1769.84, 2582.55, 44.73, 187.88), anim = "trashr", txt = "Pulling Trash Bags..." }, --infirmary trash
            { coords = vector4(1731.81, 2498.12, 44.82, 33.16), anim = "mop2", txt = "Mopping Floor..." }, --cell 7 showers
            { coords = vector4(1770.88, 2494.8, 49.43, 303.05), anim = "clean2", txt = "Cleaning Window..." } --cell 7 window upstairs
        }
    },
    health = {
        label = "Infirmary", desc = "Help in the Infirmary", icon = "fas fa-stethoscope",
        rewards = {
            { item = 'dustbag', amount = math.random(1,3) },
            { item = 'bandage', amount = math.random(1,2) },
            { item = 'steel', amount = math.random(3,5) },
            { item = 'plastic', amount = math.random(1,2) },
        },
        locations = {
            { coords = vector4(1772.18, 2577.77, 44.73, 272.87), anim = "leanbar3", txt = "Inspecting Samples..." }, -- lab microscope thingy
            { coords = vector4(1772.12, 2576.58, 44.73, 256.8), anim = "type3", txt = "Filling out Report..." }, -- lab computer 1
            { coords = vector4(1768.53, 2576.86, 44.73, 102.68), anim = "inspect", txt = "Checking Machine..." }, -- lab some machine
            { coords = vector4(1768.61, 2575.46, 44.73, 76.19), anim = "type3", txt = "Filling out Report..." }, -- lab cpu 2
            { coords = vector4(1770.27, 2580.99, 44.73, 7.03), anim = "clean2", txt = "Wiping Board..." }, -- lab whiteboard
            { coords = vector4(1770.98, 2582.74, 44.73, 183.85), anim = "cleanhands", txt = "Washing Hands..." }, -- surgery sink
            { coords = vector4(1770.26, 2585.87, 45.8, 346.97), anim = "cpr2", txt = "Practicing CPR..." }, -- surgery bed/chair thing
            { coords = vector4(1768.61, 2586.85, 44.73, 92.11), anim = "inspect", txt = "Checking Machine..." }, -- surgery machine
            { coords = vector4(1772.09, 2597.01, 44.73, 267.07), anim = "fallasleep", txt = "Trying to Stay Awake..." }, -- ICU corner
            { coords = vector4(1763.58, 2585.2, 44.73, 180.65), anim = "leanbar3", txt = "Pretending..." }, -- hallway wheelchair
            { coords = vector4(1769.46, 2573.57, 44.73, 55.6), anim = "type3", txt = "Entering Patient Info..." }, -- reception cpu
            { coords = vector4(1769.75, 2571.84, 44.73, 139.77), anim = "wait4", txt = "Watching the Front..." }, -- reception
            { coords = vector4(1772.0, 2580.5, 44.73, 276.14), anim = "grabr", txt = "Grabbing Supplies..." }, -- lab fridge thingy
            { coords = vector4(1772.19, 2584.45, 44.73, 277.47), anim = "grabr", txt = "Digging Around..." }, -- surgery cabinets
            { coords = vector4(1766.01, 2598.96, 44.73, 184.46), anim = "grieve", txt = "Observing..." } -- main beds
        }
    },
    gardener = {
        label = "Gardener", desc = "Tend to the yard", icon = "fas fa-seedling",
        rewards = {
            { item = 'empty_bottle', amount = 1 },
            { item = 'rubber', amount = math.random(2,4) },
            { item = 'steel', amount = math.random(3,5) },
            { item = 'nametag', amount = math.random(1,2) },
        },
        locations = {
            { coords = vector4(1639.97, 2524.49, 47.37, 341.71), anim = "leafblower", txt = "Blowing The Haters Away..." }, --rocks
            { coords = vector4(1701.28, 2553.02, 44.55, 128.16), anim = "weedsr", txt = "Pulling Weeds..." }, -- garden against gate
            { coords = vector4(1771.49, 2569.24, 44.73, 330.37), anim = "weedbucket", txt = "Delivering Weed..." }, -- infirmary delivery
            { coords = vector4(1745.78, 2554.05, 44.55, 52.43), anim = "wateringr", txt = "Watering Tree..." }, --garden
            { coords = vector4(1713.36, 2538.01, 44.55, 349.17), anim = "dig", txt = "Shoveling Dirt..." }, ----garden
            { coords = vector4(1753.74, 2517.2, 44.55, 28.39), anim = "leafblower", txt = "Blowing Leaves..." }, --outside cell 7
            { coords = vector4(1718.42, 2497.59, 44.55, 287.11), anim = "weedsr", txt = "Pulling Weeds..." }, --bush by basketball court
            { coords = vector4(1685.76, 2484.89, 44.55, 58.39), anim = "rake3", txt = "Raking..." }, --outside cell 6
            { coords = vector4(1682.85, 2537.22, 44.55, 349.29), anim = "wateringr", txt = "Watering Grass..." }, --by pull up thingy
            { coords = vector4(1631.48, 2489.35, 44.55, 181.23), anim = "weedsr", txt = "Pulling Weeds..." }, --outside cell 5
            { coords = vector4(1616.02, 2566.01, 44.55, 356.37), anim = "rake3", txt = "Raking..." }, --outside skate park
            { coords = vector4(1646.4, 2555.44, 44.55, 139.96), anim = "wateringr", txt = "Watering Grass..." }, --no climbing wall num 7
            { coords = vector4(1707.45, 2552.58, 44.55, 91.18), anim = "wateringr", txt = "Watering Tree..."  }, --garden tree
            { coords = vector4(1757.6, 2510.03, 44.55, 259.05), anim = "weedsr", txt = "Pulling Weeds..." }, --bush outside cell 7
            { coords = vector4(1688.73, 2528.67, 44.55, 81.89), anim = "dig", txt = "Shoveling Dirt..." } --inside some gate                     
        }
    },
}
