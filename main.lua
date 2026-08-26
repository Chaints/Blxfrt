local rawBase = "https://raw.githubusercontent.com/Chaints/Blxfrt/main/"
local UI = loadstring(game:HttpGet(rawBase .. "ui.lua"))()

-- Tab Atas 1
local MainTab = UI:CreateTab("Auto Farm")
MainTab:AddSection("FARMING MAIN")
MainTab:CreateToggle("Auto Farm Level", false, function(s) end)
MainTab:CreateToggle("Auto Bone", false, function(s) end)

-- Tab Atas 2
local TeleTab = UI:CreateTab("Teleport")
TeleTab:AddSection("LOCATION")
TeleTab:CreateButton("Teleport Sea 1", function() end)
TeleTab:CreateButton("Teleport Sea 2", function() end)

-- Tab Atas 3
local StatsTab = UI:CreateTab("Stats")
StatsTab:AddSection("AUTO STATS")
StatsTab:CreateToggle("Auto Melee", false, function(s) end)

-- Tab Atas 4
local MiscTab = UI:CreateTab("Settings")
MiscTab:AddSection("SERVER")
MiscTab:CreateButton("Rejoin Server", function() end)
