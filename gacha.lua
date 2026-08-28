local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GachaModule = {}

-- DEKLARASI REMOTE
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local CommF = Remotes and Remotes:WaitForChild("CommF_", 5)
local Xisd = Remotes and Remotes:WaitForChild("xisd", 5)

-- FUNGSI EFEK PARTICLES (OPTIONAL)
function GachaModule.PlayFX()
    if Xisd then
        pcall(function()
            Xisd:InvokeServer("FX", "Particles")
        end)
    end
end

-- FUNGSI CEK DATA BOX
function GachaModule.CheckDLCBox()
    if CommF then
        pcall(function()
            CommF:InvokeServer("Cousin", "DLCBoxData")
        end)
    end
end

-- FUNGSI UTAMA GACHA BUAH (Sekali Panggil Pas Klik)
function GachaModule.BuyRandomFruit()
    if not CommF then 
        warn("[GACHA] Remote CommF_ tidak ditemukan!")
        return 
    end

    -- Mainkan efek partikel dulu biar keren pas gacha
    GachaModule.PlayFX()

    -- Eksekusi Gacha ke Server Blox Fruits
    pcall(function()
        local result = CommF:InvokeServer("Cousin", "Buy")
        print("[GACHA] Response Server:", tostring(result))
    end)
end

return GachaModule
