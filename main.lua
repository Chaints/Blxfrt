-- Proteksi Hapus UI Lama (Biar gak tumpuk-tumpuk pas di-execute ulang)
if game:GetService("CoreGui"):FindFirstChild("DakzzHubLocal") then
    game:GetService("CoreGui").DakzzHubLocal:Destroy()
end

-- ScreenGui Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DakzzHubLocal"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Frame Utama (Window)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 240)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true -- Bisa digeser pake jari/mouse
MainFrame.Parent = ScreenGui

-- Corner Visual Frame Utama
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title Bar (Judul UI)
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "  DakzzHub | Blox Fruits (Local)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 14
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

-- Container untuk Tombol-Tombol
local Container = Instance.new("Frame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -20, 1, -50)
Container.Position = UDim2.new(0, 10, 0, 42)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

-- Fitur 1: Toggle Auto Farm (Custom UI Local)
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleAutoFarm"
ToggleButton.Size = UDim2.new(1, 0, 0, 35)
ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
ToggleButton.Text = "Auto Farm: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 75, 75)
ToggleButton.TextSize = 13
ToggleButton.Font = Enum.Font.SourceSansSemibold
ToggleButton.Parent = Container

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = ToggleButton

_G.AutoFarm = false
ToggleButton.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    if _G.AutoFarm then
        ToggleButton.Text = "Auto Farm: ON"
        ToggleButton.TextColor3 = Color3.fromRGB(75, 255, 75)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(35, 60, 35)
    else
        ToggleButton.Text = "Auto Farm: OFF"
        ToggleButton.TextColor3 = Color3.fromRGB(255, 75, 75)
        ToggleButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    end
end)

-- Fitur 2: Tombol Fly / Fast Walk (Custom UI Local)
local SpeedButton = Instance.new("TextButton")
SpeedButton.Name = "SpeedButton"
SpeedButton.Size = UDim2.new(1, 0, 0, 35)
SpeedButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
SpeedButton.Text = "Set WalkSpeed (100)"
SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedButton.TextSize = 13
SpeedButton.Font = Enum.Font.SourceSansSemibold
SpeedButton.Parent = Container

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 6)
SpeedCorner.Parent = SpeedButton

SpeedButton.MouseButton1Click:Connect(function()
    local player = game.Players.LocalPlayer
    if player and player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 100
    end
end)
