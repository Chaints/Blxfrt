local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local ScriptLoad = {}

_G.AutoFarm = _G.AutoFarm or false
_G.AutoEquipMelee = true
_G.AutoAttack = true

-- MENCARI REMOTE DENGAN AMAN (TIDAK AKAN CRASH JIKA PATH SALAH)
local Net = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
local RegisterAttack = Net and Net:FindFirstChild("RegisterAttack")
local RegisterHit = Net and Net:FindFirstChild("RegisterHit")

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

-- 3. AUTO ATTACK SAFE MODE
function ScriptLoad.AttackTarget(targetEnemy)
    local character = LocalPlayer.Character
    if not character or not targetEnemy then return end
    
    local enemyHrp = targetEnemy:FindFirstChild("HumanoidRootPart")
    local tool = character:FindFirstChildOfClass("Tool")
    
    if enemyHrp and tool then
        -- Opsi 1: Pakai Remote jika ketemu
        if RegisterAttack and RegisterHit then
            local hitPart = tool:FindFirstChild("Handle") or tool:FindFirstChildOfClass("Part") or enemyHrp
            RegisterAttack:FireServer(0)
            RegisterHit:FireServer(hitPart, {enemyHrp})
        end
        
        -- Opsi 2: Click Fallback jika Remote tidak ketemu
        VirtualUser:CaptureController()
        VirtualUser:Button1Down(Vector2.new(0,0))
        tool:Activate()
    end
end

-- 4. LOOP UTAMA
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then

                if _G.AutoEquipMelee then
                    ScriptLoad.EquipMelee()
                end

                local enemiesFolder = workspace:FindFirstChild("Enemies")
                if enemiesFolder then
                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        local hrp = enemy:FindFirstChild("HumanoidRootPart")
                        local hum = enemy:FindFirstChild("Humanoid")
                        
                        if hrp and hum and hum.Health > 0 then
                            local targetPos = hrp.CFrame * CFrame.new(0, 5, 0)
                            ScriptLoad.TweenTo(targetPos, 300)

                            if _G.AutoAttack then
                                ScriptLoad.AttackTarget(enemy)
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end)

return ScriptLoad
