-- main.lua
local rawBase = "https://raw.githubusercontent.com/Chaints/Blxfrt/main/"

-- Load UI & Auto Script
local UI = loadstring(game:HttpGet(rawBase .. "ui.lua"))()
local ScriptLoad = loadstring(game:HttpGet(rawBase .. "scriptload.lua"))()

-- Pengecekan Sea berdasarkan PlaceId
local placeId = game.PlaceId
local currentSea = "Unknown"

if placeId == 2753915549 then
    currentSea = "Sea 1"
elseif placeId == 4442272183 then
    currentSea = "Sea 2"
elseif placeId == 7449423635 then
    currentSea = "Sea 3"
end

print("DakzzHub Loaded di: " .. currentSea)

-- Bikin Tombol Auto Farm di UI yang di-load
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleAutoFarm"
ToggleButton.Size = UDim2.new(1, 0, 0, 35)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.Text = "Auto Farm (" .. currentSea .. "): OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 75, 75)
ToggleButton.Font = Enum.Font.SourceSansSemibold
ToggleButton.TextSize = 13
ToggleButton.Parent = UI.Container

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

_G.AutoFarm = false
ToggleButton.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    if _G.AutoFarm then
        ToggleButton.Text = "Auto Farm (" .. currentSea .. "): ON"
        ToggleButton.TextColor3 = Color3.fromRGB(75, 255, 75)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 60, 35)
    else
        ToggleButton.Text = "Auto Farm (" .. currentSea .. "): OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 75, 75)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)
