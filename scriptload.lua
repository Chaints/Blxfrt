local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScriptLoad = {}

-- CONFIG SETTINGS
_G.AutoFarm = _G.AutoFarm or false
_G.AutoEquipMelee = true
_G.FastAttack = true
_G.AttackPlayers = false -- Ubah ke true jika ingin auto attack Player lain juga
_G.AttackRadius = 50     -- Radius jangkauan Fast Attack (studs)
_G.BringMob = true
_G.AttackRange = 350     -- Radius untuk narik NPC (Bring Mob)

-- DEKLARASI REMOTE
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterAttack = Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = Net:FindFirstChild("RE/RegisterHit") or Net:FindFirstChild("RegisterHit")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local currentTween = nil

-- 1. EXPAND HITBOX (Hanya matikan CanCollide agar physics tidak benturan/njot-njotan)
function ScriptLoad.ExpandHitbox(enemy)
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CanCollide = false
    end
end

-- 2. TWEEN MOVEMENT (SMOOTH MOVEMENT)
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

-- 4. FAST ATTACK SYSTEM (AUTOMATIS DEKETIN NPC / PLAYER LANGSUNG KENA DAMAGE KENCANG)
function ScriptLoad.FastAttack()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local myHrp = character.HumanoidRootPart
    local hitTargets = {}

    -- Scan NPC di sekitar
    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if enemiesFolder then
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            local hum = enemy:FindFirstChild("Humanoid")
            local torso = enemy:FindFirstChild("UpperTorso") or enemy:FindFirstChild("HumanoidRootPart")
            
            if hum and hum.Health > 0 and torso then
                local distance = (torso.Position - myHrp.Position).Magnitude
                if distance <= _G.AttackRadius then
                    table.insert(hitTargets, torso)
                end
            end
        end
    end

    -- Scan Player lain di sekitar (Jika _G.AttackPlayers = true)
    if _G.AttackPlayers then
        for _, otherPlayer in ipairs(Players:GetPlayers()) do
            if otherPlayer ~= LocalPlayer and otherPlayer.Character then
                local hum = otherPlayer.Character:FindFirstChild("Humanoid")
                local torso = otherPlayer.Character:FindFirstChild("UpperTorso") or otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                
                if hum and hum.Health > 0 and torso then
                    local distance = (torso.Position - myHrp.Position).Magnitude
                    if distance <= _G.AttackRadius then
                        table.insert(hitTargets, torso)
                    end
                end
            end
        end
    end

    -- Eksekusi Hit Sesuai Remote Payload Kamu
    if #hitTargets > 0 then
        if RegisterAttack then
            RegisterAttack:FireServer(0.5, 3)
        end
        
        if RegisterHit then
            for _, targetTorso in ipairs(hitTargets) do
                local hitArgs = {
                    [1] = targetTorso,
                    [2] = {},
                    [4] = "1270b44e"
                }
                RegisterHit:FireServer(unpack(hitArgs))
            end
        end
    end
end

-- 5. BRING MOB FIX (NPC KUMPUL RAPI DI TANAH, ANTI TERBANG)
function ScriptLoad.BringMob(enemy, groundCFrame)
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    local hum = enemy:FindFirstChild("Humanoid")
    
    if hrp and hum and hum.Health > 0 then
        for _, part in ipairs(enemy:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end

        hrp.CFrame = groundCFrame
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

-- 8. NOCLIP KARAKTER & ANTI-GRAVITY
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

-- 9. LOOP UTAMA FAST ATTACK (KENCANG)
task.spawn(function()
    while true do
        task.wait(0.01) -- Interval serangan mikro (Sangat cepat)
        if _G.FastAttack then
            pcall(function()
                ScriptLoad.FastAttack()
            end)
        end
    end
end)

-- 10. LOOP UTAMA AUTO FARM & BRING MOB
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then

                if _G.AutoEquipMelee then
                    ScriptLoad.EquipMelee()
                end

                local targetName, questName, questIndex, questCFrame = GetQuestData()
                
                -- Pengecekan status Quest GUI
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

                        -- Cari NPC pertama untuk titik acuan awal
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
                            
                            -- Titik kumpul NPC di permukaan tanah
                            local groundCFrame = mainHrp.CFrame
                            -- Karakter melayang tepat 9 stud di atas titik kumpul NPC
                            local farmPosPlayer = groundCFrame * CFrame.new(0, 9, 0)
                            local myHrp = character.HumanoidRootPart

                            -- Pindahkan Karakter ke posisi melayang
                            if (myHrp.Position - farmPosPlayer.Position).Magnitude > 3 then
                                ScriptLoad.TweenTo(farmPosPlayer, 300)
                            else
                                myHrp.CFrame = farmPosPlayer
                            end

                            -- Bring SEMUA NPC sejenis tepat ke groundCFrame (di permukaan tanah)
                            for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                                if string.find(enemy.Name, targetName) then
                                    local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                                    if eHrp and (eHrp.Position - groundCFrame.Position).Magnitude <= _G.AttackRange then
                                        ScriptLoad.ExpandHitbox(enemy)
                                        if _G.BringMob then
                                            ScriptLoad.BringMob(enemy, groundCFrame)
                                        end
                                    end
                                end
                            end
                        else
                            -- Tunggu di tempat spawn quest jika NPC belum muncul
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
