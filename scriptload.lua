-- scriptload.lua
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScriptLoad = {}

-- Global Toggle State
_G.AutoFarm = _G.AutoFarm or false
_G.AutoEquipMelee = true -- Default aktif pas Auto Farm ON
_G.AutoAttack = true     -- Default aktif pas Auto Farm ON

-- 1. FUNGSI TWEEN (GERAK MULUS)
function ScriptLoad.TweenTo(targetCFrame, speed)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = distance / (speed or 300)
    
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    return tween
end

-- 2. FUNGSI AUTO EQUIP MELEE
function ScriptLoad.EquipMelee()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    
    if not character or not backpack then return end

    -- Cek apakah sudah pegang senjata jenis Melee di Character
    local currentTool = character:FindFirstChildOfClass("Tool")
    if currentTool and currentTool:FindFirstChild("ToolTip") and currentTool.ToolTip == "Melee" then
        return -- Sudah pegang Melee, tidak perlu Equip ulang
    end

    -- Cari Melee di Backpack lalu Equip
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool:FindFirstChild("ToolTip") and tool.ToolTip == "Melee" or tool.ToolTip == "Combat") then
            character.Humanoid:EquipTool(tool)
            break
        end
    end
end

-- 3. FUNGSI AUTO BASIC ATTACK (KLIK OTOMATIS)
function ScriptLoad.Click()
    -- Menggunakan VirtualUser agar simulasi klik layar/mouse berjalan halus
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(500, 500))
end

-- 4. LOOP UTAMA (AUTO FARM + EQUIP + ATTACK)
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end

                -- Auto Equip Melee
                if _G.AutoEquipMelee then
                    ScriptLoad.EquipMelee()
                end

                -- Cari Musuh Terdekat
                local enemiesFolder = workspace:FindFirstChild("Enemies")
                if enemiesFolder then
                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        local hrp = enemy:FindFirstChild("HumanoidRootPart")
                        local hum = enemy:FindFirstChild("Humanoid")
                        
                        if hrp and hum and hum.Health > 0 then
                            -- Position 5 stud di atas musuh biar aman
                            local targetPos = hrp.CFrame * CFrame.new(0, 5, 2)
                            
                            -- Tween ke posisi musuh
                            ScriptLoad.TweenTo(targetPos, 300)

                            -- Auto Basic Attack
                            if _G.AutoAttack then
                                ScriptLoad.Click()
                            end
                            break
                        end
                    end
                end
            end)
        end
    end
end)

return ScriptLoad
