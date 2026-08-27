if game:GetService("CoreGui"):FindFirstChild("ZxDHub") then
    game:GetService("CoreGui").ZxDHub:Destroy()
end

local UI = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZxDHub"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Theme Palette: Minimalist Monochrome Dark
local Theme = {
    Background   = Color3.fromRGB(10, 10, 11),
    CardBG       = Color3.fromRGB(16, 16, 18),
    ItemHover    = Color3.fromRGB(22, 22, 25),
    Accent       = Color3.fromRGB(245, 245, 245),  -- Pure-ish white accent
    AccentDim    = Color3.fromRGB(180, 180, 185),
    InactivePill = Color3.fromRGB(20, 20, 22),
    TextPrimary  = Color3.fromRGB(235, 235, 238),
    TextMuted    = Color3.fromRGB(110, 110, 118),
    Border       = Color3.fromRGB(28, 28, 31)
}

local function tween(obj, props, time, style)
    local t = TweenService:Create(obj, TweenInfo.new(time or 0.22, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

---------------------------------------------------------
-- TOAST NOTIFICATIONS (small pop-up feedback, top of screen)
---------------------------------------------------------
local ToastHolder = Instance.new("Frame")
ToastHolder.Name = "ToastHolder"
ToastHolder.AnchorPoint = Vector2.new(0.5, 0)
ToastHolder.Position = UDim2.new(0.5, 0, 0, 14)
ToastHolder.Size = UDim2.new(0, 260, 0, 0)
ToastHolder.BackgroundTransparency = 1
ToastHolder.ZIndex = 50
ToastHolder.Parent = ScreenGui

local ToastList = Instance.new("UIListLayout")
ToastList.Parent = ToastHolder
ToastList.HorizontalAlignment = Enum.HorizontalAlignment.Center
ToastList.Padding = UDim.new(0, 6)

local function ShowToast(text, isOn)
    local Toast = Instance.new("Frame")
    Toast.Size = UDim2.new(0, 240, 0, 36)
    Toast.BackgroundColor3 = Theme.CardBG
    Toast.BackgroundTransparency = 1
    Toast.ZIndex = 51
    Toast.Parent = ToastHolder

    local ToastCorner = Instance.new("UICorner")
    ToastCorner.CornerRadius = UDim.new(0, 10)
    ToastCorner.Parent = Toast

    local ToastStroke = Instance.new("UIStroke")
    ToastStroke.Color = Theme.Border
    ToastStroke.Thickness = 1
    ToastStroke.Transparency = 1
    ToastStroke.Parent = Toast

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 8, 0, 8)
    Dot.Position = UDim2.new(0, 12, 0.5, -4)
    Dot.BackgroundColor3 = (isOn == nil or isOn) and Theme.Accent or Theme.TextMuted
    Dot.BackgroundTransparency = 1
    Dot.ZIndex = 52
    Dot.Parent = Toast

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -34, 1, 0)
    Label.Position = UDim2.new(0, 28, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.TextPrimary
    Label.TextTransparency = 1
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.ZIndex = 52
    Label.Parent = Toast

    tween(Toast, {BackgroundTransparency = 0.05}, 0.18)
    tween(ToastStroke, {Transparency = 0}, 0.18)
    tween(Dot, {BackgroundTransparency = 0}, 0.18)
    tween(Label, {TextTransparency = 0}, 0.18)

    task.delay(1.4, function()
        tween(Toast, {BackgroundTransparency = 1}, 0.25)
        tween(ToastStroke, {Transparency = 1}, 0.25)
        tween(Dot, {BackgroundTransparency = 1}, 0.25)
        tween(Label, {TextTransparency = 1}, 0.25)
        task.wait(0.28)
        Toast:Destroy()
    end)
end

---------------------------------------------------------
-- MOBILE TOGGLE (Floating minimal dot/button)
---------------------------------------------------------
local MobileBtn = Instance.new("TextButton")
MobileBtn.Name = "MobileToggle"
MobileBtn.Size = UDim2.new(0, 40, 0, 40)
MobileBtn.Position = UDim2.new(0, 14, 0.35, 0)
MobileBtn.BackgroundColor3 = Theme.Background
MobileBtn.Text = "•"
MobileBtn.TextColor3 = Theme.Accent
MobileBtn.Font = Enum.Font.GothamBold
MobileBtn.TextSize = 22
MobileBtn.AutoButtonColor = false
MobileBtn.Active = true
MobileBtn.Draggable = true
MobileBtn.ZIndex = 10
MobileBtn.Parent = ScreenGui

local MobCorner = Instance.new("UICorner")
MobCorner.CornerRadius = UDim.new(1, 0)
MobCorner.Parent = MobileBtn

local MobStroke = Instance.new("UIStroke")
MobStroke.Color = Theme.Border
MobStroke.Thickness = 1
MobStroke.Parent = MobileBtn

---------------------------------------------------------
-- WATERMARK (floating, separate from main window, draggable)
---------------------------------------------------------
local Watermark = Instance.new("Frame")
Watermark.Name = "Watermark"
Watermark.Size = UDim2.new(0, 150, 0, 26)
Watermark.Position = UDim2.new(0, 14, 0, 14)
Watermark.BackgroundColor3 = Theme.CardBG
Watermark.BackgroundTransparency = 0.05
Watermark.Active = true
Watermark.Draggable = true
Watermark.ZIndex = 8
Watermark.Parent = ScreenGui

local WatermarkCorner = Instance.new("UICorner")
WatermarkCorner.CornerRadius = UDim.new(0, 8)
WatermarkCorner.Parent = Watermark

local WatermarkStroke = Instance.new("UIStroke")
WatermarkStroke.Color = Theme.Border
WatermarkStroke.Thickness = 1
WatermarkStroke.Parent = Watermark

local WatermarkDot = Instance.new("Frame")
WatermarkDot.Size = UDim2.new(0, 6, 0, 6)
WatermarkDot.Position = UDim2.new(0, 10, 0.5, -3)
WatermarkDot.BackgroundColor3 = Theme.Accent
WatermarkDot.Parent = Watermark

local WatermarkDotCorner = Instance.new("UICorner")
WatermarkDotCorner.CornerRadius = UDim.new(1, 0)
WatermarkDotCorner.Parent = WatermarkDot

local WatermarkLabel = Instance.new("TextLabel")
WatermarkLabel.Size = UDim2.new(1, -24, 1, 0)
WatermarkLabel.Position = UDim2.new(0, 22, 0, 0)
WatermarkLabel.BackgroundTransparency = 1
WatermarkLabel.Text = "ZxD Hub | 00:00:00"
WatermarkLabel.TextColor3 = Theme.TextPrimary
WatermarkLabel.Font = Enum.Font.GothamMedium
WatermarkLabel.TextSize = 11
WatermarkLabel.TextXAlignment = Enum.TextXAlignment.Left
WatermarkLabel.Parent = Watermark

task.spawn(function()
    while Watermark.Parent do
        WatermarkLabel.Text = "ZxD Hub | " .. os.date("%H:%M:%S")
        task.wait(1)
    end
end)

---------------------------------------------------------
-- QUICK PANEL (mini floating list of currently-active toggles)
---------------------------------------------------------
local QuickPanel = Instance.new("Frame")
QuickPanel.Name = "QuickPanel"
QuickPanel.Size = UDim2.new(0, 170, 0, 0)
QuickPanel.AutomaticSize = Enum.AutomaticSize.Y
QuickPanel.Position = UDim2.new(0, 14, 0, 48)
QuickPanel.BackgroundColor3 = Theme.CardBG
QuickPanel.BackgroundTransparency = 0.05
QuickPanel.Active = true
QuickPanel.Draggable = true
QuickPanel.Visible = false
QuickPanel.ZIndex = 8
QuickPanel.Parent = ScreenGui

local QuickPanelCorner = Instance.new("UICorner")
QuickPanelCorner.CornerRadius = UDim.new(0, 8)
QuickPanelCorner.Parent = QuickPanel

local QuickPanelStroke = Instance.new("UIStroke")
QuickPanelStroke.Color = Theme.Border
QuickPanelStroke.Thickness = 1
QuickPanelStroke.Parent = QuickPanel

local QuickList = Instance.new("UIListLayout")
QuickList.Parent = QuickPanel
QuickList.Padding = UDim.new(0, 2)

local QuickPad = Instance.new("UIPadding")
QuickPad.PaddingTop = UDim.new(0, 6)
QuickPad.PaddingBottom = UDim.new(0, 6)
QuickPad.Parent = QuickPanel

local ActiveQuickRows = {}

local function RegisterQuick(text, offCallback)
    local Row = Instance.new("Frame")
    Row.Size = UDim2.new(1, 0, 0, 26)
    Row.BackgroundTransparency = 1
    Row.ZIndex = 9
    Row.Parent = QuickPanel

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 6, 0, 6)
    Dot.Position = UDim2.new(0, 10, 0.5, -3)
    Dot.BackgroundColor3 = Theme.Accent
    Dot.ZIndex = 9
    Dot.Parent = Row

    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = Dot

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -46, 1, 0)
    Label.Position = UDim2.new(0, 22, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Theme.TextPrimary
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.ZIndex = 9
    Label.Parent = Row

    local CloseX = Instance.new("TextButton")
    CloseX.Size = UDim2.new(0, 20, 0, 20)
    CloseX.Position = UDim2.new(1, -26, 0.5, -10)
    CloseX.BackgroundTransparency = 1
    CloseX.Text = "×"
    CloseX.TextColor3 = Theme.TextMuted
    CloseX.Font = Enum.Font.GothamBold
    CloseX.TextSize = 15
    CloseX.AutoButtonColor = false
    CloseX.ZIndex = 9
    CloseX.Parent = Row

    CloseX.MouseEnter:Connect(function()
        tween(CloseX, {TextColor3 = Theme.TextPrimary}, 0.15)
    end)
    CloseX.MouseLeave:Connect(function()
        tween(CloseX, {TextColor3 = Theme.TextMuted}, 0.15)
    end)
    CloseX.MouseButton1Click:Connect(function()
        pcall(offCallback)
    end)

    ActiveQuickRows[text] = Row
    QuickPanel.Visible = true
end

local function UnregisterQuick(text)
    local Row = ActiveQuickRows[text]
    if Row then
        Row:Destroy()
        ActiveQuickRows[text] = nil
    end
    if next(ActiveQuickRows) == nil then
        QuickPanel.Visible = false
    end
end

---------------------------------------------------------
-- MAIN WINDOW (single floating container, responsive)
---------------------------------------------------------
local MainWindow = Instance.new("Frame")
MainWindow.Name = "MainWindow"
MainWindow.AnchorPoint = Vector2.new(0.5, 0.5)
MainWindow.Size = UDim2.new(0, 430, 0, 320)
MainWindow.Position = UDim2.new(0.5, 0, 0.45, 0)
MainWindow.BackgroundTransparency = 1
MainWindow.BorderSizePixel = 0
MainWindow.Active = true
MainWindow.Draggable = true
MainWindow.Parent = ScreenGui

-- Header (solid floating bar so the "ZxD" name is clearly visible)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 92)
Header.BackgroundColor3 = Theme.CardBG
Header.BorderSizePixel = 0
Header.Parent = MainWindow

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local HeaderStroke = Instance.new("UIStroke")
HeaderStroke.Color = Theme.Border
HeaderStroke.Thickness = 1
HeaderStroke.Parent = Header

local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, -70, 0, 44)
Title.Position = UDim2.new(0, 14, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "ZxD"
Title.TextColor3 = Theme.TextPrimary
Title.TextSize = 19
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextYAlignment = Enum.TextYAlignment.Center
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.new(0, 44, 0, 14)
SubTitle.Position = UDim2.new(0, 14 + 40, 0, 15)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "HUB"
SubTitle.TextColor3 = Theme.TextMuted
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 7)
CloseBtn.BackgroundColor3 = Theme.InactivePill
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.TextMuted
CloseBtn.TextSize = 18
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    tween(CloseBtn, {BackgroundColor3 = Theme.ItemHover, TextColor3 = Theme.TextPrimary}, 0.15)
end)
CloseBtn.MouseLeave:Connect(function()
    tween(CloseBtn, {BackgroundColor3 = Theme.InactivePill, TextColor3 = Theme.TextMuted}, 0.15)
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

---------------------------------------------------------
-- TAB NAV (separated pill tabs with clear gap)
---------------------------------------------------------
local TabNav = Instance.new("ScrollingFrame")
TabNav.Name = "TabNav"
TabNav.Size = UDim2.new(1, -16, 0, 36)
TabNav.Position = UDim2.new(0, 8, 0, 48)
TabNav.BackgroundTransparency = 1
TabNav.ScrollBarThickness = 0
TabNav.CanvasSize = UDim2.new(0, 0, 0, 0)
TabNav.ScrollingDirection = Enum.ScrollingDirection.X
TabNav.Parent = Header

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabNav
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 12)
TabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabNav.CanvasSize = UDim2.new(0, TabLayout.AbsoluteContentSize.X + 8, 0, 0)
end)

local TabUnderline = Instance.new("Frame")
TabUnderline.Name = "TabUnderline"
TabUnderline.AnchorPoint = Vector2.new(0, 0)
TabUnderline.Size = UDim2.new(0, 0, 0, 2)
TabUnderline.Position = UDim2.new(0, 0, 1, 2)
TabUnderline.BackgroundColor3 = Theme.Accent
TabUnderline.BorderSizePixel = 0
TabUnderline.ZIndex = 5
TabUnderline.Parent = TabNav

local TabUnderlineCorner = Instance.new("UICorner")
TabUnderlineCorner.CornerRadius = UDim.new(1, 0)
TabUnderlineCorner.Parent = TabUnderline

---------------------------------------------------------
-- CONTENT VIEWPORT (clips, holds sliding track of tab pages)
---------------------------------------------------------
local Viewport = Instance.new("Frame")
Viewport.Name = "Viewport"
Viewport.Size = UDim2.new(1, -16, 1, -120)
Viewport.Position = UDim2.new(0, 8, 0, 116)
Viewport.BackgroundTransparency = 1
Viewport.ClipsDescendants = true
Viewport.Parent = MainWindow

-- Track holds all tab pages side by side; slides horizontally on tab switch
local Track = Instance.new("Frame")
Track.Name = "Track"
Track.Size = UDim2.new(0, 0, 1, 0) -- width grows per tab added
Track.Position = UDim2.new(0, 0, 0, 0)
Track.BackgroundTransparency = 1
Track.Parent = Viewport

---------------------------------------------------------
-- BUILDER LOGIC
---------------------------------------------------------
local Tabs = {}
local FirstTab = true
local TabCount = 0
local currentIndex = 0

function UI:CreateTab(tabName)
    TabCount = TabCount + 1
    local myIndex = TabCount

    -- Tab Button
    local TabButton = Instance.new("TextButton")
    TabButton.Size = UDim2.new(0, 0, 1, 0)
    TabButton.AutomaticSize = Enum.AutomaticSize.X
    TabButton.BackgroundColor3 = FirstTab and Theme.Accent or Theme.InactivePill
    TabButton.Text = ""
    TabButton.AutoButtonColor = false
    TabButton.Parent = TabNav

    local TabPad = Instance.new("UIPadding")
    TabPad.PaddingLeft = UDim.new(0, 18)
    TabPad.PaddingRight = UDim.new(0, 18)
    TabPad.Parent = TabButton

    local TabCorner = Instance.new("UICorner")
    TabCorner.CornerRadius = UDim.new(1, 0)
    TabCorner.Parent = TabButton

    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, 0, 1, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = tabName
    TabLabel.TextColor3 = FirstTab and Theme.Background or Theme.TextMuted
    TabLabel.Font = Enum.Font.GothamBold
    TabLabel.TextSize = 13
    TabLabel.Parent = TabButton

    local pageIndex = myIndex - 1

    local TabPage = Instance.new("Frame")
    TabPage.Name = tabName .. "Page"
    TabPage.BackgroundTransparency = 1
    TabPage.Parent = Track

    ---------------------------------------------------------
    -- CARD 1: LEFT
    ---------------------------------------------------------
    local LeftCard = Instance.new("Frame")
    LeftCard.Name = "LeftCard"
    LeftCard.Size = UDim2.new(0.5, -7, 1, 0)
    LeftCard.Position = UDim2.new(0, 0, 0, 0)
    LeftCard.BackgroundColor3 = Theme.CardBG
    LeftCard.Parent = TabPage

    local LeftCardCorner = Instance.new("UICorner")
    LeftCardCorner.CornerRadius = UDim.new(0, 12)
    LeftCardCorner.Parent = LeftCard

    local LeftCardStroke = Instance.new("UIStroke")
    LeftCardStroke.Color = Theme.Border
    LeftCardStroke.Thickness = 1
    LeftCardStroke.Parent = LeftCard

    local LeftScroll = Instance.new("ScrollingFrame")
    LeftScroll.Size = UDim2.new(1, -24, 1, -20)
    LeftScroll.Position = UDim2.new(0, 12, 0, 10)
    LeftScroll.BackgroundTransparency = 1
    LeftScroll.ScrollBarThickness = 2
    LeftScroll.ScrollBarImageColor3 = Theme.AccentDim
    LeftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    LeftScroll.Parent = LeftCard

    local LeftList = Instance.new("UIListLayout")
    LeftList.Parent = LeftScroll
    LeftList.Padding = UDim.new(0, 14)

    LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        LeftScroll.CanvasSize = UDim2.new(0, 0, 0, LeftList.AbsoluteContentSize.Y + 4)
    end)

    ---------------------------------------------------------
    -- CARD 2: RIGHT
    ---------------------------------------------------------
    local RightCard = Instance.new("Frame")
    RightCard.Name = "RightCard"
    RightCard.Size = UDim2.new(0.5, -7, 1, 0)
    RightCard.Position = UDim2.new(0.5, 7, 0, 0)
    RightCard.BackgroundColor3 = Theme.CardBG
    RightCard.Parent = TabPage

    local RightCardCorner = Instance.new("UICorner")
    RightCardCorner.CornerRadius = UDim.new(0, 12)
    RightCardCorner.Parent = RightCard

    local RightCardStroke = Instance.new("UIStroke")
    RightCardStroke.Color = Theme.Border
    RightCardStroke.Thickness = 1
    RightCardStroke.Parent = RightCard

    local RightScroll = Instance.new("ScrollingFrame")
    RightScroll.Size = UDim2.new(1, -24, 1, -20)
    RightScroll.Position = UDim2.new(0, 12, 0, 10)
    RightScroll.BackgroundTransparency = 1
    RightScroll.ScrollBarThickness = 2
    RightScroll.ScrollBarImageColor3 = Theme.AccentDim
    RightScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    RightScroll.Parent = RightCard

    local RightList = Instance.new("UIListLayout")
    RightList.Parent = RightScroll
    RightList.Padding = UDim.new(0, 14)

    RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        RightScroll.CanvasSize = UDim2.new(0, 0, 0, RightList.AbsoluteContentSize.Y + 4)
    end)

    local TabObj = { Button = TabButton, Label = TabLabel, Page = TabPage, Index = pageIndex }

    local function goToTab()
        for _, t in pairs(Tabs) do
            tween(t.Button, {BackgroundColor3 = Theme.InactivePill}, 0.18)
            tween(t.Label, {TextColor3 = Theme.TextMuted}, 0.18)
        end
        tween(TabButton, {BackgroundColor3 = Theme.Accent}, 0.18)
        tween(TabLabel, {TextColor3 = Theme.Background}, 0.18)
        tween(TabUnderline, {
            Position = UDim2.new(0, TabButton.AbsolutePosition.X - TabNav.AbsolutePosition.X + TabNav.CanvasPosition.X, 1, 2),
            Size = UDim2.new(0, TabButton.AbsoluteSize.X, 0, 2)
        }, 0.28, Enum.EasingStyle.Quint)

        currentIndex = pageIndex
        local targetX = -(Viewport.AbsoluteSize.X * pageIndex)
        tween(Track, {Position = UDim2.new(0, targetX, 0, 0)}, 0.32, Enum.EasingStyle.Quint)
    end

    TabButton.MouseButton1Click:Connect(goToTab)

    table.insert(Tabs, TabObj)

    if FirstTab then
        task.defer(function()
            task.wait(0.05)
            TabUnderline.Position = UDim2.new(0, TabButton.AbsolutePosition.X - TabNav.AbsolutePosition.X, 1, 2)
            TabUnderline.Size = UDim2.new(0, TabButton.AbsoluteSize.X, 0, 2)
        end)
    end
    FirstTab = false

    ---------------------------------------------------------
    -- ELEMENT BUILDERS
    ---------------------------------------------------------
    local Elements = {}

    local function GetTargetScroll(side)
        return (side and string.lower(side) == "right") and RightScroll or LeftScroll
    end

    function Elements:AddSection(text, side)
        local Target = GetTargetScroll(side)
        local Sec = Instance.new("TextLabel")
        Sec.Size = UDim2.new(1, 0, 0, 20)
        Sec.BackgroundTransparency = 1
        Sec.Text = string.upper(text)
        Sec.TextColor3 = Theme.TextMuted
        Sec.Font = Enum.Font.GothamBold
        Sec.TextSize = 12
        Sec.TextXAlignment = Enum.TextXAlignment.Left
        Sec.Parent = Target

        local Underline = Instance.new("Frame")
        Underline.Size = UDim2.new(0, 14, 0, 2)
        Underline.Position = UDim2.new(0, 0, 1, 2)
        Underline.BackgroundColor3 = Theme.Accent
        Underline.BorderSizePixel = 0
        Underline.Parent = Sec

        local UnderCorner = Instance.new("UICorner")
        UnderCorner.CornerRadius = UDim.new(1, 0)
        UnderCorner.Parent = Underline
    end

    function Elements:CreateToggle(text, defaultState, side, callback)
        local Target = GetTargetScroll(side)

        local Item = Instance.new("TextButton")
        Item.Size = UDim2.new(1, 0, 0, 42)
        Item.BackgroundColor3 = Theme.InactivePill
        Item.Text = ""
        Item.AutoButtonColor = false
        Item.Parent = Target

        local ItemCorner = Instance.new("UICorner")
        ItemCorner.CornerRadius = UDim.new(0, 8)
        ItemCorner.Parent = Item

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(1, -54, 1, 0)
        Label.Position = UDim2.new(0, 14, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.TextColor3 = Theme.TextPrimary
        Label.Font = Enum.Font.GothamMedium
        Label.TextSize = 12
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.TextTruncate = Enum.TextTruncate.AtEnd
        Label.Parent = Item

        local Indicator = Instance.new("Frame")
        Indicator.Size = UDim2.new(0, 34, 0, 18)
        Indicator.Position = UDim2.new(1, -44, 0.5, -9)
        Indicator.BackgroundColor3 = defaultState and Theme.Accent or Theme.CardBG
        Indicator.Parent = Item

        local IndCorner = Instance.new("UICorner")
        IndCorner.CornerRadius = UDim.new(1, 0)
        IndCorner.Parent = Indicator

        local IndStroke = Instance.new("UIStroke")
        IndStroke.Color = Theme.Border
        IndStroke.Thickness = 1
        IndStroke.Parent = Indicator

        local Dot = Instance.new("Frame")
        Dot.Size = UDim2.new(0, 14, 0, 14)
        Dot.Position = defaultState and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        Dot.BackgroundColor3 = defaultState and Theme.Background or Theme.TextMuted
        Dot.Parent = Indicator

        local DotCorner = Instance.new("UICorner")
        DotCorner.CornerRadius = UDim.new(1, 0)
        DotCorner.Parent = Dot

        local PulseDot = Instance.new("Frame")
        PulseDot.Size = UDim2.new(0, 6, 0, 6)
        PulseDot.Position = UDim2.new(1, -12, 0, 6)
        PulseDot.BackgroundColor3 = Theme.Accent
        PulseDot.BackgroundTransparency = defaultState and 0 or 1
        PulseDot.ZIndex = 3
        PulseDot.Parent = Item

        local PulseDotCorner = Instance.new("UICorner")
        PulseDotCorner.CornerRadius = UDim.new(1, 0)
        PulseDotCorner.Parent = PulseDot

        local pulseLoop = nil
        local function startPulse()
            if pulseLoop then return end
            pulseLoop = task.spawn(function()
                while true do
                    tween(PulseDot, {Size = UDim2.new(0, 9, 0, 9), BackgroundTransparency = 0.5}, 0.6, Enum.EasingStyle.Sine)
                    task.wait(0.6)
                    tween(PulseDot, {Size = UDim2.new(0, 6, 0, 6), BackgroundTransparency = 0}, 0.6, Enum.EasingStyle.Sine)
                    task.wait(0.6)
                end
            end)
        end
        local function stopPulse()
            if pulseLoop then
                task.cancel(pulseLoop)
                pulseLoop = nil
            end
            tween(PulseDot, {Size = UDim2.new(0, 6, 0, 6), BackgroundTransparency = 1}, 0.2)
        end
        if defaultState then startPulse() end

        local enabled = defaultState or false

        local function setEnabled(newState, fromQuickPanel)
            enabled = newState
            tween(Indicator, {BackgroundColor3 = enabled and Theme.Accent or Theme.CardBG}, 0.18)
            tween(Dot, {
                Position = enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7),
                BackgroundColor3 = enabled and Theme.Background or Theme.TextMuted
            }, 0.18)
            if enabled then
                startPulse()
                RegisterQuick(text, function() setEnabled(false) end)
            else
                stopPulse()
                UnregisterQuick(text)
            end
            if not fromQuickPanel then
                ShowToast(text .. (enabled and ": ON" or ": OFF"), enabled)
            end
            pcall(callback, enabled)
        end

        Item.MouseEnter:Connect(function()
            tween(Item, {BackgroundColor3 = Theme.ItemHover}, 0.15)
        end)
        Item.MouseLeave:Connect(function()
            tween(Item, {BackgroundColor3 = Theme.InactivePill}, 0.15)
        end)

        Item.MouseButton1Click:Connect(function()
            setEnabled(not enabled)
        end)

        if defaultState then
            RegisterQuick(text, function() setEnabled(false) end)
        end
    end

    function Elements:CreateSlider(text, min, max, default, side, callback)
        local Target = GetTargetScroll(side)

        local Item = Instance.new("Frame")
        Item.Size = UDim2.new(1, 0, 0, 54)
        Item.BackgroundColor3 = Theme.InactivePill
        Item.Parent = Target

        local ItemCorner = Instance.new("UICorner")
        ItemCorner.CornerRadius = UDim.new(0, 10)
        ItemCorner.Parent = Item

        local Padding = Instance.new("UIPadding")
        Padding.PaddingLeft = UDim.new(0, 14)
        Padding.PaddingRight = UDim.new(0, 14)
        Padding.PaddingTop = UDim.new(0, 10)
        Padding.Parent = Item

        local TitleLbl = Instance.new("TextLabel")
        TitleLbl.Size = UDim2.new(1, 0, 0, 18)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = text
        TitleLbl.TextColor3 = Theme.TextPrimary
        TitleLbl.Font = Enum.Font.GothamMedium
        TitleLbl.TextSize = 12
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
        TitleLbl.TextTruncate = Enum.TextTruncate.AtEnd
        TitleLbl.Parent = Item

        local ValueLbl = Instance.new("TextLabel")
        ValueLbl.Size = UDim2.new(0, 50, 0, 18)
        ValueLbl.Position = UDim2.new(1, -50, 0, 0)
        ValueLbl.BackgroundTransparency = 1
        ValueLbl.Text = tostring(default)
        ValueLbl.TextColor3 = Theme.Accent
        ValueLbl.Font = Enum.Font.GothamBold
        ValueLbl.TextSize = 13
        ValueLbl.TextXAlignment = Enum.TextXAlignment.Right
        ValueLbl.Parent = Item

        local SliderBar = Instance.new("TextButton")
        SliderBar.Size = UDim2.new(1, 0, 0, 6)
        SliderBar.Position = UDim2.new(0, 0, 0, 32)
        SliderBar.BackgroundColor3 = Theme.CardBG
        SliderBar.Text = ""
        SliderBar.AutoButtonColor = false
        SliderBar.Parent = Item

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = SliderBar

        local Fill = Instance.new("Frame")
        Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
        Fill.BackgroundColor3 = Theme.Accent
        Fill.BorderSizePixel = 0
        Fill.Parent = SliderBar

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 16, 0, 16)
        Knob.AnchorPoint = Vector2.new(0.5, 0.5)
        Knob.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
        Knob.BackgroundColor3 = Theme.Accent
        Knob.Parent = SliderBar

        local KnobCorner = Instance.new("UICorner")
        KnobCorner.CornerRadius = UDim.new(1, 0)
        KnobCorner.Parent = Knob

        local dragging = false

        local function update(input)
            local pos = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
            local val = math.floor(min + ((max - min) * pos))
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            Knob.Position = UDim2.new(pos, 0, 0.5, 0)
            ValueLbl.Text = tostring(val)
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
        Btn.Size = UDim2.new(1, 0, 0, 40)
        Btn.BackgroundColor3 = Theme.InactivePill
        Btn.Text = text
        Btn.TextColor3 = Theme.TextPrimary
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 13
        Btn.AutoButtonColor = false
        Btn.Parent = Target

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, 8)
        Corner.Parent = Btn

        local Stroke = Instance.new("UIStroke")
        Stroke.Color = Theme.Border
        Stroke.Thickness = 1
        Stroke.Parent = Btn

        Btn.MouseEnter:Connect(function()
            tween(Btn, {BackgroundColor3 = Theme.ItemHover}, 0.15)
        end)
        Btn.MouseLeave:Connect(function()
            tween(Btn, {BackgroundColor3 = Theme.InactivePill}, 0.15)
        end)
        Btn.MouseButton1Click:Connect(function()
            tween(Btn, {BackgroundColor3 = Theme.Accent}, 0.08)
            task.delay(0.08, function()
                tween(Btn, {BackgroundColor3 = Theme.ItemHover}, 0.15)
            end)
            ShowToast(text, true)
            pcall(callback)
        end)
    end

    return Elements
end

---------------------------------------------------------
-- FINAL SIZING PASS (once all tabs are declared, main.lua finishes running
-- this ensures Track + Pages have correct pixel widths, then snaps to tab 1)
---------------------------------------------------------
task.defer(function()
    local w = Viewport.AbsoluteSize.X
    local tries = 0
    while w <= 0 and tries < 40 do
        task.wait(0.05)
        w = Viewport.AbsoluteSize.X
        tries = tries + 1
    end
    if w <= 0 then w = 400 end -- fallback so pages are never zero-width

    Track.Size = UDim2.new(0, w * math.max(TabCount, 1), 1, 0)
    for _, t in pairs(Tabs) do
        t.Page.Size = UDim2.new(0, w, 1, 0)
        t.Page.Position = UDim2.new(0, w * t.Index, 0, 0)
    end
    Track.Position = UDim2.new(0, 0, 0, 0)
end)

MobileBtn.MouseButton1Click:Connect(function()
    local isVis = not MainWindow.Visible
    MainWindow.Visible = isVis
end)

UI.Container = MainWindow
return UI
