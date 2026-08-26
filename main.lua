-- main.lua
local rawBase = "https://raw.githubusercontent.com/Chaints/Blxfrt/main/"

-- Load UI (Dengan Anti-Cache tick())
local UI = loadstring(game:HttpGet(rawBase .. "ui.lua?" .. tick()))()
local ScriptLoad = loadstring(game:HttpGet(rawBase .. "scriptload.lua?" .. tick()))()

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

-- CARD KIRI
FarmTab:AddSection("Main Farming", "left")

_G.AutoFarm = false
FarmTab:CreateToggle("Auto Farm Level (" .. currentSea .. ")", _G.AutoFarm, "left", function(state)
    _G.AutoFarm = state
    print("Auto Farm Status:", _G.AutoFarm)
end)

FarmTab:CreateToggle("Auto Bone / Katakuri", false, "left", function(state)
    print("Auto Bone Status:", state)
end)

FarmTab:CreateToggle("Auto Stats (Melee/Def)", false, "left", function(state)
    print("Auto Stats Status:", state)
end)

-- CARD KANAN
FarmTab:AddSection("Farm Config", "right")

FarmTab:CreateSlider("Distance Y-Axis", 5, 25, 12, "right", function(value)
    _G.FarmDistance = value
end)

FarmTab:CreateButton("Fast Attack Mode", "right", function()
    print("Fast Attack Triggered!")
end)

FarmTab:CreateButton("Bypass TP Weapon", "right", function()
    print("Bypass TP Triggered!")
end)

---------------------------------------------------------

-- TAB 2: TELEPORT
local TeleTab = UI:CreateTab("Teleport")

-- CARD KIRI
TeleTab:AddSection("Sea Teleport", "left")
TeleTab:CreateButton("Teleport Sea 1", "left", function() end)
TeleTab:CreateButton("Teleport Sea 2", "left", function() end)
TeleTab:CreateButton("Teleport Sea 3", "left", function() end)

-- CARD KANAN
TeleTab:AddSection("Quick Islands", "right")
TeleTab:CreateButton("TP to Mansion", "right", function() end)
TeleTab:CreateButton("TP to Cafe", "right", function() end)

---------------------------------------------------------

-- TAB 3: SETTINGS
local SettingsTab = UI:CreateTab("Settings")

-- CARD KIRI
SettingsTab:AddSection("Server Control", "left")
SettingsTab:CreateButton("Rejoin Server", "left", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)
SettingsTab:CreateButton("Server Hop", "left", function() end)

-- CARD KANAN
SettingsTab:AddSection("Player Boost", "right")
SettingsTab:CreateSlider("WalkSpeed Boost", 16, 200, 16, "right", function(speed)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
    end
end)
