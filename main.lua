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

print("ZxD Hub Loaded di: " .. currentSea)

-- Tampilkan Info Status (Placeholder)
UI:AddPlaceholder("STATUS: Connected (" .. currentSea .. ")")

-- Bikin Toggle Auto Farm pakai fungsi bawaan UI (Lebih simpel & enteng)
_G.AutoFarm = false
UI:CreateToggle("Auto Farm " .. currentSea, function(state)
    _G.AutoFarm = state
    print("Auto Farm Status:", _G.AutoFarm)
end)
