if game:GetService("CoreGui"):FindFirstChild("ZxDHub") then
    game:GetService("CoreGui").ZxDHub:Destroy()
end

local UI = {}

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZxDHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Mobile Open/Close Button (Buat HP biar gampang Hide/Show)
local MobileBtn = Instance.new("TextButton")
MobileBtn.Name = "MobileToggle"
MobileBtn.Size = UDim2.new(0, 45, 0, 45)
MobileBtn.Position = UDim2.new(0.1, 0, 0.2, 0)
MobileBtn.BackgroundColor3 = Color3.fromRGB(20, 22, 30)
MobileBtn.Text = "ZxD"
MobileBtn.TextColor3 = Color3.fromRGB(0, 255, 136)
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.TextSize = 14
MobileBtn.Active = true
MobileBtn.Draggable = true
MobileBtn.Parent = ScreenGui

local MobCorner = Instance.new("UICorner")
MobCorner.CornerRadius = UDim.new(1, 0)
MobCorner.Parent = MobileBtn

local MobStroke = Instance.new("UIStroke")
MobStroke.Color = Color3.fromRGB(0, 255, 136)
MobStroke.Thickness = 1.5
MobStroke.Parent = MobileBtn

-- Main Frame Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 270)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 17, 22)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

MobileBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(35, 40, 50)
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- Header Bar
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
Title.Text = "<b>ZxD Hub</b> <font color=\"#00FF88\">v1.2</font>"
Title.RichText = true
Title.TextColor3 = Color3.fromRGB(240, 240, 240)
Title.TextSize = 13
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -26, 0.5, -11)
CloseBtn.BackgroundColor3 = Color3.fromRGB(25, 28, 38)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(230, 80, 80)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Glowing Accent Line under Header
local AccentLine = Instance.new("Frame")
AccentLine.Size = UDim2.new(1, -16, 0, 2)
AccentLine.Position = UDim2.new(0, 8, 0, 32)
AccentLine.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = MainFrame

-- Top Tab Bar
local TopTabNav = Instance.new("ScrollingFrame")
TopTabNav.Name = "TopTabNav"
TopTabNav.Size = UDim2.new(1, -16, 0, 26)
TopTabNav.Position = UDim2.new(0, 8, 0, 38)
TopTabNav.BackgroundTransparency = 1
TopTabNav.ScrollBarThickness = 0
TopTabNav.CanvasSize = UDim2.new(0, 0, 0, 0)
TopTabNav.Parent = MainFrame

local TopTabLayout = Instance.new("UIListLayout")
TopTabLayout.Parent = TopTabNav
TopTabLayout.FillDirection = Enum.FillDirection.Horizontal
TopTabLayout.Padding = UDim.new(0, 5)

TopTabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TopTabNav.CanvasSize = UDim2.new(0, TopTabLayout.AbsoluteContentSize.X, 0, 0)
end)

-- Content Container
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -16, 1, -72)
ContentArea.Position = UDim2.new(0, 8, 0, 68)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

---------------------------------------------------------
-- TAB SYSTEM & ADVANCED COMPONENTS
---------------------------------------------------------

local Tabs = {}
local FirstTab = true

function UI:CreateTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 80, 1, 0)
    TabButton.BackgroundColor3 = FirstTab and Color3.fromRGB(0, 255, 136) or Color3.fromRGB(22, 25, 32)
    TabButton.Text = tabName
    TabButton.TextColor3 = FirstTab and Color3.fromRGB(15, 15, 20) or Color3.fromRGB(170, 170, 180)
    TabButton.Font = Enum.Font.GothamMedium
    TabButton.TextSize = 11
    TabButton.Parent = TopTabNav

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 5)
    TabCorner.Parent = TabButton

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
    UIList.Padding = UDim.new(0, 6)

    UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabContainer.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y + 8)
    end)

    local TabObj = { Button = TabButton, Container = TabContainer }

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Container.Visible = false
            t.Button.BackgroundColor3 = Color3.fromRGB(22, 25, 32)
            t.Button.TextColor3 = Color3.fromRGB(170, 170, 180)
        end
        TabContainer.Visible = true
        TabButton.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
        TabButton.TextColor3 = Color3.fromRGB(15, 15, 20)
    end)

    table.insert(Tabs, TabObj)
    FirstTab = false

    local Elements = {}

    -- Section Title
    function Elements:AddSection(text)
        local Sec = Instance.new("TextLabel")
        Sec.Size = UDim2.new(1, -4, 0, 16)
        Sec.BackgroundTransparency = 1
        Sec.Text = string.upper(text)
        Sec.TextColor3 = Color3.fromRGB(0, 255, 136)
        Sec.Font = Enum.Font.GothamBold
        Sec.TextSize = 10
        Sec.TextXAlignment = Enum.TextXAlignment.Left
        Sec.Parent = TabContainer
    end

    -- Toggle
    function Elements:CreateToggle(text, defaultState, callback)
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -6, 0, 30)
        Card.BackgroundColor3 = Color3.fromRGB(20, 23, 30)
        Card.Parent = TabContainer

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 5)
        CardCorner.Parent = Card

        local TglBtn = Instance.new("TextButton")
        TglBtn.Size = UDim2.new(1, 0, 1, 0)
        TglBtn.BackgroundTransparency = 1
        TglBtn.Text = "  " .. text
        TglBtn.TextColor3 = Color3.fromRGB(210, 210, 220)
        TglBtn.Font = Enum.Font.GothamMedium
        TglBtn.TextSize = 11
        TglBtn.TextXAlignment = Enum.TextXAlignment.Left
        TglBtn.Parent = Card

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 14, 0, 14)
        Indicator.Position = UDim2.new(1, -20, 0.5, -7)
        Indicator.BackgroundColor3 = defaultState and Color3.fromRGB(0, 255, 136) or Color3.fromRGB(45, 48, 60)
        Indicator.Parent = Card

        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(0, 3)
        IndCorner.Parent = Indicator

        local enabled = defaultState or false
        TglBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            Indicator.BackgroundColor3 = enabled and Color3.fromRGB(0, 255, 136) or Color3.fromRGB(45, 48, 60)
            pcall(callback, enabled)
        end)
    end

    -- Slider Component
    function Elements:CreateSlider(text, min, max, default, callback)
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -6, 0, 42)
        Card.BackgroundColor3 = Color3.fromRGB(20, 23, 30)
        Card.Parent = TabContainer

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 5)
        CardCorner.Parent = Card

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -10, 0, 18)
        Title.Position = UDim2.new(0, 8, 0, 2)
        Title.BackgroundTransparency = 1
        Title.Text = text .. ": " .. tostring(default)
        Title.TextColor3 = Color3.fromRGB(210, 210, 220)
        Title.Font = Enum.Font.GothamMedium
        Title.TextSize = 11
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Card

        local SliderBar = Instance.new("TextButton")
        SliderBar.Name = "SliderBar"
        SliderBar.Size = UDim2.new(1, -16, 0, 6)
        SliderBar.Position = UDim2.new(0, 8, 0, 26)
        SliderBar.BackgroundColor3 = Color3.fromRGB(40, 45, 55)
        SliderBar.Text = ""
        SliderBar.AutoButtonColor = false
        SliderBar.Parent = Card

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = SliderBar

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
        Fill.BorderSizePixel = 0
        Fill.Parent = SliderBar

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill

        local UserInputService = game:GetService("UserInputService")
        local dragging = false

        local function update(input)
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + ((max - min) * pos))
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            Title.Text = text .. ": " .. tostring(val)
            pcall(callback, val)
        end

        SliderBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                update(input)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                update(input)
            end
        end)
    end

    -- Button Normal
    function Elements:CreateButton(text, callback)
        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -6, 0, 28)
        Btn.BackgroundColor3 = Color3.fromRGB(20, 23, 30)
        Btn.Text = text
        Btn.TextColor3 = Color3.fromRGB(210, 210, 220)
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

UI.Container = ContentArea
return UI
