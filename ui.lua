if game:GetService("CoreGui"):FindFirstChild("ZxDHub") then
    game:GetService("CoreGui").ZxDHub:Destroy()
end

local UI = {}

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZxDHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

-- Theme Palette: Full Taupe / Soft Warm Abu Coklat
local Theme = {
    Background  = Color3.fromRGB(28, 25, 23),    -- Warm Dark Taupe
    Header      = Color3.fromRGB(36, 33, 30),    -- Mid Warm Taupe
    CardBG      = Color3.fromRGB(42, 38, 35),    -- Soft Warm Taupe Card
    ActivePill  = Color3.fromRGB(155, 122, 92),  -- Warm Earthy Brown Accent
    InactivePill= Color3.fromRGB(50, 45, 41),    -- Muted Dark Taupe
    TextPrimary = Color3.fromRGB(240, 236, 230), -- Soft Off-White
    TextMuted   = Color3.fromRGB(160, 150, 142), -- Warm Taupe Muted Text
    Border      = Color3.fromRGB(65, 58, 52)     -- Soft Taupe Border
}

-- Mobile Open/Close Button (Circle Pill Floating)
local MobileBtn = Instance.new("TextButton")
MobileBtn.Name = "MobileToggle"
MobileBtn.Size = UDim2.new(0, 44, 0, 44)
MobileBtn.Position = UDim2.new(0.08, 0, 0.2, 0)
MobileBtn.BackgroundColor3 = Theme.Background
MobileBtn.Text = "ZxD"
MobileBtn.TextColor3 = Theme.ActivePill
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.TextSize = 13
MobileBtn.Active = true
MobileBtn.Draggable = true
MobileBtn.Parent = ScreenGui

local MobCorner = Instance.new("UICorner")
MobCorner.CornerRadius = UDim.new(1, 0)
MobCorner.Parent = MobileBtn

local MobStroke = Instance.new("UIStroke")
MobStroke.Color = Theme.ActivePill
MobStroke.Thickness = 1.5
MobStroke.Parent = MobileBtn

---------------------------------------------------------
-- 1. DETACHED TAB WINDOW (Window Tab Terpisah)
---------------------------------------------------------
local TabWindow = Instance.new("Frame")
TabWindow.Name = "TabWindow"
TabWindow.Size = UDim2.new(0, 420, 0, 38)
TabWindow.Position = UDim2.new(0.5, -210, 0.5, -150) -- Dipisah di atas
TabWindow.BackgroundColor3 = Theme.Background
TabWindow.BorderSizePixel = 0
TabWindow.Active = true
TabWindow.Draggable = true -- Bisa ditarik dan diseret terpisah
TabWindow.Parent = ScreenGui

local TabWinCorner = Instance.new("UICorner")
TabWinCorner.CornerRadius = UDim.new(1, 0) -- Full Capsule Window
TabWinCorner.Parent = TabWindow

local TabWinStroke = Instance.new("UIStroke")
TabWinStroke.Color = Theme.Border
TabWinStroke.Thickness = 1
TabWinStroke.Parent = TabWindow

local FloatingTabNav = Instance.new("ScrollingFrame")
FloatingTabNav.Name = "FloatingTabNav"
FloatingTabNav.Size = UDim2.new(1, -16, 1, -8)
FloatingTabNav.Position = UDim2.new(0, 8, 0, 4)
FloatingTabNav.BackgroundTransparency = 1
FloatingTabNav.ScrollBarThickness = 0
FloatingTabNav.CanvasSize = UDim2.new(0, 0, 0, 0)
FloatingTabNav.Parent = TabWindow

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = FloatingTabNav
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    FloatingTabNav.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X, 0, 0)
end)

---------------------------------------------------------
-- 2. DETACHED MAIN CONTENT WINDOW (Window Isi Card)
---------------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 240)
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -100) -- Ada jeda melayang dengan TabWindow
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1
MainStroke.Parent = MainFrame

MobileBtn.MouseButton1Click:Connect(function()
    local isVis = not MainFrame.Visible
    MainFrame.Visible = isVis
    TabWindow.Visible = isVis
end)

-- Header Bar
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3 = Theme.Header
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 14)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "<b>ZxD HUB</b> | <font color=\"#9B7A5C\">Minimalist Taupe</font>"
Title.RichText = true
Title.TextColor3 = Theme.TextPrimary
Title.TextSize = 12
Title.Font = Enum.Font.Gotham
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -28, 0.5, -10)
CloseBtn.BackgroundColor3 = Theme.CardBG
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

-- Area Content Area
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -16, 1, -42)
ContentArea.Position = UDim2.new(0, 8, 0, 36)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

---------------------------------------------------------
-- BUILDER LOGIC
---------------------------------------------------------
local Tabs = {}
local FirstTab = true

function UI:CreateTab(tabName)
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 95, 1, 0)
    TabButton.BackgroundColor3 = FirstTab and Theme.ActivePill or Theme.InactivePill
    TabButton.Text = tabName
    TabButton.TextColor3 = FirstTab and Theme.TextPrimary or Theme.TextMuted
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

    -- Left Column
    local LeftColumn = Instance.new("ScrollingFrame")
    LeftColumn.Name = "LeftColumn"
    LeftColumn.Size = UDim2.new(0.5, -4, 1, 0)
    LeftColumn.Position = UDim2.new(0, 0, 0, 0)
    LeftColumn.BackgroundTransparency = 1
    LeftColumn.ScrollBarThickness = 2
    LeftColumn.ScrollBarImageColor3 = Theme.ActivePill
    LeftColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
    LeftColumn.Parent = TabContainer

    local LeftList = Instance.new("UIListLayout")
    LeftList.Parent = LeftColumn
    LeftList.Padding = UDim.new(0, 6)

    LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        LeftColumn.CanvasSize = UDim2.new(0, 0, 0, LeftList.AbsoluteContentSize.Y + 4)
    end)

    -- Right Column
    local RightColumn = Instance.new("ScrollingFrame")
    RightColumn.Name = "RightColumn"
    RightColumn.Size = UDim2.new(0.5, -4, 1, 0)
    RightColumn.Position = UDim2.new(0.5, 4, 0, 0)
    RightColumn.BackgroundTransparency = 1
    RightColumn.ScrollBarThickness = 2
    RightColumn.ScrollBarImageColor3 = Theme.ActivePill
    RightColumn.CanvasSize = UDim2.new(0, 0, 0, 0)
    RightColumn.Parent = TabContainer

    local RightList = Instance.new("UIListLayout")
    RightList.Parent = RightColumn
    RightList.Padding = UDim.new(0, 6)

    RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        RightColumn.CanvasSize = UDim2.new(0, 0, 0, RightList.AbsoluteContentSize.Y + 4)
    end)

    local TabObj = { Button = TabButton, Container = TabContainer }

    TabButton.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Container.Visible = false
            t.Button.BackgroundColor3 = Theme.InactivePill
            t.Button.TextColor3 = Theme.TextMuted
        end
        TabContainer.Visible = true
        TabButton.BackgroundColor3 = Theme.ActivePill
        TabButton.TextColor3 = Theme.TextPrimary
    end)

    table.insert(Tabs, TabObj)
    FirstTab = false

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
        Sec.TextColor3 = Theme.ActivePill
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
        CardCorner.CornerRadius = UDim.new(0, 8)
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
        Indicator.BackgroundColor3 = defaultState and Theme.ActivePill or Theme.InactivePill
        Indicator.Parent = Card

        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(1, 0)
        IndCorner.Parent = Indicator

        local enabled = defaultState or false
        TglBtn.MouseButton1Click:Connect(function()
            enabled = not enabled
            Indicator.BackgroundColor3 = enabled and Theme.ActivePill or Theme.InactivePill
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
        CardCorner.CornerRadius = UDim.new(0, 8)
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
        SliderBar.BackgroundColor3 = Theme.InactivePill
        SliderBar.Text = ""
        SliderBar.AutoButtonColor = false
        SliderBar.Parent = Card

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = SliderBar

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Theme.ActivePill
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
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Btn

        Btn.MouseButton1Click:Connect(function()
            pcall(callback)
        end)
    end

    return Elements
end

UI.Container = ContentArea
return UI
