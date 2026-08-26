if game:GetService("CoreGui"):FindFirstChild("ZxDHub") then
    game:GetService("CoreGui").ZxDHub:Destroy()
end

local UI = {}

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZxDHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Palet Warna Minimalist Modern (Hitam, Coklat, Abu-abu, Putih)
local Theme = {
    Background  = Color3.fromRGB(18, 18, 20),    -- Hitam Gelap
    Header      = Color3.fromRGB(25, 25, 28),    -- Hitam Abu
    CardBG      = Color3.fromRGB(28, 28, 32),    -- Abu-abu Gelap
    AccentBrown = Color3.fromRGB(160, 110, 75),  -- Coklat Modern (Accent)
    TabInactive = Color3.fromRGB(35, 35, 40),   -- Abu-abu Netral
    TextPrimary = Color3.fromRGB(240, 240, 245), -- Putih / Off-White
    TextMuted   = Color3.fromRGB(150, 150, 160), -- Abu-abu Terang
    Border      = Color3.fromRGB(50, 50, 58)     -- Line Border
}

-- Mobile Open/Close Toggle Button
local MobileBtn = Instance.new("TextButton")
MobileBtn.Name = "MobileToggle"
MobileBtn.Size = UDim2.new(0, 42, 0, 42)
MobileBtn.Position = UDim2.new(0.08, 0, 0.2, 0)
MobileBtn.BackgroundColor3 = Theme.Background
MobileBtn.Text = "ZxD"
MobileBtn.TextColor3 = Theme.AccentBrown
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.TextSize = 13
MobileBtn.Active = true
MobileBtn.Draggable = true
MobileBtn.Parent = ScreenGui

local MobCorner = Instance.new("UICorner")
MobCorner.CornerRadius = UDim.new(0, 8)
MobCorner.Parent = MobileBtn

local MobStroke = Instance.new("UIStroke")
MobStroke.Color = Theme.AccentBrown
MobStroke.Thickness = 1.5
MobStroke.Parent = MobileBtn

-- Main Frame Window
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 270)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -125)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

MobileBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

-- FLOATING TABS AREA (Melayang di atas Main Frame)
local FloatingTabNav = Instance.new("ScrollingFrame")
FloatingTabNav.Name = "FloatingTabNav"
FloatingTabNav.Size = UDim2.new(1, 0, 0, 30)
FloatingTabNav.Position = UDim2.new(0, 0, 0, -36) -- Posisi melayang ke atas
FloatingTabNav.BackgroundTransparency = 1
FloatingTabNav.ScrollBarThickness = 0
FloatingTabNav.CanvasSize = UDim2.new(0, 0, 0, 0)
FloatingTabNav.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = FloatingTabNav
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FloatingTabNav.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X, 0, 0)
end)

-- Header Bar Utama
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Theme.Header
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 10)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 12, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>ZxD HUB</b> | <font color=\"#A06E4B\">Minimalist</font>"
Title.RichText = true
Title.TextColor3 = Theme.TextPrimary
Title.TextSize = 12
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -11)
CloseBtn.BackgroundColor3 = Theme.CardBG
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.TextMuted
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 5)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Area Content Utama
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -16, 1, -44)
ContentArea.Position = UDim2.new(0, 8, 0, 38)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

---------------------------------------------------------
-- TAB SYSTEM & 2-COLUMN LAYOUT BUILDER
---------------------------------------------------------

local Tabs = {}
local FirstTab = true

function UI:CreateTab(tabName)
    -- Tab Button Box Melayang
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 90, 1, 0)
    TabButton.BackgroundColor3 = FirstTab and Theme.AccentBrown or Theme.TabInactive
    TabButton.Text = tabName
    TabButton.TextColor3 = FirstTab and Theme.TextPrimary or Theme.TextMuted
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 11
    TabButton.Parent = FloatingTabNav

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(0, 6)
    TabCorner.Parent = TabButton

    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = FirstTab and Theme.AccentBrown or Theme.Border
    TabStroke.Thickness = 1
    TabStroke.Parent = TabButton

    -- Frame Container Khusus Tab Ini
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = tabName .. "Container"
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Visible = FirstTab
    TabContainer.Parent = ContentArea

    -- Kolom Kiri
    local LeftColumn = Instance.new("ScrollingFrame")
    LeftColumn.Name = "LeftColumn"
    LeftColumn.Size = UDim2.new(0.5, -4, 1, 0)
    LeftColumn.Position = UDim2.new(0, 0, 0, 0)
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.ScrollBarThickness = 2
    LeftColumn.ScrollBarImageColor3 = Theme.AccentBrown
    LeftColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
    LeftColumn.Parent = TabContainer

    local LeftList = Instance.new("UIListLayout")
    LeftList.Parent = LeftColumn
    LeftList.Padding = UDim.new(0, 6)

    LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        LeftColumn.CanvasSize = UDim2.new(0, 0, 0, LeftList.AbsoluteContentSize.Y + 4)
    end)

    -- Kolom Kanan
    local RightColumn = Instance.new("ScrollingFrame")
    RightColumn.Name = "RightColumn"
    RightColumn.Size = UDim2.new(0.5, -4, 1, 0)
    RightColumn.Position = UDim2.new(0.5, 4, 0, 0)
    RightColumn.BackgroundTransparency = 1
    RightColumn.ScrollBarThickness = 2
    RightColumn.ScrollBarImageColor3 = Theme.AccentBrown
    RightColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
    RightColumn.Parent = TabContainer

    local RightList = Instance.new("UIListLayout")
    RightList.Parent = RightColumn
    RightList.Padding = UDim.new(0, 6)

    RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        RightColumn.CanvasSize = UDim2.new(0, 0, 0, RightList.AbsoluteContentSize.Y + 4)
    end)

    local TabObj = { Button = TabButton, Container = TabContainer, Stroke = TabStroke }

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Container.Visible = false
            t.Button.BackgroundColor3 = Theme.TabInactive
            t.Button.TextColor3 = Theme.TextMuted
            t.Stroke.Color = Theme.Border
        end
        TabContainer.Visible = true
        TabButton.BackgroundColor3 = Theme.AccentBrown
        TabButton.TextColor3 = Theme.TextPrimary
        TabStroke.Color = Theme.AccentBrown
    end)

    table.insert(Tabs, TabObj)
    FirstTab = false

    ---------------------------------------------------------
    -- ELEMENT BUILDER (SUPPORT LEFT & RIGHT COLUMN)
    ---------------------------------------------------------
    local Elements = {}

    local function GetTargetContainer(side)
        return (side and string.lower(side) == "right") and RightColumn or LeftColumn
    end

    function Elements:AddSection(text, side)
        local Target = GetTargetContainer(side)
        local Sec = Instance.new("TextLabel")
        Sec.Size = UDim2.new(1, -4, 0, 16)
        Sec.BackgroundTransparency = 1
        Sec.Text = string.upper(text)
        Sec.TextColor3 = Theme.AccentBrown
        Sec.Font = Enum.Font.GothamBold
        Sec.TextSize = 10
        Sec.TextXAlignment = Enum.TextXAlignment.Left
        Sec.Parent = Target
    end

    function Elements:CreateToggle(text, defaultState, side, callback)
        local Target = GetTargetContainer(side)

        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -4, 0, 30)
        Card.BackgroundColor3 = Theme.CardBG
        Card.Parent = Target

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 5)
        CardCorner.Parent = Card

        local TglBtn = Instance.new("TextButton")
        TglBtn.Size = UDim2.new(1, 0, 1, 0)
        TglBtn.BackgroundTransparency = 1
        TglBtn.Text = "  " .. text
        TglBtn.TextColor3 = Theme.TextPrimary
        TglBtn.Font = Enum.Font.GothamMedium
        TglBtn.TextSize = 11
        TglBtn.TextXAlignment = Enum.TextXAlignment.Left
        TglBtn.Parent = Card

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 12, 0, 12)
        Indicator.Position = UDim2.new(1, -18, 0.5, -6)
        Indicator.BackgroundColor3 = defaultState and Theme.AccentBrown or Theme.TabInactive
        Indicator.Parent = Card

        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(0, 3)
        IndCorner.Parent = Indicator

        local enabled = defaultState or false
        TglBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            Indicator.BackgroundColor3 = enabled and Theme.AccentBrown or Theme.TabInactive
            pcall(callback, enabled)
        end)
    end

    function Elements:CreateSlider(text, min, max, default, side, callback)
        local Target = GetTargetContainer(side)

        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -4, 0, 40)
        Card.BackgroundColor3 = Theme.CardBG
        Card.Parent = Target

        local CardCorner = Instance.new("UICorner")
        CardCorner.CornerRadius = UDim.new(0, 5)
        CardCorner.Parent = Card

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, -10, 0, 16)
        Title.Position = UDim2.new(0, 8, 0, 2)
        Title.BackgroundTransparency = 1
        Title.Text = text .. ": " .. tostring(default)
        Title.TextColor3 = Theme.TextPrimary
        Title.Font = Enum.Font.GothamMedium
        Title.TextSize = 10
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Card

        local SliderBar = Instance.new("TextButton")
        SliderBar.Size = UDim2.new(1, -16, 0, 5)
        SliderBar.Position = UDim2.new(0, 8, 0, 25)
        SliderBar.BackgroundColor3 = Theme.TabInactive
        SliderBar.Text = ""
        SliderBar.AutoButtonColor = false
        SliderBar.Parent = Card

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = SliderBar

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Theme.AccentBrown
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

    function Elements:CreateButton(text, side, callback)
        local Target = GetTargetContainer(side)

        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, -4, 0, 28)
        Btn.BackgroundColor3 = Theme.CardBG
        Btn.Text = text
        Btn.TextColor3 = Theme.TextPrimary
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 11
        Btn.AutoButtonColor = true
        Btn.Parent = Target

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
