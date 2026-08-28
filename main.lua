-- main.lua
local rawBase = "https://raw.githubusercontent.com/Chaints/Blxfrt/main/"

-- Load UI & Modul Pendukung (Dengan Anti-Cache tick())
local UI = loadstring(game:HttpGet(rawBase .. "ui.lua?" .. tick()))()
local ScriptLoad = loadstring(game:HttpGet(rawBase .. "scriptload.lua?" .. tick()))()
local TP = loadstring(game:HttpGet(rawBase .. "tp.lua?" .. tick()))()
local Gacha = loadstring(game:HttpGet(rawBase .. "gacha.lua?" .. tick()))()

-- Pengecekan Sea berdasarkan PlaceId
local placeId = game.PlaceId
local currentSea = "Sea 1"

if placeId == 2753915549 then
    currentSea = "Sea 1"
elseif placeId == 4442272183 then
    currentSea = "Sea 2"
elseif placeId == 7449423635 then
    currentSea = "Sea 3"
end

print("ZxD Hub Loaded di: " .. currentSea)

---------------------------------------------------------
-- SETUP FITUR DENGAN SISTEM GAP 2 CARD (KIRI & KANAN)
---------------------------------------------------------

-- TAB 1: AUTO FARM
local FarmTab = UI:CreateTab("Auto Farm")

-- CARD KIRI (dipakai setiap saat)
FarmTab:AddSection("Main Farming", "left")

_G.AutoFarm = false
FarmTab:CreateToggle("Auto Farm Level (" .. currentSea .. ")", _G.AutoFarm, "left", function(state)
    _G.AutoFarm = state
    print("Auto Farm Status:", _G.AutoFarm)
end)

_G.EnableMastery = false
FarmTab:CreateToggle("Auto Mastery", _G.EnableMastery, "left", function(state)
    _G.EnableMastery = state
    print("Enable Mastery Status:", state)
end)

_G.SelectedWeapon = "Melee"
FarmTab:CreateDropdown("Select Weapon", {"Melee", "Sword", "Fruit", "Gun"}, "Melee", "left", function(choice)
    _G.SelectedWeapon = choice
    print("Weapon Selected:", choice)
end)

_G.FarmMethod = "Nearest"
FarmTab:CreateDropdown("Farm Method", {"Quest", "Nearest", "No Quest"}, "Nearest", "left", function(choice)
    _G.FarmMethod = choice
    print("Farm Method:", choice)
end)

_G.TweenSpeed = 200
FarmTab:CreateSliderInput("Tween Speed", 100, 200, 200, "left", function(value)
    _G.TweenSpeed = value
end)

_G.FarmDistance = 15
FarmTab:CreateSliderInput("Distance (Nearest)", 5, 100, 15, "left", function(value)
    _G.FarmDistance = value
end)

_G.HealthMobPercent = 15
FarmTab:CreateSliderInput("Health Mob %", 1, 100, 15, "left", function(value)
    _G.HealthMobPercent = value
end)

_G.BringMob = true
FarmTab:CreateToggle("Bring Mob", _G.BringMob, "left", function(state)
    _G.BringMob = state
    print("Bring Mob Status:", state)
end)

_G.BringRange = 55
FarmTab:CreateSliderInput("Bring Range (Stud)", 5, 150, 55, "left", function(value)
    _G.BringRange = value
end)

-- AUTO ATTACK (independen dari Auto Farm - jalan sendiri tanpa perlu nyalain toggle Auto Farm dulu)
FarmTab:AddSection("Auto Attack", "left")

_G.AutoAttack = true
FarmTab:CreateToggle("Auto Attack (55 Stud)", _G.AutoAttack, "left", function(state)
    _G.AutoAttack = state
    print("Auto Attack Status:", state)
end)

_G.AttackTargetMob = true
FarmTab:CreateToggle("Target: Mob", _G.AttackTargetMob, "left", function(state)
    _G.AttackTargetMob = state
    print("Attack Target Mob:", state)
end)

_G.AttackTargetPlayer = false
FarmTab:CreateToggle("Target: Player", _G.AttackTargetPlayer, "left", function(state)
    _G.AttackTargetPlayer = state
    print("Attack Target Player:", state)
end)

-- CARD KANAN (config + boss farming Sea 1)
FarmTab:AddSection("Farm Config", "right")

FarmTab:CreateSlider("Distance Y-Axis", 5, 25, 12, "right", function(value)
    _G.FarmDistanceYAxis = value
end)

FarmTab:AddSection("Boss Farm", "right")

_G.AutoBones = false
FarmTab:CreateToggle("Auto Bones", _G.AutoBones, "right", function(state)
    _G.AutoBones = state
    print("Auto Bones Status:", state)
end)

_G.AutoKatakuri = false
FarmTab:CreateToggle("Auto Katakuri", _G.AutoKatakuri, "right", function(state)
    _G.AutoKatakuri = state
    print("Auto Katakuri Status:", state)
end)

_G.AutoSummonTyrant = false
FarmTab:CreateToggle("Auto Summon Tyrant of the Skies", _G.AutoSummonTyrant, "right", function(state)
    _G.AutoSummonTyrant = state
    print("Auto Summon Tyrant Status:", state)
end)

FarmTab:CreateButton("Fast Attack Mode", "right", function()
    print("Fast Attack Triggered!")
end)

FarmTab:CreateButton("Bypass TP Weapon", "right", function()
    print("Bypass TP Triggered!")
end)

---------------------------------------------------------

-- TAB 2: TELEPORT (TERHUBUNG KE TP.LUA)
local TeleTab = UI:CreateTab("Teleport")

-- CARD KIRI: SEA TRAVEL
TeleTab:AddSection("Sea Teleport", "left")

TeleTab:CreateButton("Teleport Sea 1", "left", function()
    TP.TeleportToSea("Sea 1")
end)
TeleTab:CreateButton("Teleport Sea 2", "left", function()
    TP.TeleportToSea("Sea 2")
end)
TeleTab:CreateButton("Teleport Sea 3", "left", function()
    TP.TeleportToSea("Sea 3")
end)

-- CARD KANAN: QUICK ISLANDS (DINAMIS Sesuai Sea Saat Ini)
TeleTab:AddSection("Quick Islands (" .. currentSea .. ")", "right")

if currentSea == "Sea 1" then
    TeleTab:CreateButton("Starter Island", "right", function() TP.TeleportToIsland("Sea 1", "Starter Island") end)
    TeleTab:CreateButton("Jungle", "right", function() TP.TeleportToIsland("Sea 1", "Jungle") end)
    TeleTab:CreateButton("Pirate Village", "right", function() TP.TeleportToIsland("Sea 1", "Pirate Village") end)
    TeleTab:CreateButton("Desert", "right", function() TP.TeleportToIsland("Sea 1", "Desert") end)
    TeleTab:CreateButton("Frozen Village", "right", function() TP.TeleportToIsland("Sea 1", "Frozen Village") end)
    TeleTab:CreateButton("MarineFord", "right", function() TP.TeleportToIsland("Sea 1", "MarineFord") end)
    TeleTab:CreateButton("Skypiea", "right", function() TP.TeleportToIsland("Sea 1", "Skypiea") end)
    TeleTab:CreateButton("Prison", "right", function() TP.TeleportToIsland("Sea 1", "Prison") end)
    TeleTab:CreateButton("Colosseum", "right", function() TP.TeleportToIsland("Sea 1", "Colosseum") end)
    TeleTab:CreateButton("Magma Village", "right", function() TP.TeleportToIsland("Sea 1", "Magma Village") end)
    TeleTab:CreateButton("Underwater Island", "right", function() TP.TeleportToIsland("Sea 1", "Underwater Island") end)
    TeleTab:CreateButton("Upper Skylands", "right", function() TP.TeleportToIsland("Sea 1", "Upper Skylands") end)
    TeleTab:CreateButton("Fountain City", "right", function() TP.TeleportToIsland("Sea 1", "Fountain City") end)

elseif currentSea == "Sea 2" then
    TeleTab:CreateButton("Cafe", "right", function() TP.TeleportToIsland("Sea 2", "Cafe") end)
    TeleTab:CreateButton("Kingdom of Rose", "right", function() TP.TeleportToIsland("Sea 2", "Kingdom of Rose") end)
    TeleTab:CreateButton("Uship / Graveyard", "right", function() TP.TeleportToIsland("Sea 2", "Uship / Graveyard") end)
    TeleTab:CreateButton("Green Zone", "right", function() TP.TeleportToIsland("Sea 2", "Green Zone") end)
    TeleTab:CreateButton("Dark Arena", "right", function() TP.TeleportToIsland("Sea 2", "Dark Arena") end)
    TeleTab:CreateButton("Snow Mountain", "right", function() TP.TeleportToIsland("Sea 2", "Snow Mountain") end)
    TeleTab:CreateButton("Hot and Cold", "right", function() TP.TeleportToIsland("Sea 2", "Hot and Cold") end)
    TeleTab:CreateButton("Cursed Ship", "right", function() TP.TeleportToIsland("Sea 2", "Cursed Ship") end)
    TeleTab:CreateButton("Ice Castle", "right", function() TP.TeleportToIsland("Sea 2", "Ice Castle") end)
    TeleTab:CreateButton("Forgotten Island", "right", function() TP.TeleportToIsland("Sea 2", "Forgotten Island") end)

elseif currentSea == "Sea 3" then
    TeleTab:CreateButton("Mansion", "right", function() TP.TeleportToIsland("Sea 3", "Mansion") end)
    TeleTab:CreateButton("Port Town", "right", function() TP.TeleportToIsland("Sea 3", "Port Town") end)
    TeleTab:CreateButton("Great Tree", "right", function() TP.TeleportToIsland("Sea 3", "Great Tree") end)
    TeleTab:CreateButton("Castle On The Sea", "right", function() TP.TeleportToIsland("Sea 3", "Castle On The Sea") end)
    TeleTab:CreateButton("Hydra Island", "right", function() TP.TeleportToIsland("Sea 3", "Hydra Island") end)
    TeleTab:CreateButton("Floating Turtle", "right", function() TP.TeleportToIsland("Sea 3", "Floating Turtle") end)
    TeleTab:CreateButton("Haunted Castle", "right", function() TP.TeleportToIsland("Sea 3", "Haunted Castle") end)
    TeleTab:CreateButton("Sea of Treats", "right", function() TP.TeleportToIsland("Sea 3", "Sea of Treats") end)
    TeleTab:CreateButton("Tiki Outpost", "right", function() TP.TeleportToIsland("Sea 3", "Tiki Outpost") end)
end

---------------------------------------------------------

-- TAB: FRUIT
local FruitTab = UI:CreateTab("Fruit")

-- CARD KIRI
FruitTab:AddSection("Fruit Settings", "left")
FruitTab:CreateButton("Roll Random Fruit", "left", function()
    Gacha.BuyRandomFruit()
end)
FruitTab:CreateToggle("Auto Eat Fruit", false, "left", function(state) end)
FruitTab:CreateToggle("Notify Fruit Spawn", false, "left", function(state) end)
FruitTab:CreateToggle("Auto Buy Fruit", false, "left", function(state) end)
FruitTab:CreateToggle("Auto Reroll Fruit", false, "left", function(state) end)
FruitTab:CreateDropdown("Prioritas Fruit", {"Buddha", "Mera", "Dark", "Rumble"}, "Buddha", "left", function(choice) end)

-- CARD KANAN
FruitTab:AddSection("Fruit Storage", "right")
FruitTab:CreateToggle("Fruit Storage", false, "right", function(state) end)
FruitTab:CreateToggle("Auto Sell Duplicate Fruit", false, "right", function(state) end)
FruitTab:CreateButton("Sell Fruit", "right", function() end)

---------------------------------------------------------

-- TAB: SEA EVENT
local EventTab = UI:CreateTab("Sea Event")

-- CARD KIRI
EventTab:AddSection("Event Control", "left")
EventTab:CreateToggle("Auto Detect Event", false, "left", function(state) end)
EventTab:CreateToggle("Auto Join Event", false, "left", function(state) end)
EventTab:CreateToggle("Skip Event Lain", false, "left", function(state) end)
EventTab:CreateDropdown("Prioritas Event", {"Ship Raid", "Factory", "Cyborg Invasion", "Tides"}, "Ship Raid", "left", function(choice) end)

-- CARD KANAN
EventTab:AddSection("Event Config", "right")
EventTab:CreateToggle("Auto Damage", false, "right", function(state) end)
EventTab:CreateToggle("Auto Loot", false, "right", function(state) end)
EventTab:CreateToggle("Auto Collect Reward", false, "right", function(state) end)

---------------------------------------------------------

-- TAB: RACE
local RaceTab = UI:CreateTab("Race")

-- CARD KIRI
RaceTab:AddSection("Race Settings", "left")
RaceTab:CreateDropdown("Select Race", {"Human", "Fishman", "Cyborg", "Mink"}, "Human", "left", function(choice) end)
RaceTab:CreateToggle("Auto Start Race Quest", false, "left", function(state) end)
RaceTab:CreateToggle("Auto Talk NPC Race", false, "left", function(state) end)
RaceTab:CreateToggle("Skip Cutscene/Dialog", false, "left", function(state) end)

-- CARD KANAN
RaceTab:AddSection("Race Progress", "right")
RaceTab:CreateToggle("Notify Race Quest Available", false, "right", function(state) end)
RaceTab:CreateButton("Check Progress", "right", function() end)

---------------------------------------------------------

-- TAB: SHOP / ITEMS
local ShopTab = UI:CreateTab("Shop")

-- CARD KIRI
ShopTab:AddSection("Auto Buy", "left")
ShopTab:CreateDropdown("Select Shop", {"Sword Shop", "Gun Shop", "Blacksmith"}, "Sword Shop", "left", function(choice) end)
ShopTab:CreateToggle("Auto Buy Termurah-Terbagus", false, "left", function(state) end)
ShopTab:CreateToggle("Auto Refill Ammo", false, "left", function(state) end)
ShopTab:CreateToggle("Auto Buy Accessory Event", false, "left", function(state) end)
ShopTab:CreateButton("Buy Item", "left", function() end)

-- CARD KANAN
ShopTab:AddSection("Inventory", "right")
ShopTab:CreateToggle("Auto Equip Best Weapon", false, "right", function(state) end)
ShopTab:CreateToggle("Auto Sell Junk", false, "right", function(state) end)
ShopTab:CreateButton("Equip Best Item", "right", function() end)
ShopTab:CreateButton("Sell Junk", "right", function() end)

---------------------------------------------------------

-- TAB: RAID
local RaidTab = UI:CreateTab("Raid")

-- CARD KIRI
RaidTab:AddSection("Raid Control", "left")
RaidTab:CreateToggle("Auto Join Raid", false, "left", function(state) end)
RaidTab:CreateToggle("Auto Attack Boss", false, "left", function(state) end)
RaidTab:CreateToggle("Auto Revive", false, "left", function(state) end)

-- CARD KANAN
RaidTab:AddSection("Raid Info", "right")
RaidTab:CreateToggle("Notify Raid Available", false, "right", function(state) end)
RaidTab:CreateToggle("Auto Leave Jika Gagal/Timeout", false, "right", function(state) end)
RaidTab:CreateButton("Check Reward", "right", function() end)

---------------------------------------------------------

-- TAB 4: PLAYER
local PlayerTab = UI:CreateTab("Player")

-- CARD KIRI
PlayerTab:AddSection("Movement", "left")

PlayerTab:CreateSlider("WalkSpeed", 16, 200, 16, "left", function(speed)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = speed
    end
end)

PlayerTab:CreateSlider("JumpPower", 50, 300, 50, "left", function(power)
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.JumpPower = power
    end
end)

_G.InfiniteJump = false
PlayerTab:CreateToggle("Infinite Jump", _G.InfiniteJump, "left", function(state)
    _G.InfiniteJump = state
    print("Infinite Jump Status:", state)
end)

_G.AntiAFK = false
PlayerTab:CreateToggle("Anti AFK", _G.AntiAFK, "left", function(state)
    _G.AntiAFK = state
    print("Anti AFK Status:", state)
end)

-- CARD KANAN
PlayerTab:AddSection("Advanced", "right")

_G.FlyEnabled = false
PlayerTab:CreateToggle("Fly", _G.FlyEnabled, "right", function(state)
    _G.FlyEnabled = state
    print("Fly Status:", state)
end)

_G.FlySpeed = 50
PlayerTab:CreateSlider("Fly Speed", 10, 200, 50, "right", function(value)
    _G.FlySpeed = value
end)

_G.NoclipEnabled = false
PlayerTab:CreateToggle("Noclip", _G.NoclipEnabled, "right", function(state)
    _G.NoclipEnabled = state
    print("Noclip Status:", state)
end)

_G.AutoRespawn = false
PlayerTab:CreateToggle("Auto Respawn", _G.AutoRespawn, "right", function(state)
    _G.AutoRespawn = state
    print("Auto Respawn Status:", state)
end)

_G.InfiniteStamina = false
PlayerTab:CreateToggle("Infinite Stamina", _G.InfiniteStamina, "right", function(state)
    _G.InfiniteStamina = state
    print("Infinite Stamina Status:", state)
end)

---------------------------------------------------------

-- TAB 5: MISC / VISUAL
local MiscTab = UI:CreateTab("Misc")

-- CARD KIRI
MiscTab:AddSection("ESP", "left")

_G.ESPPlayer = false
MiscTab:CreateToggle("ESP Player", _G.ESPPlayer, "left", function(state)
    _G.ESPPlayer = state
    print("ESP Player Status:", state)
end)

_G.ESPMob = false
MiscTab:CreateToggle("ESP Mob / NPC", _G.ESPMob, "left", function(state)
    _G.ESPMob = state
    print("ESP Mob Status:", state)
end)

_G.ESPChest = false
MiscTab:CreateToggle("ESP Chest / Item", _G.ESPChest, "left", function(state)
    _G.ESPChest = state
    print("ESP Chest Status:", state)
end)

_G.HideOtherPlayers = false
MiscTab:CreateToggle("Hide Other Players", _G.HideOtherPlayers, "left", function(state)
    _G.HideOtherPlayers = state
    print("Hide Other Players Status:", state)
end)

-- CARD KANAN
MiscTab:AddSection("Visual", "right")

_G.RemoveFog = false
MiscTab:CreateToggle("Remove Fog", _G.RemoveFog, "right", function(state)
    _G.RemoveFog = state
    game:GetService("Lighting").FogEnd = state and 100000 or 5000
    print("Remove Fog Status:", state)
end)

_G.Fullbright = false
MiscTab:CreateToggle("Fullbright", _G.Fullbright, "right", function(state)
    _G.Fullbright = state
    print("Fullbright Status:", state)
end)

_G.LowGraphics = false
MiscTab:CreateToggle("Low Graphics (FPS Boost)", _G.LowGraphics, "right", function(state)
    _G.LowGraphics = state
    print("Low Graphics Status:", state)
end)

_G.AutoScreenshot = false
MiscTab:CreateToggle("Auto Screenshot", _G.AutoScreenshot, "right", function(state)
    _G.AutoScreenshot = state
    print("Auto Screenshot Status:", state)
end)

MiscTab:CreateSlider("Time of Day", 0, 24, 14, "right", function(hour)
    game:GetService("Lighting").ClockTime = hour
end)

---------------------------------------------------------

-- TAB 6: SETTINGS
local SettingsTab = UI:CreateTab("Settings")

-- CARD KIRI
SettingsTab:AddSection("Server Control", "left")
SettingsTab:CreateButton("Rejoin Server", "left", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)
SettingsTab:CreateButton("Server Hop", "left", function() end)
