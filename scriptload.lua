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

-- AUTO ATTACK
_G.AutoAttack = (_G.AutoAttack == nil) and true or _G.AutoAttack
_G.AttackTargetMob = (_G.AttackTargetMob == nil) and true or _G.AttackTargetMob
_G.AttackTargetPlayer = (_G.AttackTargetPlayer == nil) and false or _G.AttackTargetPlayer

-- DEKLARASI REMOTE
local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
local REFolder = Net:FindFirstChild("RE")
local RegisterAttack = (REFolder and REFolder:FindFirstChild("RegisterAttack"))
    or Net:FindFirstChild("RegisterAttack")
    or Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = (REFolder and REFolder:FindFirstChild("RegisterHit"))
    or Net:FindFirstChild("RegisterHit")
    or Net:FindFirstChild("RE/RegisterHit")
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
                    -- KUNCI MAX SPEED: Maksimal 200
                    local currentSpeed = _G.TweenSpeed or 200
                    local speed = math.min(currentSpeed, 200)
                    
                    local safeDelta = math.clamp(deltaTime, 0.01, 0.033)
                    local maxStep = math.min(speed * safeDelta, distance)
                    
                    local nextPos = currentPos + (direction.Unit * maxStep)
                    
                    local lookAtPos = Vector3.new(targetPos.X, currentPos.Y, targetPos.Z)
                    hrp.CFrame = CFrame.new(nextPos) * CFrame.lookAt(nextPos, lookAtPos).Rotation
                    
                    hrp.Velocity = Vector3.zero
                    hrp.AssemblyLinearVelocity = Vector3.zero
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

-- 1. LERP MOVEMENT
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

-- 3. FAST ATTACK MULTI-TARGET (Proximity Kill Aura)
function ScriptLoad.FastAttack()
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local myHrp = character.HumanoidRootPart
    local hitTargets = {}
    local radius = _G.AttackRadius or 55

    if _G.AttackTargetMob then
        local enemiesFolder = GetEnemiesFolder()
        if enemiesFolder then
            for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                local hum = enemy:FindFirstChild("Humanoid")
                local targetPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("UpperTorso")

                if hum and hum.Health > 0 and targetPart then
                    local dist = (targetPart.Position - myHrp.Position).Magnitude
                    if dist <= radius then
                        table.insert(hitTargets, {part = targetPart, dist = dist})
                    end
                end
            end
        end
    end

    if _G.AttackTargetPlayer then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                local hum = plr.Character:FindFirstChild("Humanoid")
                local targetPart = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:FindFirstChild("UpperTorso")

                if hum and hum.Health > 0 and targetPart then
                    local dist = (targetPart.Position - myHrp.Position).Magnitude
                    if dist <= radius then
                        table.insert(hitTargets, {part = targetPart, dist = dist})
                    end
                end
            end
        end
    end

    table.sort(hitTargets, function(a, b) return a.dist < b.dist end)

    if #hitTargets > 0 then
        pcall(function()
            if RegisterAttack then RegisterAttack:FireServer(0.01) end
            
            if RegisterHit then
                for _, entry in ipairs(hitTargets) do
                    if entry.part and entry.part.Parent then
                        entry.dist = (entry.part.Position - myHrp.Position).Magnitude
                    else
                        entry.dist = math.huge
                    end
                end
                table.sort(hitTargets, function(a, b) return a.dist < b.dist end)

                local mainTarget = hitTargets[1].part
                local subTargets = {}
                for i = 2, #hitTargets do
                    table.insert(subTargets, hitTargets[i].part)
                end

                RegisterHit:FireServer(mainTarget, subTargets, nil, activeHash or "12796888")

                for i = 2, #hitTargets do
                    RegisterHit:FireServer(hitTargets[i].part, {}, nil, activeHash or "12796888")
                end
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

-- 5. TAKE QUEST (WITH ANTI-STUCK COOLDOWN & RAYCAST)
local lastQuestCheck = 0
local isTakingQuest = false

function ScriptLoad.TakeQuest(questName, levelReq, questCFrame)
    if not CommF or isTakingQuest then return end
    
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = character.HumanoidRootPart

    if questCFrame then
        local distance = (hrp.Position - questCFrame.Position).Magnitude
        if distance > 10 then
            ScriptLoad.TweenTo(questCFrame, _G.TweenSpeed)
            return 
        end
    end

    if tick() - lastQuestCheck < 1.2 then return end
    lastQuestCheck = tick()
    isTakingQuest = true

    ScriptLoad.StopMove()
    if questCFrame then
        hrp.CFrame = questCFrame
        hrp.Velocity = Vector3.zero
    end

    task.spawn(function()
        task.delay(3, function() isTakingQuest = false end)

        pcall(function()
            CommF:InvokeServer("StartQuest", questName, levelReq)
        end)
        
        task.wait(0.15)

        if hrp and questCFrame then
            local candidate = questCFrame * CFrame.new(0, 5, -5)
            local rayParams = RaycastParams.new()
            rayParams.FilterType = Enum.RaycastFilterType.Exclude
            rayParams.FilterDescendantsInstances = {character}

            local rayResult = workspace:Raycast(candidate.Position, Vector3.new(0, -20, 0), rayParams)

            if rayResult then
                hrp.CFrame = candidate
            else
                local smallShift = questCFrame * CFrame.new(0, 0, -3)
                local rayResult2 = workspace:Raycast(smallShift.Position, Vector3.new(0, -20, 0), rayParams)
                if rayResult2 then
                    hrp.CFrame = smallShift
                end
            end
        end

        isTakingQuest = false
    end)
end

-- 6. DATABASE QUEST FULL (SEA 1, SEA 2, SEA 3) - NO BOSS QUESTS
local function GetQuestData()
    local level = LocalPlayer.Data.Level.Value

    -- ==========================================
    -- SEA 1 (LEVEL 1 - 700)
    -- ==========================================
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
    elseif level >= 120 and level < 150 then -- Skip Vice Admiral Boss (diperpanjang 120-150 ke Chief Petty Officer)
        return "Chief Petty Officer", "MarineQuest2", 1, CFrame.new(-5036, 28, 4324)
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
    elseif level >= 650 and level < 700 then
        return "Galley Captain", "FountainQuest", 2, CFrame.new(5259, 38, 4050)

    -- ==========================================
    -- SEA 2 (LEVEL 700 - 1500)
    -- ==========================================
    elseif level >= 700 and level < 725 then
        return "Raider", "Area1Quest", 1, CFrame.new(-425, 73, 1836)
    elseif level >= 725 and level < 775 then
        return "Mercenary", "Area1Quest", 2, CFrame.new(-425, 73, 1836)
    elseif level >= 775 and level < 800 then
        return "Swan Pirate", "Area2Quest", 1, CFrame.new(638, 73, 918)
    elseif level >= 800 and level < 875 then
        return "Factory Staff", "Area2Quest", 2, CFrame.new(638, 73, 918)
    elseif level >= 875 and level < 900 then
        return "Marine Lieutenant", "MarineQuest3", 1, CFrame.new(-2440, 73, -3210)
    elseif level >= 900 and level < 950 then
        return "Marine Captain", "MarineQuest3", 2, CFrame.new(-2440, 73, -3210)
    elseif level >= 950 and level < 1000 then
        return "Zombie", "ZombieQuest", 1, CFrame.new(-5495, 48, -795)
    elseif level >= 1000 and level < 1050 then
        return "Vampire", "ZombieQuest", 2, CFrame.new(-5495, 48, -795)
    elseif level >= 1050 and level < 1100 then
        return "Snow Trooper", "SnowMountainQuest", 1, CFrame.new(609, 401, -5372)
    elseif level >= 1100 and level < 1125 then
        return "Winter Warrior", "SnowMountainQuest", 2, CFrame.new(609, 401, -5372)
    elseif level >= 1125 and level < 1175 then
        return "Lab Subordinate", "IceSideQuest", 1, CFrame.new(-6064, 16, -4903)
    elseif level >= 1175 and level < 1250 then
        return "Horned Warrior", "IceSideQuest", 2, CFrame.new(-6064, 16, -4903)
    elseif level >= 1250 and level < 1275 then
        return "Magma Ninja", "FireSideQuest", 1, CFrame.new(-5430, 16, -5295)
    elseif level >= 1275 and level < 1325 then
        return "Lava Pirate", "FireSideQuest", 2, CFrame.new(-5430, 16, -5295)
    elseif level >= 1325 and level < 1350 then
        return "Ship Deckhand", "ShipQuest1", 1, CFrame.new(1038, 125, 32911)
    elseif level >= 1350 and level < 1425 then
        return "Ship Engineer", "ShipQuest1", 2, CFrame.new(1038, 125, 32911)
    elseif level >= 1425 and level < 1450 then
        return "Water Fighter", "ForgottenQuest", 1, CFrame.new(-3054, 237, -10148)
    elseif level >= 1450 and level < 1500 then
        return "Water Fighter", "ForgottenQuest", 1, CFrame.new(-3054, 237, -10148) -- Skip Tide Keeper Boss

    -- ==========================================
    -- SEA 3 (LEVEL 1500 - 2600)
    -- ==========================================
    elseif level >= 1500 and level < 1525 then
        return "Pirate Millionaire", "PortTownQuest", 1, CFrame.new(-290, 44, 5580)
    elseif level >= 1525 and level < 1575 then
        return "Pistol Billionaire", "PortTownQuest", 2, CFrame.new(-290, 44, 5580)
    elseif level >= 1575 and level < 1600 then
        return "Dragon Crew Warrior", "AmazonQuest", 1, CFrame.new(5833, 102, -23)
    elseif level >= 1600 and level < 1700 then
        return "Dragon Crew Archer", "AmazonQuest", 2, CFrame.new(5833, 102, -23)
    elseif level >= 1700 and level < 1725 then
        return "Female Island Worker", "AmazonQuest2", 1, CFrame.new(5447, 601, 751)
    elseif level >= 1725 and level < 1775 then
        return "Giant Islander", "AmazonQuest2", 2, CFrame.new(5447, 601, 751)
    elseif level >= 1775 and level < 1800 then
        return "Marine Commodore", "MarineTreeIslandQuest", 1, CFrame.new(2180, 29, -6740)
    elseif level >= 1800 and level < 1825 then
        return "Marine Rear Admiral", "MarineTreeIslandQuest", 2, CFrame.new(2180, 29, -6740)
    elseif level >= 1825 and level < 1850 then
        return "Fishman Raider", "DeepForestIslandQuest", 1, CFrame.new(-13274, 332, -7628)
    elseif level >= 1850 and level < 1900 then
        return "Fishman Captain", "DeepForestIslandQuest", 2, CFrame.new(-13274, 332, -7628)
    elseif level >= 1900 and level < 1925 then
        return "Forest Pirate", "DeepForestIsland2Quest", 1, CFrame.new(-13274, 332, -7628)
    elseif level >= 1925 and level < 1975 then
        return "Mythological Pirate", "DeepForestIsland2Quest", 2, CFrame.new(-13274, 332, -7628)
    elseif level >= 1975 and level < 2000 then
        return "Jungle Pirate", "HauntedQuest1", 1, CFrame.new(-9479, 142, 5566)
    elseif level >= 2000 and level < 2025 then
        return "Musketeer Pirate", "HauntedQuest1", 2, CFrame.new(-9479, 142, 5566)
    elseif level >= 2025 and level < 2075 then
        return "Reborn Skeleton", "HauntedQuest2", 1, CFrame.new(-9479, 142, 5566)
    elseif level >= 2075 and level < 2100 then
        return "Living Zombie", "HauntedQuest2", 2, CFrame.new(-9479, 142, 5566)
    elseif level >= 2100 and level < 2125 then
        return "Demonic Soul", "NpcIceCreamQuest", 1, CFrame.new(-860, 66, -10950)
    elseif level >= 2125 and level < 2200 then
        return "Posessed Mummy", "NpcIceCreamQuest", 2, CFrame.new(-860, 66, -10950)
    elseif level >= 2200 and level < 2225 then
        return "Peanut Scout", "PeanutQuest", 1, CFrame.new(-2120, 38, -10190)
    elseif level >= 2225 and level < 2275 then
        return "Peanut President", "PeanutQuest", 2, CFrame.new(-2120, 38, -10190)
    elseif level >= 2275 and level < 2300 then
        return "Ice Cream Chef", "IceCreamQuest", 1, CFrame.new(-2120, 38, -10190)
    elseif level >= 2300 and level < 2325 then
        return "Ice Cream Commander", "IceCreamQuest", 2, CFrame.new(-2120, 38, -10190)
    elseif level >= 2325 and level < 2375 then
        return "Cookie Crafter", "CakeQuest1", 1, CFrame.new(-1900, 38, -11600)
    elseif level >= 2375 and level < 2400 then
        return "Cake Guard", "CakeQuest1", 2, CFrame.new(-1900, 38, -11600)
    elseif level >= 2400 and level < 2425 then
        return "Baking Staff", "CakeQuest2", 1, CFrame.new(-1900, 38, -11600)
    elseif level >= 2425 and level < 2475 then
        return "Head Baker", "CakeQuest2", 2, CFrame.new(-1900, 38, -11600)
    elseif level >= 2475 and level < 2525 then
        return "Isle Outlaw", "TikiQuest1", 1, CFrame.new(-16833, 58, 356)
    elseif level >= 2525 and level <= 2600 then
        return "Island Boy", "TikiQuest1", 2, CFrame.new(-16833, 58, 356)
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
    while task.wait(0.03) do
        if _G.AutoAttack then
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