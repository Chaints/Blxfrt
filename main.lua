local rawBase = "https://raw.githubusercontent.com/Chaints/Blxfrt/main/"

-- Load UI (Melayang & Detached Baru)
local UI = loadstring(game:HttpGet(rawBase .. "ui.lua"))()

-- Cek Tempat / Sea
local placeId = game.PlaceId
local currentSea = "Sea 1"
if placeId == 4442272183 then currentSea = "Sea 2"
elseif placeId == 7449423635 then currentSea = "Sea 3" end

print("ZxD Hub Loaded di: " .. currentSea)

---------------------------------------------------------
-- ISI FITUR KE DALAM UI (2-KOLOM DETACHED)
---------------------------------------------------------

-- 1. TAB AUTO FARM
local MainTab = UI:CreateTab("Auto Farm")

-- Fitur Kolom Kiri
MainTab:AddSection("FARMING UTAMA", "left")
MainTab:CreateToggle("Auto Farm Level (" .. currentSea .. ")", false, "left", function(state)
    _G.AutoFarm = state
    print("Auto Farm Status:", _G.AutoFarm)
end)
MainTab:CreateToggle("Auto Bone / Katakuri", false, "left", function(state) end)

-- Fitur Kolom Kanan
MainTab:AddSection("PENGATURAN FARM", "right")
MainTab:CreateSlider("Jarak Farm (Y-Axis)", 5, 25, 12, "right", function(value)
    print("Jarak:", value)
end)
MainTab:CreateButton("Fast Attack Mode", "right", function()
    print("Fast attack activated")
end)

-- 2. TAB TELEPORT
local TeleTab = UI:CreateTab("Teleport")
TeleTab:AddSection("SEA TELEPORT", "left")
TeleTab:CreateButton("Teleport Sea 1", "left", function() end)
TeleTab:CreateButton("Teleport Sea 2", "left", function() end)

TeleTab:AddSection("ISLANDS", "right")
TeleTab:CreateButton("TP to Mansion", "right", function() end)

-- 3. TAB MISC
local MiscTab = UI:CreateTab("Settings")
MiscTab:AddSection("SERVER", "left")
MiscTab:CreateButton("Rejoin Server", "left", function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId)
end)
