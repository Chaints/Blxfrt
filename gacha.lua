local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GachaModule = {}

-- Safe Remote Retrieval
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 10)
local CommF = Remotes and Remotes:WaitForChild("CommF_", 5)
local Xisd = Remotes and Remotes:WaitForChild("xisd", 5)

function GachaModule.PlayFX()
    if Xisd then
        pcall(function()
            Xisd:InvokeServer("FX", "Particles")
        end)
    end
end

function GachaModule.BuyRandomFruit()
    if not CommF then 
        warn("[GACHA] Remote CommF_ tidak ditemukan / belum tersambung!")
        return nil
    end

    -- Mainkan efek partikel
    GachaModule.PlayFX()

    -- Eksekusi Remote Gacha
    local success, result = pcall(function()
        return CommF:InvokeServer("Cousin", "Buy")
    end)

    if success then
        if result == nil then
            print("[GACHA] Gagal: Kemungkinan Uang/Beli kurang atau sedang Cooldown 2 jam!")
        else
            print("[GACHA] Sukses! Mendapatkan/Respon:", tostring(result))
        end
        return result
    else
        warn("[GACHA] Error saat memanggil Remote Cousin Buy:", tostring(result))
        return nil
    end
end

return GachaModule
