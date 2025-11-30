--[[
    Modern Minimalistic UI Library - Fixed Edition
    Clean black transparent design with customizable accent color
    Full tweens, smooth animations, and color picker included
]]

local Library = {}
Library.__index = Library

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Default Theme
local Theme = {
    Primary = Color3.fromRGB(0, 0, 0),
    Secondary = Color3.fromRGB(15, 15, 15),
    Tertiary = Color3.fromRGB(25, 25, 25),
    Accent = Color3.fromRGB(100, 150, 255),
    Text = Color3.fromRGB(240, 240, 240),
    TextSecondary = Color3.fromRGB(160, 160, 160),
    Border = Color3.fromRGB(40, 40, 40)
}

-- Utility Functions
local function Tween(object, properties, duration, easing)
    duration = duration or 0.2
    easing = easing or Enum.EasingStyle.Quad
    local tween = TweenService:Create(object, TweenInfo.new(duration, easing, Enum.EasingDirection.Out), properties)
    tween:Play()
    return tween
end

local function MakeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            Tween(frame, {Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)}, 0.05)
        end
    end)
end

-- Notification System
local NotificationHolder = nil

local function CreateNotificationHolder(screenGui)
    if NotificationHolder and NotificationHolder.Parent then return NotificationHolder end
    
    NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "NotificationHolder"
    NotificationHolder.Size = UDim2.new(0, 300, 1, -20)
    NotificationHolder.Position = UDim2.new(1, -310, 0, 10)
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Parent = screenGui
    
    local Layout = Instance.new("UIListLayout")
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Padding = UDim.new(0, 8)
    Layout.VerticalAlignment = Enum.VerticalAlignment.Top
    Layout.Parent = NotificationHolder
    
    return NotificationHolder
end

local function Notify(screenGui, title, message, duration, notifType)
    duration = duration or 3
    notifType = notifType or "info"
    
    local holder = CreateNotificationHolder(screenGui)
    
    local colors = {
        info = Color3.fromRGB(100, 150, 255),
        success = Color3.fromRGB(80, 200, 120),
        warning = Color3.fromRGB(255, 180, 60),
        error = Color3.fromRGB(255, 80, 80)
    }
    
    local accentColor = colors[notifType] or colors.info
    
    local Notification = Instance.new("Frame")
    Notification.Size = UDim2.new(1, 0, 0, 0)
    Notification.BackgroundColor3 = Theme.Primary
    Notification.BackgroundTransparency = 0.1
    Notification.BorderSizePixel = 0
    Notification.ClipsDescendants = true
    Notification.Parent = holder
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Notification
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = accentColor
    Stroke.Thickness = 1
    Stroke.Transparency = 0.5
    Stroke.Parent = Notification
    
    local AccentBar = Instance.new("Frame")
    AccentBar.Size = UDim2.new(0, 3, 1, 0)
    AccentBar.BackgroundColor3 = accentColor
    AccentBar.BorderSizePixel = 0
    AccentBar.Parent = Notification
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 20)
    TitleLabel.Position = UDim2.new(0, 15, 0, 10)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.TextSize = 13
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notification
    
    local MessageLabel = Instance.new("TextLabel")
    MessageLabel.Size = UDim2.new(1, -20, 0, 30)
    MessageLabel.Position = UDim2.new(0, 15, 0, 28)
    MessageLabel.BackgroundTransparency = 1
    MessageLabel.Text = message
    MessageLabel.TextColor3 = Theme.TextSecondary
    MessageLabel.TextSize = 12
    MessageLabel.Font = Enum.Font.Gotham
    MessageLabel.TextXAlignment = Enum.TextXAlignment.Left
    MessageLabel.TextWrapped = true
    MessageLabel.Parent = Notification
    
    Tween(Notification, {Size = UDim2.new(1, 0, 0, 70)}, 0.3)
    
    task.delay(duration, function()
        Tween(Notification, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}, 0.3)
        task.wait(0.3)
        if Notification and Notification.Parent then
            Notification:Destroy()
        end
    end)
end

-- Main Library Functions
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "UI Library"
    local windowSize = config.Size or UDim2.new(0, 520, 0, 600)
    local accentColor = config.AccentColor or Theme.Accent
    
    Theme.Accent = accentColor
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUILibrary_" .. tostring(math.random(1000, 9999))
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = windowSize
    MainFrame.Position = UDim2.new(0.5, -windowSize.X.Offset/2, 0.5, -windowSize.Y.Offset/2)
    MainFrame.BackgroundColor3 = Theme.Primary
    MainFrame.BackgroundTransparency = 0.15
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Theme.Border
    Stroke.Thickness = 1
    Stroke.Transparency = 0.3
    Stroke.Parent = MainFrame
    
    -- Top Bar
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Theme.Secondary
    TopBar.BackgroundTransparency = 0.5
    TopBar.BorderSizePixel = 0
    TopBar.ClipsDescendants = true
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    -- Cover bottom corners of TopBar
    local TopBarCover = Instance.new("Frame")
    TopBarCover.Size = UDim2.new(1, 0, 0, 15)
    TopBarCover.Position = UDim2.new(0, 0, 1, -15)
    TopBarCover.BackgroundColor3 = Theme.Secondary
    TopBarCover.BackgroundTransparency = 0.5
    TopBarCover.BorderSizePixel = 0
    TopBarCover.Parent = TopBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -80, 1, 0)
    Title.Position = UDim2.new(0, 20, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = windowName
    Title.TextColor3 = Theme.Text
    Title.TextSize = 16
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.ZIndex = 2
    Title.Parent = TopBar
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 32, 0, 32)
    CloseButton.Position = UDim2.new(1, -42, 0.5, -16)
    CloseButton.BackgroundColor3 = Theme.Tertiary
    CloseButton.BackgroundTransparency = 0.5
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Theme.Text
    CloseButton.TextSize = 22
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.ZIndex = 2
    CloseButton.Parent = TopBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 6)
    CloseCorner.Parent = CloseButton
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(220, 80, 80), BackgroundTransparency = 0.7}, 0.15)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Theme.Tertiary, BackgroundTransparency = 0.5}, 0.15)
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 130, 1, -50)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundColor3 = Theme.Secondary
    TabContainer.BackgroundTransparency = 0.7
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabLayout = Instance.new("UIListLayout")
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.Parent = TabContainer
    
    local TabPadding = Instance.new("UIPadding")
    TabPadding.PaddingLeft = UDim.new(0, 8)
    TabPadding.PaddingRight = UDim.new(0, 8)
    TabPadding.PaddingTop = UDim.new(0, 8)
    TabPadding.PaddingBottom = UDim.new(0, 8)
    TabPadding.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -130, 1, -50)
    ContentContainer.Position = UDim2.new(0, 130, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = MainFrame
    
    MakeDraggable(MainFrame, TopBar)
    
    local Window = {}
    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    Window.TabContainer = TabContainer
    Window.ContentContainer = ContentContainer
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Theme = Theme
    
    function Window:Notify(title, message, duration, notifType)
        Notify(ScreenGui, title, message, duration, notifType)
    end
    
    function Window:SetAccentColor(color)
        Theme.Accent = color
        for _, tab in pairs(self.Tabs) do
            for _, element in pairs(tab.Elements) do
                if element.Update then
                    element:Update()
                end
            end
        end
    end
    
    function Window:CreateTab(tabName)
        local Tab = {}
        Tab.Name = tabName
        Tab.Elements = {}
        
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(1, 0, 0, 40)
        TabButton.BackgroundColor3 = Theme.Tertiary
        TabButton.BackgroundTransparency = 0.8
        TabButton.Text = tabName
        TabButton.TextColor3 = Theme.TextSecondary
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.Gotham
        TabButton.BorderSizePixel = 0
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 8)
        TabCorner.Parent = TabButton
        
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "_Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Theme.Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentLayout = Instance.new("UIListLayout")
        ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ContentLayout.Padding = UDim.new(0, 10)
        ContentLayout.Parent = TabContent
        
        local ContentPadding = Instance.new("UIPadding")
        ContentPadding.PaddingLeft = UDim.new(0, 15)
        ContentPadding.PaddingRight = UDim.new(0, 15)
        ContentPadding.PaddingTop = UDim.new(0, 10)
        ContentPadding.PaddingBottom = UDim.new(0, 10)
        ContentPadding.Parent = TabContent
        
        ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 20)
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                tab.Content.Visible = false
                Tween(tab.Button, {
                    BackgroundTransparency = 0.8,
                    TextColor3 = Theme.TextSecondary
                }, 0.2)
            end
            
            TabContent.Visible = true
            Window.CurrentTab = Tab
            Tween(TabButton, {
                BackgroundTransparency = 0,
                TextColor3 = Theme.Accent
            }, 0.2)
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.5}, 0.15)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundTransparency = 0.8}, 0.15)
            end
        end)
        
        -- Button Element
        function Tab:AddButton(config)
            config = config or {}
            local buttonText = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(1, 0, 0, 38)
            ButtonFrame.BackgroundColor3 = Theme.Tertiary
            ButtonFrame.BackgroundTransparency = 0.7
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = Theme.Border
            ButtonStroke.Thickness = 1
            ButtonStroke.Transparency = 0.5
            ButtonStroke.Parent = ButtonFrame
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = ButtonFrame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = buttonText
            Button.TextColor3 = Theme.Text
            Button.TextSize = 13
            Button.Font = Enum.Font.Gotham
            Button.Parent = ButtonFrame
            
            Button.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.5}, 0.15)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Theme.Tertiary, BackgroundTransparency = 0.7}, 0.15)
            end)
            
            Button.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundTransparency = 0.3}, 0.1)
                task.wait(0.1)
                Tween(ButtonFrame, {BackgroundTransparency = 0.5}, 0.1)
                callback()
            end)
            
            local element = {Update = function() end}
            table.insert(Tab.Elements, element)
            return Button
        end
        
        -- Toggle Element
        function Tab:AddToggle(config)
            config = config or {}
            local toggleText = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, 0, 0, 38)
            ToggleFrame.BackgroundColor3 = Theme.Tertiary
            ToggleFrame.BackgroundTransparency = 0.7
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Color = Theme.Border
            ToggleStroke.Thickness = 1
            ToggleStroke.Transparency = 0.5
            ToggleStroke.Parent = ToggleFrame
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 8)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.TextSize = 13
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 44, 0, 22)
            ToggleButton.Position = UDim2.new(1, -52, 0.5, -11)
            ToggleButton.BackgroundColor3 = Theme.Secondary
            ToggleButton.BackgroundTransparency = 0.5
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local ToggleCornerButton = Instance.new("UICorner")
            ToggleCornerButton.CornerRadius = UDim.new(1, 0)
            ToggleCornerButton.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 18, 0, 18)
            ToggleCircle.Position = UDim2.new(0, 2, 0.5, -9)
            ToggleCircle.BackgroundColor3 = Theme.Text
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = default
            
            local function UpdateToggle()
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.3}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -20, 0.5, -9)}, 0.2)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Theme.Secondary, BackgroundTransparency = 0.5}, 0.2)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 2, 0.5, -9)}, 0.2)
                end
            end
            
            UpdateToggle()
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                UpdateToggle()
                callback(toggled)
            end)
            
            ToggleFrame.MouseEnter:Connect(function()
                Tween(ToggleFrame, {BackgroundTransparency = 0.5}, 0.15)
            end)
            
            ToggleFrame.MouseLeave:Connect(function()
                Tween(ToggleFrame, {BackgroundTransparency = 0.7}, 0.15)
            end)
            
            local element = {
                SetValue = function(self, value)
                    toggled = value
                    UpdateToggle()
                    callback(toggled)
                end,
                Update = function() end
            }
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- Slider Element
        function Tab:AddSlider(config)
            config = config or {}
            local sliderText = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or min
            local increment = config.Increment or 1
            local callback = config.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, 0, 0, 60)
            SliderFrame.BackgroundColor3 = Theme.Tertiary
            SliderFrame.BackgroundTransparency = 0.7
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderStroke = Instance.new("UIStroke")
            SliderStroke.Color = Theme.Border
            SliderStroke.Thickness = 1
            SliderStroke.Transparency = 0.5
            SliderStroke.Parent = SliderFrame
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 8)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -80, 0, 20)
            SliderLabel.Position = UDim2.new(0, 15, 0, 8)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderText
            SliderLabel.TextColor3 = Theme.Text
            SliderLabel.TextSize = 13
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderValue = Instance.new("TextLabel")
            SliderValue.Size = UDim2.new(0, 60, 0, 20)
            SliderValue.Position = UDim2.new(1, -70, 0, 8)
            SliderValue.BackgroundTransparency = 1
            SliderValue.Text = tostring(default)
            SliderValue.TextColor3 = Theme.Accent
            SliderValue.TextSize = 12
            SliderValue.Font = Enum.Font.GothamBold
            SliderValue.TextXAlignment = Enum.TextXAlignment.Right
            SliderValue.Parent = SliderFrame
            
            local SliderBackground = Instance.new("Frame")
            SliderBackground.Size = UDim2.new(1, -30, 0, 6)
            SliderBackground.Position = UDim2.new(0, 15, 0.5, 5)
            SliderBackground.BackgroundColor3 = Theme.Secondary
            SliderBackground.BackgroundTransparency = 0.5
            SliderBackground.BorderSizePixel = 0
            SliderBackground.Parent = SliderFrame
            
            local SliderBgCorner = Instance.new("UICorner")
            SliderBgCorner.CornerRadius = UDim.new(1, 0)
            SliderBgCorner.Parent = SliderBackground
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new(0, 0, 1, 0)
            SliderFill.BackgroundColor3 = Theme.Accent
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBackground
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local SliderButton = Instance.new("TextButton")
            SliderButton.Size = UDim2.new(1, 0, 1, 0)
            SliderButton.BackgroundTransparency = 1
            SliderButton.Text = ""
            SliderButton.Parent = SliderBackground
            
            local dragging = false
            local value = default
            
            local function UpdateSlider(input)
                local pos = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
                value = math.floor((min + (max - min) * pos) / increment + 0.5) * increment
                value = math.clamp(value, min, max)
                
                SliderValue.Text = tostring(value)
                Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)}, 0.05)
                callback(value)
            end
            
            SliderButton.MouseButton1Down:Connect(function()
                dragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    UpdateSlider(input)
                end
            end)
            
            SliderButton.MouseButton1Click:Connect(function()
                local mouse = UserInputService:GetMouseLocation()
                UpdateSlider({Position = Vector2.new(mouse.X, mouse.Y)})
            end)
            
            local initialPos = (default - min) / (max - min)
            SliderFill.Size = UDim2.new(initialPos, 0, 1, 0)
            
            SliderFrame.MouseEnter:Connect(function()
                Tween(SliderFrame, {BackgroundTransparency = 0.5}, 0.15)
            end)
            
            SliderFrame.MouseLeave:Connect(function()
                Tween(SliderFrame, {BackgroundTransparency = 0.7}, 0.15)
            end)
            
            local element = {
                SetValue = function(self, val)
                    value = math.clamp(val, min, max)
                    local pos = (value - min) / (max - min)
                    SliderValue.Text = tostring(value)
                    Tween(SliderFill, {Size = UDim2.new(pos, 0, 1, 0)})
                    callback(value)
                end,
                Update = function() end
            }
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- Dropdown Element
        function Tab:AddDropdown(config)
            config = config or {}
            local dropdownText = config.Name or "Dropdown"
            local options = config.Options or {"Option 1", "Option 2"}
            local default = config.Default or options[1]
            local callback = config.Callback or function() end
            
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 38)
            DropdownFrame.BackgroundColor3 = Theme.Tertiary
            DropdownFrame.BackgroundTransparency = 0.7
            DropdownFrame.BorderSizePixel = 0
            DropdownFrame.ClipsDescendants = false
            DropdownFrame.ZIndex = 2
            DropdownFrame.Parent = TabContent
            
            local DropdownStroke = Instance.new("UIStroke")
            DropdownStroke.Color = Theme.Border
            DropdownStroke.Thickness = 1
            DropdownStroke.Transparency = 0.5
            DropdownStroke.Parent = DropdownFrame
            
            local DropdownCorner = Instance.new("UICorner")
            DropdownCorner.CornerRadius = UDim.new(0, 8)
            DropdownCorner.Parent = DropdownFrame
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Size = UDim2.new(0.5, -10, 1, 0)
            DropdownLabel.Position = UDim2.new(0, 15, 0, 0)
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Text = dropdownText
            DropdownLabel.TextColor3 = Theme.Text
            DropdownLabel.TextSize = 13
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.ZIndex = 3
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Size = UDim2.new(1, 0, 1, 0)
            DropdownButton.BackgroundTransparency = 1
            DropdownButton.Text = ""
            DropdownButton.ZIndex = 3
            DropdownButton.Parent = DropdownFrame
            
            local DropdownValue = Instance.new("TextLabel")
            DropdownValue.Size = UDim2.new(0.5, -40, 1, 0)
            DropdownValue.Position = UDim2.new(0.5, 0, 0, 0)
            DropdownValue.BackgroundTransparency = 1
            DropdownValue.Text = default
            DropdownValue.TextColor3 = Theme.Accent
            DropdownValue.TextSize = 12
            DropdownValue.Font = Enum.Font.GothamBold
            DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
            DropdownValue.ZIndex = 3
            DropdownValue.Parent = DropdownFrame
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 1, 0)
            DropdownArrow.Position = UDim2.new(1, -25, 0, 0)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Theme.TextSecondary
            DropdownArrow.TextSize = 10
            DropdownArrow.Font = Enum.Font.Gotham
            DropdownArrow.ZIndex = 3
            DropdownArrow.Parent = DropdownFrame
            
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
            OptionsFrame.Position = UDim2.new(0, 0, 1, 4)
            OptionsFrame.BackgroundColor3 = Theme.Secondary
            OptionsFrame.BackgroundTransparency = 0.1
            OptionsFrame.BorderSizePixel = 0
            OptionsFrame.ClipsDescendants = true
            OptionsFrame.Visible = false
            OptionsFrame.ZIndex = 10
            OptionsFrame.Parent = DropdownFrame
            
            local OptionsStroke = Instance.new("UIStroke")
            OptionsStroke.Color = Theme.Border
            OptionsStroke.Thickness = 1
            OptionsStroke.Transparency = 0.5
            OptionsStroke.Parent = OptionsFrame
            
            local OptionsCorner = Instance.new("UICorner")
            OptionsCorner.CornerRadius = UDim.new(0, 8)
            OptionsCorner.Parent = OptionsFrame
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Padding = UDim.new(0, 4)
            OptionsLayout.Parent = OptionsFrame
            
            local OptionsPadding = Instance.new("UIPadding")
            OptionsPadding.PaddingLeft = UDim.new(0, 6)
            OptionsPadding.PaddingRight = UDim.new(0, 6)
            OptionsPadding.PaddingTop = UDim.new(0, 6)
            OptionsPadding.PaddingBottom = UDim.new(0, 6)
            OptionsPadding.Parent = OptionsFrame
            
            local isOpen = false
            local currentValue = default
            
            local function CreateOption(optionText)
                local OptionButton = Instance.new("TextButton")
                OptionButton.Size = UDim2.new(1, 0, 0, 32)
                OptionButton.BackgroundColor3 = Theme.Tertiary
                OptionButton.BackgroundTransparency = currentValue == optionText and 0.2 or 0.6
                OptionButton.Text = optionText
                OptionButton.TextColor3 = currentValue == optionText and Theme.Accent or Theme.Text
                OptionButton.TextSize = 12
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.BorderSizePixel = 0
                OptionButton.ZIndex = 11
                OptionButton.Parent = OptionsFrame
                
                local OptionCorner = Instance.new("UICorner")
                OptionCorner.CornerRadius = UDim.new(0, 6)
                OptionCorner.Parent = OptionButton
                
                OptionButton.MouseEnter:Connect(function()
                    if currentValue ~= optionText then
                        Tween(OptionButton, {BackgroundTransparency = 0.4}, 0.15)
                    end
                end)
                
                OptionButton.MouseLeave:Connect(function()
                    if currentValue ~= optionText then
                        Tween(OptionButton, {BackgroundTransparency = 0.6}, 0.15)
                    end
                end)
                
                OptionButton.MouseButton1Click:Connect(function()
                    currentValue = optionText
                    DropdownValue.Text = optionText
                    
                    for _, child in pairs(OptionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            Tween(child, {BackgroundTransparency = 0.6, TextColor3 = Theme.Text}, 0.15)
                        end
                    end
                    
                    Tween(OptionButton, {BackgroundTransparency = 0.2, TextColor3 = Theme.Accent}, 0.15)
                    
                    isOpen = false
                    Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    task.wait(0.2)
                    OptionsFrame.Visible = false
                    
                    callback(optionText)
                end)
            end
            
            for _, option in ipairs(options) do
                CreateOption(option)
            end
            
            DropdownButton.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                
                if isOpen then
                    OptionsFrame.Visible = true
                    local targetHeight = #options * 36 + (#options - 1) * 4 + 12
                    Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 180}, 0.2)
                else
                    Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    task.wait(0.2)
                    OptionsFrame.Visible = false
                end
            end)
            
            DropdownFrame.MouseEnter:Connect(function()
                Tween(DropdownFrame, {BackgroundTransparency = 0.5}, 0.15)
            end)
            
            DropdownFrame.MouseLeave:Connect(function()
                Tween(DropdownFrame, {BackgroundTransparency = 0.7}, 0.15)
            end)
            
            local element = {
                SetValue = function(self, val)
                    currentValue = val
                    DropdownValue.Text = val
                    callback(val)
                end,
                Refresh = function(self, newOptions)
                    for _, child in pairs(OptionsFrame:GetChildren()) do
                        if child:IsA("TextButton") then
                            child:Destroy()
                        end
                    end
                    options = newOptions
                    for _, option in ipairs(options) do
                        CreateOption(option)
                    end
                end,
                Update = function() end
            }
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- Color Picker (Fixed - no spam, proper saturation)
        function Tab:AddColorPicker(config)
            config = config or {}
            local colorText = config.Name or "Color"
            local default = config.Default or Color3.fromRGB(100, 150, 255)
            local callback = config.Callback or function() end
            
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Size = UDim2.new(1, 0, 0, 110)
            ColorFrame.BackgroundColor3 = Theme.Tertiary
            ColorFrame.BackgroundTransparency = 0.7
            ColorFrame.BorderSizePixel = 0
            ColorFrame.Parent = TabContent
            
            local ColorStroke = Instance.new("UIStroke")
            ColorStroke.Color = Theme.Border
            ColorStroke.Thickness = 1
            ColorStroke.Transparency = 0.5
            ColorStroke.Parent = ColorFrame
            
            local ColorCorner = Instance.new("UICorner")
            ColorCorner.CornerRadius = UDim.new(0, 8)
            ColorCorner.Parent = ColorFrame
            
            local ColorLabel = Instance.new("TextLabel")
            ColorLabel.Size = UDim2.new(1, -90, 0, 20)
            ColorLabel.Position = UDim2.new(0, 15, 0, 10)
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Text = colorText
            ColorLabel.TextColor3 = Theme.Text
            ColorLabel.TextSize = 13
            ColorLabel.Font = Enum.Font.Gotham
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
            ColorLabel.Parent = ColorFrame
            
            local PreviewColor = Instance.new("Frame")
            PreviewColor.Size = UDim2.new(0, 60, 0, 30)
            PreviewColor.Position = UDim2.new(1, -75, 0, 8)
            PreviewColor.BackgroundColor3 = default
            PreviewColor.BorderSizePixel = 0
            PreviewColor.Parent = ColorFrame
            
            local PreviewCorner = Instance.new("UICorner")
            PreviewCorner.CornerRadius = UDim.new(0, 6)
            PreviewCorner.Parent = PreviewColor
            
            local PreviewStroke = Instance.new("UIStroke")
            PreviewStroke.Color = Theme.Border
            PreviewStroke.Thickness = 1
            PreviewStroke.Transparency = 0.5
            PreviewStroke.Parent = PreviewColor
            
            local HueLabel = Instance.new("TextLabel")
            HueLabel.Size = UDim2.new(0, 30, 0, 12)
            HueLabel.Position = UDim2.new(0, 15, 0, 38)
            HueLabel.BackgroundTransparency = 1
            HueLabel.Text = "Hue"
            HueLabel.TextColor3 = Theme.TextSecondary
            HueLabel.TextSize = 10
            HueLabel.Font = Enum.Font.Gotham
            HueLabel.TextXAlignment = Enum.TextXAlignment.Left
            HueLabel.Parent = ColorFrame
            
            local HueSliderBg = Instance.new("Frame")
            HueSliderBg.Size = UDim2.new(1, -30, 0, 12)
            HueSliderBg.Position = UDim2.new(0, 15, 0, 52)
            HueSliderBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueSliderBg.BorderSizePixel = 0
            HueSliderBg.Parent = ColorFrame
            
            local HueCorner = Instance.new("UICorner")
            HueCorner.CornerRadius = UDim.new(1, 0)
            HueCorner.Parent = HueSliderBg
            
            local HueGradient = Instance.new("UIGradient")
            HueGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
            HueGradient.Parent = HueSliderBg
            
            local HueHandle = Instance.new("Frame")
            HueHandle.Size = UDim2.new(0, 16, 0, 16)
            HueHandle.Position = UDim2.new(0, -8, 0.5, -8)
            HueHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            HueHandle.BorderSizePixel = 0
            HueHandle.ZIndex = 5
            HueHandle.Parent = HueSliderBg
            
            local HueHandleCorner = Instance.new("UICorner")
            HueHandleCorner.CornerRadius = UDim.new(1, 0)
            HueHandleCorner.Parent = HueHandle
            
            local HueHandleStroke = Instance.new("UIStroke")
            HueHandleStroke.Color = Color3.fromRGB(60, 60, 60)
            HueHandleStroke.Thickness = 2
            HueHandleStroke.Parent = HueHandle
            
            local HueButton = Instance.new("TextButton")
            HueButton.Size = UDim2.new(1, 0, 1, 0)
            HueButton.BackgroundTransparency = 1
            HueButton.Text = ""
            HueButton.Parent = HueSliderBg
            
            local SatLabel = Instance.new("TextLabel")
            SatLabel.Size = UDim2.new(0, 60, 0, 12)
            SatLabel.Position = UDim2.new(0, 15, 0, 68)
            SatLabel.BackgroundTransparency = 1
            SatLabel.Text = "Saturation"
            SatLabel.TextColor3 = Theme.TextSecondary
            SatLabel.TextSize = 10
            SatLabel.Font = Enum.Font.Gotham
            SatLabel.TextXAlignment = Enum.TextXAlignment.Left
            SatLabel.Parent = ColorFrame
            
            local SatSliderBg = Instance.new("Frame")
            SatSliderBg.Size = UDim2.new(1, -30, 0, 12)
            SatSliderBg.Position = UDim2.new(0, 15, 0, 82)
            SatSliderBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SatSliderBg.BorderSizePixel = 0
            SatSliderBg.Parent = ColorFrame
            
            local SatCorner = Instance.new("UICorner")
            SatCorner.CornerRadius = UDim.new(1, 0)
            SatCorner.Parent = SatSliderBg
            
            local SatGradient = Instance.new("UIGradient")
            SatGradient.Color = ColorSequence.new(Color3.fromRGB(180, 180, 180), default)
            SatGradient.Parent = SatSliderBg
            
            local SatHandle = Instance.new("Frame")
            SatHandle.Size = UDim2.new(0, 16, 0, 16)
            SatHandle.Position = UDim2.new(1, -8, 0.5, -8)
            SatHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            SatHandle.BorderSizePixel = 0
            SatHandle.ZIndex = 5
            SatHandle.Parent = SatSliderBg
            
            local SatHandleCorner = Instance.new("UICorner")
            SatHandleCorner.CornerRadius = UDim.new(1, 0)
            SatHandleCorner.Parent = SatHandle
            
            local SatHandleStroke = Instance.new("UIStroke")
            SatHandleStroke.Color = Color3.fromRGB(60, 60, 60)
            SatHandleStroke.Thickness = 2
            SatHandleStroke.Parent = SatHandle
            
            local SatButton = Instance.new("TextButton")
            SatButton.Size = UDim2.new(1, 0, 1, 0)
            SatButton.BackgroundTransparency = 1
            SatButton.Text = ""
            SatButton.Parent = SatSliderBg
            
            local currentHue = 0.6
            local currentSat = 1
            local hueDragging = false
            local satDragging = false
            
            local function HSVtoRGB(h, s, v)
                local c = v * s
                local hp = h * 6
                local x = c * (1 - math.abs(hp % 2 - 1))
                local m = v - c
                local r, g, b
                
                if hp < 1 then r, g, b = c, x, 0
                elseif hp < 2 then r, g, b = x, c, 0
                elseif hp < 3 then r, g, b = 0, c, x
                elseif hp < 4 then r, g, b = 0, x, c
                elseif hp < 5 then r, g, b = x, 0, c
                else r, g, b = c, 0, x end
                
                return Color3.fromRGB((r + m) * 255, (g + m) * 255, (b + m) * 255)
            end
            
            local function UpdateColor(fireCallback)
                local pureHue = HSVtoRGB(currentHue, 1, 1)
                local finalColor = HSVtoRGB(currentHue, currentSat, 1)
                
                PreviewColor.BackgroundColor3 = finalColor
                SatGradient.Color = ColorSequence.new(Color3.fromRGB(180, 180, 180), pureHue)
                
                if fireCallback then
                    callback(finalColor)
                end
            end
            
            HueButton.MouseButton1Down:Connect(function()
                hueDragging = true
            end)
            
            SatButton.MouseButton1Down:Connect(function()
                satDragging = true
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    if hueDragging or satDragging then
                        local finalColor = HSVtoRGB(currentHue, currentSat, 1)
                        callback(finalColor)
                    end
                    hueDragging = false
                    satDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if hueDragging then
                        local huePos = math.clamp((input.Position.X - HueSliderBg.AbsolutePosition.X) / HueSliderBg.AbsoluteSize.X, 0, 1)
                        currentHue = huePos
                        HueHandle.Position = UDim2.new(huePos, -8, 0.5, -8)
                        UpdateColor(false)
                    elseif satDragging then
                        local satPos = math.clamp((input.Position.X - SatSliderBg.AbsolutePosition.X) / SatSliderBg.AbsoluteSize.X, 0, 1)
                        currentSat = satPos
                        SatHandle.Position = UDim2.new(satPos, -8, 0.5, -8)
                        UpdateColor(false)
                    end
                end
            end)
            
            ColorFrame.MouseEnter:Connect(function()
                Tween(ColorFrame, {BackgroundTransparency = 0.5}, 0.15)
            end)
            
            ColorFrame.MouseLeave:Connect(function()
                Tween(ColorFrame, {BackgroundTransparency = 0.7}, 0.15)
            end)
            
            local element = {
                SetValue = function(self, col)
                    PreviewColor.BackgroundColor3 = col
                    callback(col)
                end,
                Update = function() end
            }
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- Textbox Element
        function Tab:AddTextbox(config)
            config = config or {}
            local textboxText = config.Name or "Textbox"
            local default = config.Default or ""
            local placeholder = config.Placeholder or "Enter text..."
            local callback = config.Callback or function() end
            
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Size = UDim2.new(1, 0, 0, 38)
            TextboxFrame.BackgroundColor3 = Theme.Tertiary
            TextboxFrame.BackgroundTransparency = 0.7
            TextboxFrame.BorderSizePixel = 0
            TextboxFrame.Parent = TabContent
            
            local TextboxStroke = Instance.new("UIStroke")
            TextboxStroke.Color = Theme.Border
            TextboxStroke.Thickness = 1
            TextboxStroke.Transparency = 0.5
            TextboxStroke.Parent = TextboxFrame
            
            local TextboxCorner = Instance.new("UICorner")
            TextboxCorner.CornerRadius = UDim.new(0, 8)
            TextboxCorner.Parent = TextboxFrame
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Size = UDim2.new(0, 100, 1, 0)
            TextboxLabel.Position = UDim2.new(0, 15, 0, 0)
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Text = textboxText
            TextboxLabel.TextColor3 = Theme.Text
            TextboxLabel.TextSize = 13
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.Size = UDim2.new(1, -130, 0, 26)
            Textbox.Position = UDim2.new(0, 115, 0.5, -13)
            Textbox.BackgroundColor3 = Theme.Secondary
            Textbox.BackgroundTransparency = 0.6
            Textbox.BorderSizePixel = 0
            Textbox.Text = default
            Textbox.PlaceholderText = placeholder
            Textbox.TextColor3 = Theme.Text
            Textbox.PlaceholderColor3 = Theme.TextSecondary
            Textbox.TextSize = 12
            Textbox.Font = Enum.Font.Gotham
            Textbox.ClearTextOnFocus = false
            Textbox.Parent = TextboxFrame
            
            local TextboxCornerIn = Instance.new("UICorner")
            TextboxCornerIn.CornerRadius = UDim.new(0, 6)
            TextboxCornerIn.Parent = Textbox
            
            local TextboxPadding = Instance.new("UIPadding")
            TextboxPadding.PaddingLeft = UDim.new(0, 10)
            TextboxPadding.PaddingRight = UDim.new(0, 10)
            TextboxPadding.Parent = Textbox
            
            Textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    callback(Textbox.Text)
                end
            end)
            
            TextboxFrame.MouseEnter:Connect(function()
                Tween(TextboxFrame, {BackgroundTransparency = 0.5}, 0.15)
            end)
            
            TextboxFrame.MouseLeave:Connect(function()
                Tween(TextboxFrame, {BackgroundTransparency = 0.7}, 0.15)
            end)
            
            local element = {
                SetValue = function(self, val)
                    Textbox.Text = val
                end,
                GetValue = function(self)
                    return Textbox.Text
                end,
                Update = function() end
            }
            table.insert(Tab.Elements, element)
            return element
        end
        
        -- Label Element
        function Tab:AddLabel(text)
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Size = UDim2.new(1, 0, 0, 30)
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.BorderSizePixel = 0
            LabelFrame.Parent = TabContent
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -15, 1, 0)
            Label.Position = UDim2.new(0, 15, 0, 0)
            Label.BackgroundTransparency = 1
            Label.Text = text
            Label.TextColor3 = Theme.TextSecondary
            Label.TextSize = 12
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.TextWrapped = true
            Label.Parent = LabelFrame
            
            return {
                SetText = function(self, newText)
                    Label.Text = newText
                end
            }
        end
        
        -- Section Element
        function Tab:AddSection(sectionName)
            local SectionFrame = Instance.new("Frame")
            SectionFrame.Size = UDim2.new(1, 0, 0, 35)
            SectionFrame.BackgroundTransparency = 1
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Parent = TabContent
            
            local SectionLabel = Instance.new("TextLabel")
            SectionLabel.Size = UDim2.new(1, -15, 0, 24)
            SectionLabel.Position = UDim2.new(0, 15, 0, 0)
            SectionLabel.BackgroundTransparency = 1
            SectionLabel.Text = sectionName
            SectionLabel.TextColor3 = Theme.Accent
            SectionLabel.TextSize = 14
            SectionLabel.Font = Enum.Font.GothamBold
            SectionLabel.TextXAlignment = Enum.TextXAlignment.Left
            SectionLabel.Parent = SectionFrame
            
            local Divider = Instance.new("Frame")
            Divider.Size = UDim2.new(1, -15, 0, 1)
            Divider.Position = UDim2.new(0, 15, 1, -1)
            Divider.BackgroundColor3 = Theme.Border
            Divider.BackgroundTransparency = 0.5
            Divider.BorderSizePixel = 0
            Divider.Parent = SectionFrame
        end
        
        table.insert(Window.Tabs, Tab)
        
        return Tab
    end
    
    return Window
end

return Library
