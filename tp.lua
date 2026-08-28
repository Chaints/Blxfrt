local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local TPModule = {}

-- DATABASE KOORDINAT PULAU LENGKAP (SEA 1, 2, 3)
TPModule.Islands = {
    ["Sea 1"] = {
        ["Starter Island"]    = CFrame.new(1059, 16, 1549),
        ["Jungle"]            = CFrame.new(-1598, 37, 153),
        ["Pirate Village"]    = CFrame.new(-1140, 4, 3828),
        ["Desert"]            = CFrame.new(896, 6, 4388),
        ["Frozen Village"]    = CFrame.new(1386, 87, -1298),
        ["MarineFord"]        = CFrame.new(-5036, 28, 4324),
        ["Skypiea"]           = CFrame.new(-4841, 717, -2623),
        ["Prison"]            = CFrame.new(530, 1, 474),
        ["Colosseum"]         = CFrame.new(-1580, 7, -2982),
        ["Magma Village"]     = CFrame.new(-5313, 12, 8515),
        ["Underwater Island"] = CFrame.new(61122, 18, 1569),
        ["Upper Skylands"]    = CFrame.new(-7906, 5607, -2280),
        ["Fountain City"]     = CFrame.new(5259, 38, 4050)
    },
    ["Sea 2"] = {
        ["Cafe"]              = CFrame.new(-380, 73, 298),
        ["Kingdom of Rose"]   = CFrame.new(-437, 73, 1836),
        ["Uship / Graveyard"] = CFrame.new(-2450, 73, -3210),
        ["Green Zone"]        = CFrame.new(-2385, 73, -2945),
        ["Dark Arena"]        = CFrame.new(3800, 20, -3500),
        ["Snow Mountain"]     = CFrame.new(620, 400, -5370),
        ["Hot and Cold"]      = CFrame.new(-6000, 15, -5000),
        ["Cursed Ship"]       = CFrame.new(920, 125, 32800),
        ["Ice Castle"]        = CFrame.new(5600, 28, -6400),
        ["Forgotten Island"]  = CFrame.new(-3050, 240, -10150)
    },
    ["Sea 3"] = {
        ["Mansion"]           = CFrame.new(-12463, 374, -7523),
        ["Port Town"]         = CFrame.new(-290, 44, 5380),
        ["Great Tree"]        = CFrame.new(2290, 25, -6490),
        ["Castle On The Sea"] = CFrame.new(-5058, 314, -3155),
        ["Hydra Island"]      = CFrame.new(5670, 1039, -340),
        ["Floating Turtle"]   = CFrame.new(-13274, 332, -7628),
        ["Haunted Castle"]    = CFrame.new(-9517, 142, 5528),
        ["Sea of Treats"]     = CFrame.new(-2082, 38, -10190),
        ["Tiki Outpost"]      = CFrame.new(-16833, 58, 356)
    }
}

-- STATE TELEPORT
local isTeleporting = false
local targetTeleportCFrame = nil

-- FUNGSI EKS EKUSI TELEPORT TO CFRAME (LOKAL VEKTOR LERP)
function TPModule.TeleportTo(targetCFrame)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = character.HumanoidRootPart
    local distance = (hrp.Position - targetCFrame.Position).Magnitude
    
    if distance <= 3 then
        isTeleporting = false
        targetTeleportCFrame = nil
        hrp.CFrame = targetCFrame
        return
    end

    targetTeleportCFrame = targetCFrame
    isTeleporting = true
end

function TPModule.StopTeleport()
    isTeleporting = false
    targetTeleportCFrame = nil
end

-- ENGINE FLY TELEPORT (Per Frame di Stepped)
RunService.Stepped:Connect(function(deltaTime)
    if not isTeleporting or not targetTeleportCFrame then return end

    local character = LocalPlayer.Character
    if not character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")

    if hrp then
        -- Anti-Fall Auto Velocity Anchor
        if not hrp:FindFirstChild("AntiFall") then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "AntiFall"
            bv.MaxForce = Vector3.new(100000, 100000, 100000)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
        end

        local currentPos = hrp.Position
        local targetPos = targetTeleportCFrame.Position
        local direction = (targetPos - currentPos)
        local distance = direction.Magnitude

        if distance > 3 then
            -- Pengunci Kecepatan (Locked MAX 200)
            local speed = math.min(_G.TweenSpeed or 200, 200)
            local safeDelta = math.clamp(deltaTime, 0.01, 0.033)
            local maxStep = math.min(speed * safeDelta, distance)

            local nextPos = currentPos + (direction.Unit * maxStep)

            -- Tetap tegak lurus (tidak miring)
            local lookAtPos = Vector3.new(targetPos.X, currentPos.Y, targetPos.Z)
            hrp.CFrame = CFrame.new(nextPos) * CFrame.lookAt(nextPos, lookAtPos).Rotation

            -- Reset gaya gesek / velocity fisika
            hrp.Velocity = Vector3.zero
            hrp.AssemblyLinearVelocity = Vector3.zero
        else
            hrp.CFrame = targetTeleportCFrame
            isTeleporting = false
            targetTeleportCFrame = nil
            if hrp:FindFirstChild("AntiFall") then
                hrp.AntiFall:Destroy()
            end
        end

        -- Noclip Otomatis Selama Terbang
        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

-- FUNGSI BYPASS BEDA SEA VIA COMMF REMOTE
function TPModule.TeleportToSea(seaName)
    local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    if not CommF then return end

    if seaName == "Sea 1" then
        CommF:InvokeServer("TravelMain")
    elseif seaName == "Sea 2" then
        CommF:InvokeServer("TravelDressrosa")
    elseif seaName == "Sea 3" then
        CommF:InvokeServer("TravelZou")
    end
end

-- FUNGSI UTAMA BY NAMA PULAU
function TPModule.TeleportToIsland(seaName, islandName)
    local seaData = TPModule.Islands[seaName]
    if seaData and seaData[islandName] then
        TPModule.TeleportTo(seaData[islandName])
    else
        warn("[TP.LUA] Lokasi pulau tidak ditemukan:", islandName, "di", seaName)
    end
end

return TPModule
