if game:GetService("CoreGui"):FindFirstChild("ZxDHub") then
    game:GetService("CoreGui").ZxDHub:Destroy()
end

local UI = {}

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZxDHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Theme Palette: Ultra Dark Minimalist
local Theme = {
    Background  = Color3.fromRGB(8, 8, 10),      -- Deepest Pitch Black
    Header      = Color3.fromRGB(12, 12, 15),    -- Very Dark Charcoal
    CardBG      = Color3.fromRGB(15, 15, 19),    -- Standalone Card Box
    ActiveCyan  = Color3.fromRGB(0, 190, 245),   -- Cyan Accent
    InactivePill= Color3.fromRGB(24, 24, 32),    -- Dark Muted Pill
    TextPrimary = Color3.fromRGB(240, 240, 245), -- Crisp White
    TextMuted   = Color3.fromRGB(100, 105, 120), -- Subtle Dark Grey
    Border      = Color3.fromRGB(30, 32, 40)     -- Very Subtle Border Line
}

-- Mobile Toggle Button
local MobileBtn = Instance.new("TextButton")
MobileBtn.Name = "MobileToggle"
MobileBtn.Size = UDim2.new(0, 42, 0, 42)
MobileBtn.Position = UDim2.new(0.08, 0, 0.2, 0)
MobileBtn.BackgroundColor3 = Theme.Background
MobileBtn.Text = "ZxD"
MobileBtn.TextColor3 = Theme.ActiveCyan
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.TextSize = 13
MobileBtn.Active = true
MobileBtn.Draggable = true
MobileBtn.Parent = ScreenGui

local MobCorner = Instance.new("UICorner")
MobCorner.CornerRadius = UDim.new(1, 0)
MobCorner.Parent = MobileBtn

local MobStroke = Instance.new("UIStroke")
MobStroke.Color = Theme.ActiveCyan
MobStroke.Thickness = 1.5
MobStroke.Parent = MobileBtn

---------------------------------------------------------
-- MAIN FRAME WINDOW
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 460, 0, 275)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -137)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

MobileBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Header Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Theme.Header
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>ZxD HUB</b> <font color=\"#00BEF5\">CLEAN ULTRA</font>"
Title.RichText = true
Title.TextColor3 = Theme.TextPrimary
Title.TextSize = 12
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -26, 0.5, -10)
CloseBtn.BackgroundColor3 = Theme.InactivePill
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.TextMuted
CloseBtn.TextSize = 15
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Top Floating Tab Bar (DENGAN GAP DENGAN JARAK EXTRA 8PX)
local FloatingTabNav = Instance.new("ScrollingFrame")
FloatingTabNav.Name = "FloatingTabNav"
FloatingTabNav.Size = UDim2.new(1, -16, 0, 26)
FloatingTabNav.Position = UDim2.new(0, 8, 0, 38)
FloatingTabNav.BackgroundTransparency = 1
FloatingTabNav.ScrollBarThickness = 0
FloatingTabNav.CanvasSize = UDim2.new(0, 0, 0, 0)
FloatingTabNav.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = FloatingTabNav
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8) -- GAP JELAS ANTAR TAB KAPSUL

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FloatingTabNav.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X, 0, 0)
end)

-- Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -16, 1, -74)
ContentArea.Position = UDim2.new(0, 8, 0, 68)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

---------------------------------------------------------
-- BUILDER LOGIC (2 CARD BOX TERPISAH GAP)
---------------------------------------------------------
local Tabs = {}
local FirstTab = true

function UI:CreateTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 92, 1, 0)
    TabButton.BackgroundColor3 = FirstTab and Theme.ActiveCyan or Theme.InactivePill
    TabButton.Text = tabName
    TabButton.TextColor3 = FirstTab and Theme.Background or Theme.TextMuted
    TabButton.Font = Enum.Font.GothamBold
    TabButton.TextSize = 11
    TabButton.Parent = FloatingTabNav

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(1, 0)
    TabCorner.Parent = TabButton

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = tabName .. "Container"
    TabContainer.Size = UDim2.new(1, 0, 1, 0)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Visible = FirstTab
    TabContainer.Parent = ContentArea

    ---------------------------------------------------------
    -- CARD 1: KIRI
    ---------------------------------------------------------
    local LeftCard = Instance.new("Frame")
    LeftCard.Name = "LeftCard"
    LeftCard.Size = UDim2.new(0.5, -8, 1, 0)
    LeftCard.Position = UDim2.new(0, 0, 0, 0)
    LeftCard.BackgroundColor3 = Theme.CardBG
    LeftCard.Parent = TabContainer

    local LeftCardCorner = Instance.new("UICorner")
    LeftCardCorner.CornerRadius = UDim.new(0, 10)
    LeftCardCorner.Parent = LeftCard

    local LeftCardStroke = Instance.new("UIStroke")
    LeftCardStroke.Color = Theme.Border
    LeftCardStroke.Thickness = 1
    LeftCardStroke.Parent = LeftCard

    local LeftScroll = Instance.new("ScrollingFrame")
    LeftScroll.Size = UDim2.new(1, -16, 1, -12)
    LeftScroll.Position = UDim2.new(0, 8, 0, 6)
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.ScrollBarThickness = 2
    LeftScroll.ScrollBarImageColor3 = Theme.ActiveCyan
    LeftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    LeftScroll.Parent = LeftCard

    local LeftList = Instance.new("UIListLayout")
    LeftList.Parent = LeftScroll
    LeftList.Padding = UDim.new(0, 8)

    LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        LeftScroll.CanvasSize = UDim2.new(0, 0, 0, LeftList.AbsoluteContentSize.Y + 4)
    end)

    ---------------------------------------------------------
    -- CARD 2: KANAN (GAP 16PX DI TENGAH)
    ---------------------------------------------------------
    local RightCard = Instance.new("Frame")
    RightCard.Name = "RightCard"
    RightCard.Size = UDim2.new(0.5, -8, 1, 0)
    RightCard.Position = UDim2.new(0.5, 8, 0, 0)
    RightCard.BackgroundColor3 = Theme.CardBG
    RightCard.Parent = TabContainer

    local RightCardCorner = Instance.new("UICorner")
    RightCardCorner.CornerRadius = UDim.new(0, 10)
    RightCardCorner.Parent = RightCard

    local RightCardStroke = Instance.new("UIStroke")
    RightCardStroke.Color = Theme.Border
    RightCardStroke.Thickness = 1
    RightCardStroke.Parent = RightCard

    local RightScroll = Instance.new("ScrollingFrame")
    RightScroll.Size = UDim2.new(1, -16, 1, -12)
    RightScroll.Position = UDim2.new(0, 8, 0, 6)
    RightScroll.BackgroundTransparency = 1
    RightScroll.ScrollBarThickness = 2
    RightScroll.ScrollBarImageColor3 = Theme.ActiveCyan
    RightScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    RightScroll.Parent = RightCard

    local RightList = Instance.new("UIListLayout")
    RightList.Parent = RightScroll
    RightList.Padding = UDim.new(0, 8)

    RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        RightScroll.CanvasSize = UDim2.new(0, 0, 0, RightList.AbsoluteContentSize.Y + 4)
    end)

    local TabObj = { Button = TabButton, Container = TabContainer }

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Container.Visible = false
            t.Button.BackgroundColor3 = Theme.InactivePill
            t.Button.TextColor3 = Theme.TextMuted
        end
        TabContainer.Visible = true
        TabButton.BackgroundColor3 = Theme.ActiveCyan
        TabButton.TextColor3 = Theme.Background
    end)

    table.insert(Tabs, TabObj)
    FirstTab = false

    ---------------------------------------------------------
    -- ELEMENT BUILDERS (CLEAN / NON-BOX ITEM)
    ---------------------------------------------------------
    local Elements = {}

    local function GetTargetScroll(side)
        return (side and string.lower(side) == "right") and RightScroll or LeftScroll
    end

    function Elements:AddSection(text, side)
        local Target = GetTargetScroll(side)
        local Sec = Instance.new("TextLabel")
        Sec.Size = UDim2.new(1, 0, 0, 16)
        Sec.BackgroundTransparency = 1
        Sec.Text = "• " .. string.upper(text)
        Sec.TextColor3 = Theme.ActiveCyan
        Sec.Font = Enum.Font.GothamBold
        Sec.TextSize = 10
        Sec.TextXAlignment = Enum.TextXAlignment.Left
        Sec.Parent = Target
    end

    function Elements:CreateToggle(text, defaultState, side, callback)
        local Target = GetTargetScroll(side)

        -- Clean Item (Tanpa Box BG Tambahan)
        local Item = Instance.new("Frame")
        Item.Size = UDim2.new(1, 0, 0, 24)
        Item.BackgroundTransparency = 1
        Item.Parent = Target

        local TglBtn = Instance.new("TextButton")
        TglBtn.Size = UDim2.new(1, 0, 1, 0)
        TglBtn.BackgroundTransparency = 1
        TglBtn.Text = text
        TglBtn.TextColor3 = Theme.TextPrimary
        TglBtn.Font = Enum.Font.GothamMedium
        TglBtn.TextSize = 10
        TglBtn.TextXAlignment = Enum.TextXAlignment.Left
        TglBtn.Parent = Item

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 22, 0, 12)
        Indicator.Position = UDim2.new(1, -22, 0.5, -6)
        Indicator.BackgroundColor3 = defaultState and Theme.ActiveCyan or Theme.InactivePill
        Indicator.Parent = Item

        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(1, 0)
        IndCorner.Parent = Indicator

        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.new(0, 10, 0, 10)
        Dot.Position = defaultState and UDim2.new(1, -11, 0.5, -5) or UDim2.new(0, 1, 0.5, -5)
        Dot.BackgroundColor3 = Theme.TextPrimary
        Dot.Parent = Indicator

        local DotCorner = Instance.new("UICorner")
        DotCorner.CornerRadius = UDim.new(1, 0)
        DotCorner.Parent = Dot

        local enabled = defaultState or false
        TglBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            Indicator.BackgroundColor3 = enabled and Theme.ActiveCyan or Theme.InactivePill
            Dot.Position = enabled and UDim2.new(1, -11, 0.5, -5) or UDim2.new(0, 1, 0.5, -5)
            pcall(callback, enabled)
        end)
    end

    function Elements:CreateSlider(text, min, max, default, side, callback)
        local Target = GetTargetScroll(side)

        local Item = Instance.new("Frame")
        Item.Size = UDim2.new(1, 0, 0, 32)
        Item.BackgroundTransparency = 1
        Item.Parent = Target

        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 14)
        Title.Position = UDim2.new(0, 0, 0, 0)
        Title.BackgroundTransparency = 1
        Title.Text = text .. ": <font color=\"#00BEF5\">" .. tostring(default) .. "</font>"
        Title.RichText = true
        Title.TextColor3 = Theme.TextPrimary
        Title.Font = Enum.Font.GothamMedium
        Title.TextSize = 10
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Item

        local SliderBar = Instance.new("TextButton")
        SliderBar.Size = UDim2.new(1, 0, 0, 4)
        SliderBar.Position = UDim2.new(0, 0, 0, 20)
        SliderBar.BackgroundColor3 = Theme.InactivePill
        SliderBar.Text = ""
        SliderBar.AutoButtonColor = false
        SliderBar.Parent = Item

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = SliderBar

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Theme.ActiveCyan
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
            Title.Text = text .. ": <font color=\"#00BEF5\">" .. tostring(val) .. "</font>"
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
        local Target = GetTargetScroll(side)

        local Btn = Instance.new("TextButton")
        Btn.Size = UDim2.new(1, 0, 0, 24)
        Btn.BackgroundColor3 = Theme.InactivePill
        Btn.Text = text
        Btn.TextColor3 = Theme.TextPrimary
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 10
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
