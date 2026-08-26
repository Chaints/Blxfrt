local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local ScriptLoad = {}

_G.AutoFarm = _G.AutoFarm or false
_G.AutoEquipMelee = true
_G.AutoAttack = true
_G.HitboxSize = Vector3.new(15, 15, 15) -- Ukuran hitbox NPC

-- INI DEKLARASI REMOTE LENGKAP
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterAttack = Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = Net:FindFirstChild("RE/RegisterHit") or Net:FindFirstChild("RegisterHit")

-- 1. EXPAND HITBOX NPC
function ScriptLoad.ExpandHitbox(enemy)
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Size = _G.HitboxSize
        hrp.Transparency = 0.7
        hrp.CanCollide = false
    end
end

-- 2. TWEEN MOVEMENT
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

-- 3. AUTO EQUIP MELEE
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

-- 4. AUTO ATTACK DENGAN PAYLOAD SESUAI LOG REMOTESPY
function ScriptLoad.AttackTarget(targetEnemy)
    local character = LocalPlayer.Character
    if not character or not targetEnemy then return end
    
    local enemyTorso = targetEnemy:FindFirstChild("UpperTorso") or targetEnemy:FindFirstChild("HumanoidRootPart")
    
    -- Fire RegisterAttack (0.5, 3)
    if RegisterAttack then
        RegisterAttack:FireServer(0.5, 3)
    end
    
    -- Fire RE/RegisterHit
    if enemyTorso and RegisterHit then
        local hitArgs = {
            [1] = enemyTorso,
            [2] = {},
            [4] = "1270b44e" -- Pastikan hash ini valid atau server validation-nya dimatikan
        }
        RegisterHit:FireServer(unpack(hitArgs))
    end

    -- Fallback Click Manual
    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(0,0))
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end
end

-- 5. LOOP UTAMA
task.spawn(function()
    while task.wait(0.2) do -- Jeda diatur 0.2 detik agar seimbang
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
                            -- Perbesar Hitbox NPC
                            ScriptLoad.ExpandHitbox(enemy)

                            -- Gerak mendekati NPC
                            local targetPos = hrp.CFrame * CFrame.new(0, 5, 0)
                            ScriptLoad.TweenTo(targetPos, 300)

                            -- Eksekusi Serangan
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
