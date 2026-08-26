local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local ScriptLoad = {}

_G.AutoFarm = _G.AutoFarm or false
_G.AutoEquipMelee = true
_G.AutoAttack = true

-- 1. FUNGSI TWEEN MOVEMENT
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

-- 2. AUTO EQUIP MELEE
function ScriptLoad.EquipMelee()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not character or not backpack then return end

    if character:FindFirstChildOfClass("Tool") then return end

    local meleeKeywords = {"Combat", "Dark Step", "Electro", "Water Kung Fu", "Dragon Claw", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman", "Sanguine Art"}

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local isMelee = false
            if tool:FindFirstChild("ToolTip") and tool.ToolTip == "Melee" then
                isMelee = true
            else
                for _, name in ipairs(meleeKeywords) do
                    if string.find(tool.Name, name) then
                        isMelee = true
                        break
                    end
                end
            end

            if isMelee then
                character.Humanoid:EquipTool(tool)
                break
            end
        end
    end
end

-- 3. AUTO ATTACK (VIRTUAL CLICK + REMOTE FIRE)
function ScriptLoad.AttackTarget(targetEnemy)
    pcall(function()
        local character = LocalPlayer.Character
        if not character or not targetEnemy then return end
        
        local enemyHrp = targetEnemy:FindFirstChild("HumanoidRootPart")
        local tool = character:FindFirstChildOfClass("Tool")
        
        if enemyHrp and tool then
            -- Trigger ayunan senjata
            RegisterAttack:FireServer(0)
            
            -- Trigger registrasi damage ke server (Paksa Hit ke Target)
            RegisterHit:FireServer(enemyHrp, {enemyHrp})
            
            -- Activation buatan di Client
            tool:Activate()
        end
    end)
end


-- 4. LOOP UTAMA (FARMING & ATTACK)
task.spawn(function()
    while task.wait(0.01) do
        if _G.AutoFarm then
            pcall(function()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end

                -- Equip Melee jika belum pegang weapon
                if _G.AutoEquipMelee then
                    ScriptLoad.EquipMelee()
                end

                local enemiesFolder = workspace:FindFirstChild("Enemies")
                if enemiesFolder then
                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        local hrp = enemy:FindFirstChild("HumanoidRootPart")
                        local hum = enemy:FindFirstChild("Humanoid")
                        
                        -- Cek jika musuh masih hidup
                        if hrp and hum and hum.Health > 0 then
                            local targetPos = hrp.CFrame * CFrame.new(0, 4, 1)
                            ScriptLoad.TweenTo(targetPos, 300)

                            -- Trigger Serangan
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
