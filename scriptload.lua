local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScriptLoad = {}

_G.AutoFarm = _G.AutoFarm or false
_G.AutoEquipMelee = true
_G.AutoAttack = true
_G.BringMob = true
_G.HitboxSize = Vector3.new(15, 15, 15)

-- DEKLARASI REMOTE
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterAttack = Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = Net:FindFirstChild("RE/RegisterHit") or Net:FindFirstChild("RegisterHit")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local currentTween = nil

-- 1. EXPAND HITBOX NPC
function ScriptLoad.ExpandHitbox(enemy)
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.Size = _G.HitboxSize
        hrp.Transparency = 0.7
        hrp.CanCollide = false
    end
end

-- 2. TWEEN MOVEMENT (SMOOTH)
function ScriptLoad.TweenTo(targetCFrame, speed)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    
    if distance < 3 then
        if currentTween then currentTween:Cancel() end
        hrp.CFrame = targetCFrame
        return
    end

    local duration = distance / (speed or 300)
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    
    if currentTween then
        currentTween:Cancel()
    end
    
    currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
    return currentTween
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

-- 4. AUTO ATTACK (ASLI KAMU)
function ScriptLoad.AttackTarget(targetEnemy)
    local character = LocalPlayer.Character
    if not character or not targetEnemy then return end
    
    local enemyTorso = targetEnemy:FindFirstChild("UpperTorso") or targetEnemy:FindFirstChild("HumanoidRootPart")
    
    if RegisterAttack then
        RegisterAttack:FireServer(0.5, 3)
    end
    
    if enemyTorso and RegisterHit then
        local hitArgs = {
            [1] = enemyTorso,
            [2] = {},
            [4] = "1270b44e"
        }
        RegisterHit:FireServer(unpack(hitArgs))
    end

    VirtualUser:CaptureController()
    VirtualUser:Button1Down(Vector2.new(0,0))
    local tool = character:FindFirstChildOfClass("Tool")
    if tool then tool:Activate() end
end

-- 5. BRING MOB FIX (NPC TERKUNCI 1 TITIK DI UDARA & ANTI NEMBUS)
function ScriptLoad.BringMob(enemy, exactPointCFrame)
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    local hum = enemy:FindFirstChild("Humanoid")
    
    if hrp and hum and hum.Health > 0 then
        -- Matikan kolisi semua part NPC biar gak ada tabrakan antar NPC
        for _, part in ipairs(enemy:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        hrp.Size = _G.HitboxSize
        hrp.CFrame = exactPointCFrame -- Paksa kumpul pas di 1 koordinat ini
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
    end
end

-- 6. TAKE QUEST
function ScriptLoad.TakeQuest(questName, levelReq, questCFrame)
    if CommF then
        if questCFrame then
            ScriptLoad.TweenTo(questCFrame, 300)
            task.wait(0.5)
        end
        CommF:InvokeServer("StartQuest", questName, levelReq)
    end
end

-- 7. DATABASE QUEST & NPC TARGET (LEVEL 1 - 700)
local function GetQuestData()
    local level = LocalPlayer.Data.Level.Value

    if level >= 1 and level < 10 then
        return "Bandit", "BanditQuest1", 1, CFrame.new(1059, 16, 1549)
    elseif level >= 10 and level < 15 then
        return "Monkey", "JungleQuest", 1, CFrame.new(-1598, 37, 153)
    elseif level >= 15 and level < 30 then
        return "Gorilla", "JungleQuest", 2, CFrame.new(-1598, 37, 153)
    elseif level >= 30 and level < 40 then
        return "Pirate", "BuggyQuest1", 1, CFrame.new(-1140, 4, 3828)
    elseif level >= 40 and level < 60 then
        return "Brute", "BuggyQuest1", 2, CFrame.new(-1140, 4, 3828)
    elseif level >= 60 and level < 75 then
        return "Desert Bandit", "DesertQuest", 1, CFrame.new(896, 6, 4388)
    elseif level >= 75 and level < 90 then
        return "Desert Officer", "DesertQuest", 2, CFrame.new(896, 6, 4388)
    elseif level >= 90 and level < 100 then
        return "Snow Bandit", "SnowQuest", 1, CFrame.new(1386, 87, -1298)
    elseif level >= 100 and level < 120 then
        return "Snowman", "SnowQuest", 2, CFrame.new(1386, 87, -1298)
    elseif level >= 120 and level < 130 then
        return "Chief Petty Officer", "MarineFordQuest2", 1, CFrame.new(-5036, 28, 4324)
    elseif level >= 130 and level < 150 then
        return "Vice Admiral", "MarineFordQuest2", 2, CFrame.new(-5036, 28, 4324)
    elseif level >= 150 and level < 175 then
        return "Sky Bandit", "SkyQuest", 1, CFrame.new(-4841, 717, -2623)
    elseif level >= 175 and level < 190 then
        return "Dark Master", "SkyQuest", 2, CFrame.new(-4841, 717, -2623)
    elseif level >= 190 and level < 210 then
        return "Prisoner", "PrisonerQuest", 1, CFrame.new(530, 1, 474)
    elseif level >= 210 and level < 250 then
        return "Dangerous Prisoner", "PrisonerQuest", 2, CFrame.new(530, 1, 474)
    elseif level >= 250 and level < 275 then
        return "Toga Warrior", "ColosseumQuest", 1, CFrame.new(-1580, 7, -2982)
    elseif level >= 275 and level < 300 then
        return "Gladiator", "ColosseumQuest", 2, CFrame.new(-1580, 7, -2982)
    elseif level >= 300 and level < 325 then
        return "Military Soldier", "MagmaQuest", 1, CFrame.new(-5313, 12, 8515)
    elseif level >= 325 and level < 375 then
        return "Military Spy", "MagmaQuest", 2, CFrame.new(-5313, 12, 8515)
    elseif level >= 375 and level < 400 then
        return "Fishman Warrior", "FishmanQuest", 1, CFrame.new(61122, 18, 1569)
    elseif level >= 400 and level < 450 then
        return "Fishman Commando", "FishmanQuest", 2, CFrame.new(61122, 18, 1569)
    elseif level >= 450 and level < 475 then
        return "God's Guard", "SkyExp1Quest", 1, CFrame.new(-4721, 845, -1954)
    elseif level >= 475 and level < 525 then
        return "Shandora Warrior", "SkyExp1Quest", 2, CFrame.new(-4721, 845, -1954)
    elseif level >= 525 and level < 550 then
        return "Royal Squad", "SkyExp2Quest", 1, CFrame.new(-7906, 5607, -2280)
    elseif level >= 550 and level < 625 then
        return "Royal Soldier", "SkyExp2Quest", 2, CFrame.new(-7906, 5607, -2280)
    elseif level >= 625 and level < 650 then
        return "Galley Pirate", "FountainQuest", 1, CFrame.new(5259, 38, 4050)
    elseif level >= 650 and level <= 700 then
        return "Galley Captain", "FountainQuest", 2, CFrame.new(5259, 38, 4050)
    else
        return "Bandit", "BanditQuest1", 1, CFrame.new(1059, 16, 1549)
    end
end

-- 8. NOCLIP KARAKTER & ANTI GRAVITASI
RunService.Stepped:Connect(function()
    if _G.AutoFarm then
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            if character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end
end)

-- 9. LOOP UTAMA
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then

                if _G.AutoEquipMelee then
                    ScriptLoad.EquipMelee()
                end

                local targetName, questName, questIndex, questCFrame = GetQuestData()
                
                -- Cek GUI Quest
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                local hasQuest = playerGui and playerGui:FindFirstChild("Main") 
                    and playerGui.Main:FindFirstChild("Quest") 
                    and playerGui.Main.Quest.Visible

                if not hasQuest then
                    ScriptLoad.TakeQuest(questName, questIndex, questCFrame)
                    task.wait(0.5)
                else
                    local enemiesFolder = workspace:FindFirstChild("Enemies")
                    if enemiesFolder then
                        local mainTarget = nil

                        -- Cari NPC pertama untuk patokan awal
                        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                            if string.find(enemy.Name, targetName) then
                                local hrp = enemy:FindFirstChild("HumanoidRootPart")
                                local hum = enemy:FindFirstChild("Humanoid")
                                if hrp and hum and hum.Health > 0 then
                                    mainTarget = enemy
                                    break
                                end
                            end
                        end

                        if mainTarget then
                            local mainHrp = mainTarget:FindFirstChild("HumanoidRootPart")
                            
                            -- FIX: TITIK KUMPUL FIX (Karakter di atas, NPC kumpul pas di bawahnya melayang)
                            local farmPosPlayer = mainHrp.CFrame * CFrame.new(0, 10, 0)
                            local bringTargetPos = farmPosPlayer * CFrame.new(0, -4, 0)
                            local myHrp = character.HumanoidRootPart

                            -- Pindahkan Karakter ke Titik Udara Terkunci
                            if (myHrp.Position - farmPosPlayer.Position).Magnitude > 3 then
                                ScriptLoad.TweenTo(farmPosPlayer, 300)
                            else
                                myHrp.CFrame = farmPosPlayer
                            end

                            -- Tarik SEMUA NPC yang cocok tepat ke 1 titik bringTargetPos
                            for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                                if string.find(enemy.Name, targetName) then
                                    local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                                    if eHrp and (eHrp.Position - farmPosPlayer.Position).Magnitude < 350 then
                                        ScriptLoad.ExpandHitbox(enemy)
                                        if _G.BringMob then
                                            ScriptLoad.BringMob(enemy, bringTargetPos)
                                        end
                                    end
                                end
                            end

                            -- Eksekusi Serangan kamu
                            if _G.AutoAttack then
                                ScriptLoad.AttackTarget(mainTarget)
                            end
                        else
                            -- Jika musuh belum spawn, tunggu di spot quest spawn
                            if questCFrame then
                                ScriptLoad.TweenTo(questCFrame, 300)
                            end
                        end
                    end
                end

            end
        end
    end
end)

return ScriptLoad
