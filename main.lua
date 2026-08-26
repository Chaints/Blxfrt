local rawBase = "https://raw.githubusercontent.com/Chaints/Blxfrt/main/"
local UI = loadstring(game:HttpGet(rawBase .. "ui.lua"))()

-- 1. TAB FARMING
local FarmTab = UI:CreateTab("Auto Farm")
FarmTab:AddSection("Main Farm")
FarmTab:CreateToggle("Auto Farm Level", false, function(state) print("Auto Farm:", state) end)
FarmTab:CreateToggle("Auto Bone", false, function(state) end)

FarmTab:AddSection("Farm Distance")
FarmTab:CreateSlider("Distance Y-Axis", 5, 25, 12, function(val)
    print("Farm Distance:", val)
end)

-- 2. TAB PLAYER
local PlayerTab = UI:CreateTab("Player")
PlayerTab:AddSection("Player Boost")
PlayerTab:CreateSlider("WalkSpeed", 16, 200, 16, function(speed)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
end)

PlayerTab:CreateButton("Bypass Anti-Cheat Speed", function()
    print("Bypassed!")
end)

-- 3. TAB SETTINGS
local SettingsTab = UI:CreateTab("Settings")
SettingsTab:AddSection("Server Control")
SettingsTab:CreateButton("Rejoin Server", function() end)
