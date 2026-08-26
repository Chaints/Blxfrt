if game:GetService("CoreGui"):FindFirstChild("ZxDHubLocal") then
    game:GetService("CoreGui").ZxDHubLocal:Destroy()
end

local UI = {}

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZxDHubLocal"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame (Design Dark & Ringan)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 250)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 55)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Header Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 35)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZxD Hub | Blox Fruits"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(220, 70, 70)
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Container Utamanya ScrollingFrame (Ramah HP Kentang)
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Size = UDim2.new(1, -16, 1, -45)
Container.Position = UDim2.new(0, 8, 0, 38)
Container.BackgroundTransparency = 1
Container.ScrollBarThickness = 2
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 136)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 6)
end)

---------------------------------------------------------
-- METODE / FUNKSI UNTUK DIPANGGIL DI MAIN.LUA
---------------------------------------------------------

-- 1. Tambah Placeholder / Label Info
function UI:AddPlaceholder(text)
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 0, 18)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(130, 130, 150)
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
    return Label
end

-- 2. Tambah Button Normal
function UI:CreateButton(text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -4, 0, 28)
    Btn.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.AutoButtonColor = true
    Btn.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
    return Btn
end

-- 3. Tambah Toggle
function UI:CreateToggle(text, callback)
    local Tgl = Instance.new("TextButton")
    Tgl.Size = UDim2.new(1, -4, 0, 28)
    Tgl.BackgroundColor3 = Color3.fromRGB(28, 28, 36)
    Tgl.Text = "  " .. text
    Tgl.TextColor3 = Color3.fromRGB(220, 220, 220)
    Tgl.Font = Enum.Font.GothamMedium
    Tgl.TextSize = 12
    Tgl.TextXAlignment = Enum.TextXAlignment.Left
    Tgl.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 5)
    Corner.Parent = Tgl

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 14, 0, 14)
    Indicator.Position = UDim2.new(1, -20, 0.5, -7)
    Indicator.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    Indicator.Parent = Tgl

    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(0, 3)
    IndCorner.Parent = Indicator

    local enabled = false
    Tgl.MouseButton1Click:Connect(function()
        enabled = not enabled
        Indicator.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 136) or Color3.fromRGB(45, 45, 55)
        pcall(callback, enabled)
    end)
    return Tgl
end

-- Return kompatibilitas persis versi awal kamu
UI.Container = Container
return UI
