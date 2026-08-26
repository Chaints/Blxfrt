local rawBase = "https://raw.githubusercontent.com/Chaints/Blxfrt/main/"
local UI = loadstring(game:HttpGet(rawBase .. "ui.lua"))()

-- 1. TAB AUTO FARM
local FarmTab = UI:CreateTab("Auto Farm")

-- KOLOM KIRI (Farming Main)
FarmTab:AddSection("TOGGLES INTI", "left")
FarmTab:CreateToggle("Auto Farm Level", false, "left", function(s) end)
FarmTab:CreateToggle("Auto Bone / Quest", false, "left", function(s) end)
FarmTab:CreateToggle("Auto Katakuri", false, "left", function(s) end)

-- KOLOM KANAN (Modifiers & Distance)
FarmTab:AddSection("MODIFIERS", "right")
FarmTab:CreateSlider("Farm Distance Y", 5, 25, 12, "right", function(val) end)
FarmTab:CreateButton("Fast Attack Mode", "right", function() end)

-- 2. TAB TELEPORT
local TeleTab = UI:CreateTab("Teleport")
TeleTab:AddSection("SEA SELECTION", "left")
TeleTab:CreateButton("Teleport Sea 1", "left", function() end)
TeleTab:CreateButton("Teleport Sea 2", "left", function() end)

TeleTab:AddSection("ISLANDS", "right")
TeleTab:CreateButton("TP to Mansion", "right", function() end)
