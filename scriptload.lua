local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScriptLoad = {}

-- CONFIG SETTINGS
_G.AutoFarm = _G.AutoFarm or false
_G.AutoEquipMelee = true
_G.FastAttack = true
_G.AttackRadius = 55
_G.BringMob = _G.BringMob or false
_G.BringRange = _G.BringRange or 55
_G.TweenSpeed = _G.TweenSpeed or 300
_G.FarmMethod = _G.FarmMethod or "Quest"

-- DEKLARASI REMOTE
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local RegisterAttack = Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = Net:FindFirstChild("RE/RegisterHit") or Net:FindFirstChild("RegisterHit")
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

local activeHash = "12796888"

-- STATE MOVEMENT LERP
local targetMoveCFrame = nil
local isLerpMoving = false

-- ENGINE FLY MOVEMENT (Murni Vektor, Super Smooth & Anti-Lag)
RunService.Stepped:Connect(function(deltaTime)
    local character = LocalPlayer.Character
    if not character then return end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    
    if _G.AutoFarm then
        if hrp then
            -- Anti-Fall BodyVelocity
            if not hrp:FindFirstChild("AntiFall") then
                local bv = Instance.new("BodyVelocity")
                bv.Name = "AntiFall"
                bv.MaxForce = Vector3.new(100000, 100000, 100000)
                bv.Velocity = Vector3.zero
                bv.Parent = hrp
            end

            -- Engine Terbang Halus
            if isLerpMoving and targetMoveCFrame then
                local currentPos = hrp.Position
                local targetPos = targetMoveCFrame.Position
                local direction = (targetPos - currentPos)
                local distance = direction.Magnitude
                
                if distance > 3 then
                    local speed = _G.TweenSpeed or 300
                    -- Mengunci delta time agar pergerakan tidak 'melompat' saat FPS drop
                    local safeDelta = math.clamp(deltaTime, 0.01, 0.033)
                    local maxStep = math.min(speed * safeDelta, distance)
                    
                    -- Geser posisi sejauh maxStep ke arah tujuan
                    local nextPos = currentPos + (direction.Unit * maxStep)
                    
                    -- Update CFrame + Rotasi Menghadap ke Tujuan
                    hrp.CFrame = CFrame.new(nextPos, targetPos)
                    
                    -- Amankan Velocity biar tidak kena Anti-Cheat / Jatuh
                    hrp.Velocity = Vector3.zero
                else
                    hrp.CFrame = targetMoveCFrame
                    isLerpMoving = false
                end
            end
        end

        -- Noclip Karakter
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    else
        isLerpMoving = false
        targetMoveCFrame = nil
        if hrp and hrp:FindFirstChild("AntiFall") then
            hrp.AntiFall:Destroy()
        end
    end
end)

-- CACHE ENEMIES FOLDER
local _enemiesFolderCache = nil
local function GetEnemiesFolder()
    if not _enemiesFolderCache or not _enemiesFolderCache.Parent then
        _enemiesFolderCache = workspace:FindFirstChild("Enemies")
    end
    return _enemiesFolderCache
end

-- HOOK HASH OTOMATIS
if hookmetamethod then
    local oldNamecall
    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        if method == "FireServer" and self.Name == "RegisterHit" then
            if args[4] and type(args[4]) == "string" then
                activeHash = args[4]
            end
        end
        return oldNamecall(self, ...)
    end)
end

-- 1. LERP MOVEMENT (PENGGANTI TWEEN)
function ScriptLoad.TweenTo(targetCFrame, speed)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    local hrp = character.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude

    if distance <= 3 then
        isLerpMoving = false
        targetMoveCFrame = nil
        hrp.CFrame = targetCFrame
        return
    end

    -- Update target lokasi bergerak
    targetMoveCFrame = targetCFrame
    isLerpMoving = true
end

function ScriptLoad.StopMove()
    isLerpMoving = false
    targetMoveCFrame = nil
end

-- 2. AUTO EQUIP MELEE
function ScriptLoad.EquipMelee()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not character or not backpack or character:FindFirstChildOfClass("Tool") then return end

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

-- 3. FAST ATTACK MULTI-TARGET
function ScriptLoad.FastAttack()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local myHrp = character.HumanoidRootPart
    local hitTargets = {}
    local enemiesFolder = GetEnemiesFolder()

    if enemiesFolder then
        for _, enemy in ipairs(enemiesFolder:GetChildren()) do
            local hum = enemy:FindFirstChild("Humanoid")
            local targetPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("UpperTorso")
            
            if hum and hum.Health > 0 and targetPart then
                if (targetPart.Position - myHrp.Position).Magnitude <= (_G.AttackRadius or 55) then
                    table.insert(hitTargets, targetPart)
                end
            end
        end
    end

    if #hitTargets > 0 then
        pcall(function()
            if RegisterAttack then RegisterAttack:FireServer(0.5) end
            if RegisterHit then
                local mainTarget = hitTargets[1]
                local subTargets = {}
                for i = 2, #hitTargets do
                    table.insert(subTargets, hitTargets[i])
                end

                RegisterHit:FireServer(mainTarget, subTargets, nil, activeHash or "12796888")
            end
        end)
    end
end

-- 4. BRING MOB ULTRA LIGHT
function ScriptLoad.BringMob(enemy, groundCFrame)
    local hrp = enemy:FindFirstChild("HumanoidRootPart")
    local hum = enemy:FindFirstChild("Humanoid")
    
    if hrp and hum and hum.Health > 0 then
        hrp.CanCollide = false
        hrp.CFrame = groundCFrame
        hrp.Velocity = Vector3.zero
    end
end

-- 5. TAKE QUEST (WITH ANTI-STUCK COOLDOWN)
local lastQuestCheck = 0
function ScriptLoad.TakeQuest(questName, levelReq, questCFrame)
    if not CommF then return end
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    
    if questCFrame then
        local distance = (hrp.Position - questCFrame.Position).Magnitude
        if distance > 12 then
            ScriptLoad.TweenTo(questCFrame, _G.TweenSpeed)
            return 
        end
    end
    
    if tick() - lastQuestCheck < 1.5 then return end
    lastQuestCheck = tick()

    ScriptLoad.StopMove()
    if questCFrame then
        hrp.CFrame = questCFrame
    end
    
    task.spawn(function()
        pcall(function()
            local args = {
                "StartQuest",
                questName,
                levelReq
            }
            CommF:InvokeServer(unpack(args))
        end)
        
        task.wait(0.3)
        if questCFrame and hrp then
            hrp.CFrame = questCFrame * CFrame.new(0, 0, -10)
        end
    end)
end

-- 6. DATABASE QUEST (LEVEL 1 - 700)
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

-- 6.5 CARI MOB TERDEKAT
local function GetNearestEnemy(myHrp)
    local enemiesFolder = GetEnemiesFolder()
    if not enemiesFolder then return nil end

    local nearest = nil
    local nearestDist = math.huge

    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        local hrp = enemy:FindFirstChild("HumanoidRootPart")
        local hum = enemy:FindFirstChild("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local dist = (hrp.Position - myHrp.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = enemy
            end
        end
    end

    return nearest
end

-- 7. LOOP ATTACK
task.spawn(function()
    while task.wait(0.15) do
        if _G.FastAttack and _G.AutoFarm then
            pcall(ScriptLoad.FastAttack)
        end
    end
end)

-- 8. LOOP UTAMA FARMING
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoFarm then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then

                if _G.AutoEquipMelee then
                    ScriptLoad.EquipMelee()
                end

                local myHrp = character.HumanoidRootPart
                local method = _G.FarmMethod or "Quest"

                if method == "Nearest" then
                    local mainTarget = GetNearestEnemy(myHrp)

                    if mainTarget then
                        local mainHrp = mainTarget:FindFirstChild("HumanoidRootPart")
                        local groundCFrame = mainHrp.CFrame
                        local farmPosPlayer = groundCFrame * CFrame.new(0, 9, 0)

                        if (myHrp.Position - farmPosPlayer.Position).Magnitude > 3 then
                            ScriptLoad.TweenTo(farmPosPlayer, _G.TweenSpeed)
                        else
                            ScriptLoad.StopMove()
                            myHrp.CFrame = farmPosPlayer
                        end

                        if _G.BringMob then
                            local enemiesFolder = GetEnemiesFolder()
                            if enemiesFolder then
                                for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                                    local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                                    local eHum = enemy:FindFirstChild("Humanoid")
                                    if eHrp and eHum and eHum.Health > 0 and (eHrp.Position - groundCFrame.Position).Magnitude <= _G.BringRange then
                                        ScriptLoad.BringMob(enemy, groundCFrame)
                                    end
                                end
                            end
                        end
                    end

                else
                    local targetName, questName, questIndex, questCFrame = GetQuestData()
                    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                    local hasQuest = playerGui and playerGui:FindFirstChild("Main")
                        and playerGui.Main:FindFirstChild("Quest")
                        and playerGui.Main.Quest.Visible

                    if method == "Quest" and not hasQuest then
                        ScriptLoad.TakeQuest(questName, questIndex, questCFrame)
                    else
                        local enemiesFolder = GetEnemiesFolder()
                        if enemiesFolder then
                            local mainTarget = nil

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
                                local groundCFrame = mainHrp.CFrame
                                local farmPosPlayer = groundCFrame * CFrame.new(0, 9, 0)

                                if (myHrp.Position - farmPosPlayer.Position).Magnitude > 3 then
                                    ScriptLoad.TweenTo(farmPosPlayer, _G.TweenSpeed)
                                else
                                    ScriptLoad.StopMove()
                                    myHrp.CFrame = farmPosPlayer
                                end

                                if _G.BringMob then
                                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                                        if string.find(enemy.Name, targetName) then
                                            local eHrp = enemy:FindFirstChild("HumanoidRootPart")
                                            if eHrp and (eHrp.Position - groundCFrame.Position).Magnitude <= _G.BringRange then
                                                ScriptLoad.BringMob(enemy, groundCFrame)
                                            end
                                        end
                                    end
                                end
                            else
                                if questCFrame then
                                    ScriptLoad.TweenTo(questCFrame, _G.TweenSpeed)
                                end
                            end
                        end
                    end
                end

            end
        else
            ScriptLoad.StopMove()
        end
    end
end)

return ScriptLoad
