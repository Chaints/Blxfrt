local rawBase = "https://raw.githubusercontent.com/Chaints/Blxfrt/main/"

-- Load UI
local UI = loadstring(game:HttpGet(rawBase .. "ui.lua"))()

-- Cek Sea
local placeId = game.PlaceId
local currentSea = "Sea 1"
if placeId == 4442272183 then currentSea = "Sea 2"
elseif placeId == 7449423635 then currentSea = "Sea 3" end

print("ZxD Hub Loaded di: " .. currentSea)

---------------------------------------------------------
-- DEKLARASI TAB UI (Sangat Rapi & Terstruktur)
---------------------------------------------------------

-- 1. TAB MAIN FARM
local MainTab = UI:CreateTab("Auto Farm")
MainTab:AddSection("Farm Status")
MainTab:AddPlaceholder("Current Sea: " .. currentSea)

MainTab:AddSection("Farming Options")
MainTab:CreateToggle("Auto Farm Level", false, function(state)
    _G.AutoFarm = state
    print("Auto Farm Level:", state)
end)

MainTab:CreateToggle("Auto Bone / Katakuri", false, function(state)
    print("Auto Bone:", state)
end)

MainTab:CreateButton("Bypass TP Weapon", function()
    print("Bypass Executed")
end)

-- 2. TAB TELEPORT
local TeleportTab = UI:CreateTab("Teleport")
TeleportTab:AddSection("Sea Teleport")
TeleportTab:CreateButton("Teleport to Sea 1", function() end)
TeleportTab:CreateButton("Teleport to Sea 2", function() end)
TeleportTab:CreateButton("Teleport to Sea 3", function() end)

TeleportTab:AddSection("Islands")
TeleportTab:CreateButton("TP to Mansion / Castle", function() end)

-- 3. TAB STATS & SKILL
local StatsTab = UI:CreateTab("Stats")
StatsTab:AddSection("Auto Stats Points")
StatsTab:CreateToggle("Auto Melee Points", false, function(s) end)
StatsTab:CreateToggle("Auto Defense Points", false, function(s) end)

-- 4. TAB MISC & SETTINGS
local SettingsTab = UI:CreateTab("Settings")
SettingsTab:AddSection("Server Options")
SettingsTab:CreateButton("Rejoin Server", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)
SettingsTab:CreateButton("Server Hop", function() end)
