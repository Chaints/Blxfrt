if game:GetService("CoreGui"):FindFirstChild("ZxDHub") then
    game:GetService("CoreGui").ZxDHub:Destroy()
end

local UI = {}

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZxDHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Main Frame (Window Utama)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 260)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(40, 40, 55)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Top Header / Title Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZxD Hub <font color=\"#00FF88\">v1.0</font> | Blox Fruits"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- Close Button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -26, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(230, 80, 80)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Sidebar (Left Tab Menu Area)
local Sidebar = Instance.new("ScrollingFrame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 110, 1, -40)
Sidebar.Position = UDim2.new(0, 8, 0, 34)
Sidebar.BackgroundTransparency = 1
Sidebar.ScrollBarThickness = 0
Sidebar.CanvasSize = UDim2.new(0, 0, 0, 0)
Sidebar.Parent = MainFrame

local SidebarList = Instance.new("UIListLayout")
SidebarList.Parent = Sidebar
SidebarList.Padding = UDim.new(0, 4)

SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarList.AbsoluteContentSize.Y)
end)

-- Tab Container (Right Side Content)
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -132, 1, -40)
ContentArea.Position = UDim2.new(0, 124, 0, 34)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

---------------------------------------------------------
-- TAB & BUILDER SYSTEM
---------------------------------------------------------

local Tabs = {}
local FirstTab = true

function UI:CreateTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(1, 0, 0, 26)
    TabButton.BackgroundColor3 = FirstTab and Color3.fromRGB(0, 255, 136) or Color3.fromRGB(22, 22, 28)
    TabButton.Text = tabName
    TabButton.TextColor3 = FirstTab and Color3.fromRGB(15, 15, 20) or Color3.fromRGB(180, 180, 190)
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.TextSize = 11
    TabButton.Parent = Sidebar

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 5)
    TabCorner.Parent = TabButton

    -- Container Khusus Tab Ini
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = tabName .. "Container"
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.ScrollBarThickness = 2
    TabContainer.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 136)
    TabContainer.Visible = FirstTab
    TabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabContainer.Parent = ContentArea

    local UIList = Instance.new("UIListLayout")
    UIList.Parent = TabContainer
    UIList.Padding = UDim.new(0, 5)

    UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 8)
    end)

    -- Simpan elemen Tab
    local TabObj = {
        Button = TabButton,
        Container = TabContainer
    }

    -- Pindah Tab Event
    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Container.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
            t.Button.TextColor3 = Color3.fromRGB(180, 180, 190)
        end
        TabContainer.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
        TabButton.TextColor3 = Color3.fromRGB(15, 15, 20)
    end)

    table.insert(Tabs, TabObj)
    FirstTab = false

    ---------------------------------------------------------
    -- ELEMENT CREATORS INSIDE TAB
    ---------------------------------------------------------
    local Elements = {}

    -- Section Title / Header Kecil
    function Elements:AddSection(text)
        local Sec = Instance.new("TextLabel")
        Sec.Size = UDim2.new(1, -4, 0, 18)
        Sec.BackgroundTransparency = 1
        Sec.Text = "-- " .. string.upper(text) .. " --"
        Sec.TextColor3 = Color3.fromRGB(0, 255, 136)
        Sec.Font = Enum.Font.GothamBold
        Sec.TextSize = 10
        Sec.TextXAlignment = Enum.TextXAlignment.Left
        Sec.Parent = TabContainer
    end

    -- Label Info / Placeholder
    function Elements:AddPlaceholder(text)
        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -4, 0, 20)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Color3.fromRGB(130, 130, 150)
        Label.Font = Enum.Font.Gotham
        Label.TextSize = 11
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = TabContainer
    end

    -- Toggle Button
    function Elements:CreateToggle(text, defaultState, callback)
        local Tgl = Instance.new("TextButton")
        Tgl.Size = UDim2.new(1, -6, 0, 26)
        Tgl.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        Tgl.Text = "  " .. text
        Tgl.TextColor3 = Color3.fromRGB(220, 220, 220)
        Tgl.Font = Enum.Font.GothamMedium
        Tgl.TextSize = 11
        Tgl.TextXAlignment = Enum.TextXAlignment.Left
        Tgl.Parent = TabContainer

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Tgl

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 12, 0, 12)
        Indicator.Position = UDim2.new(1, -18, 0.5, -6)
        Indicator.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 136) or Color3.fromRGB(45, 45, 55)
        Indicator.Parent = Tgl

        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(0, 3)
        IndCorner.Parent = Indicator

        local enabled = defaultState or false
        Tgl.MouseButton1Click:Connect(function()
            enabled = not enabled
            Indicator.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 136) or Color3.fromRGB(45, 45, 55)
            pcall(callback, enabled)
        end)
    end

    -- Button Normal
    function Elements:CreateButton(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -6, 0, 26)
        Btn.BackgroundColor3 = Color3.fromRGB(24, 24, 32)
        Btn.Text = text
        Btn.TextColor3 = Color3.fromRGB(220, 220, 220)
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 11
        Btn.AutoButtonColor = true
        Btn.Parent = TabContainer

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 5)
        Corner.Parent = Btn

        Btn.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end

    return Elements
end

-- Backward Compatibility untuk main.lua lama kamu
UI.Container = ContentArea

return UI
