-- scriptload.lua
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScriptLoad = {}

_G.AutoFarm = _G.AutoFarm or false
_G.AutoEquipMelee = true
_G.AutoAttack = true

-- 1. FUNGSI TWEEN
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

-- 2. FIX AUTO EQUIP MELEE (Cek Nama & Tipe Tool)
function ScriptLoad.EquipMelee()
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not character or not backpack then return end

    -- Kalau sudah pegang Tool apapun di tangan, ga perlu Equip lagi
    if character:FindFirstChildOfClass("Tool") then
        return
    end

    -- Daftar kata kunci nama Melee umum di Blox Fruits
    local meleeKeywords = {"Combat", "Dark Step", "Electro", "Water Kung Fu", "Dragon Claw", "Superhuman", "Death Step", "Sharkman Karate", "Electric Claw", "Dragon Talon", "Godhuman", "Sanguine Art"}

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local isMelee = false
            
            -- Cek dari ToolTip ATAU dari Namanya
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

-- 3. FIX AUTO ATTACK (Gunakan Tool:Activate + Fallback VirtualUser)
function ScriptLoad.Click()
    local character = LocalPlayer.Character
    if character then
        local tool = character:FindFirstChildOfClass("Tool")
        if tool then
            -- Memicu serangan langsung dari Tool yang dipegang
            tool:Activate()
        end
    end
    
    -- Cadangan klik layar via VirtualUser
    pcall(function()
        VirtualUser:Button1Down(Vector2.new(1, 1), workspace.CurrentCamera.CFrame)
        task.wait(0.05)
        VirtualUser:Button1Up(Vector2.new(1, 1), workspace.CurrentCamera.CFrame)
    end)
end

-- 4. LOOP UTAMA
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            pcall(function()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end

                -- Equip Melee jika belum pegang
                if _G.AutoEquipMelee then
                    ScriptLoad.EquipMelee()
                end

                -- Cari Musuh & Serang
                local enemiesFolder = workspace:FindFirstChild("Enemies")
                if enemiesFolder then
                    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
                        local hrp = enemy:FindFirstChild("HumanoidRootPart")
                        local hum = enemy:FindFirstChild("Humanoid")
                        
                        if hrp and hum and hum.Health > 0 then
                            -- Tween tepat di depan/atas musuh
                            local targetPos = hrp.CFrame * CFrame.new(0, 5, 2)
                            ScriptLoad.TweenTo(targetPos, 300)

                            -- Eksekusi Pukul
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
