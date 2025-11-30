--[[
    Modern Minimalistic UI Library - Enhanced Edition
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

-- Main Library Functions
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "UI Library"
    local windowSize = config.Size or UDim2.new(0, 520, 0, 600)
    local accentColor = config.AccentColor or Theme.Accent
    
    -- Update theme with custom accent
    Theme.Accent = accentColor
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUILibrary_" .. tostring(math.random(1000, 9999))
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    
    -- Main Frame
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
    
    -- Stroke Border
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
    TopBar.Parent = MainFrame
    
    local TopBarCorner = Instance.new("UICorner")
    TopBarCorner.CornerRadius = UDim.new(0, 12)
    TopBarCorner.Parent = TopBar
    
    -- Top Bar Stroke
    local TopBarStroke = Instance.new("UIStroke")
    TopBarStroke.Color = Theme.Border
    TopBarStroke.Thickness = 1
    TopBarStroke.Transparency = 0.3
    TopBarStroke.Parent = TopBar
    
    -- Title
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
    Title.Parent = TopBar
    
    -- Close Button
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
        wait(0.3)
        ScreenGui:Destroy()
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 130, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 50)
    TabContainer.BackgroundColor3 = Theme.Secondary
    TabContainer.BackgroundTransparency = 0.7
    TabContainer.BorderSizePixel = 0
    TabContainer.Parent = MainFrame
    
    local TabStroke = Instance.new("UIStroke")
    TabStroke.Color = Theme.Border
    TabStroke.Thickness = 1
    TabStroke.Transparency = 0.3
    TabStroke.Parent = TabContainer
    
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
    
    -- Make draggable
    MakeDraggable(MainFrame, TopBar)
    
    local Window = {}
    Window.ScreenGui = ScreenGui
    Window.MainFrame = MainFrame
    Window.TabContainer = TabContainer
    Window.ContentContainer = ContentContainer
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.Theme = Theme
    
    function Window:SetAccentColor(color)
        Theme.Accent = color
        -- Update all elements with accent color
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
        
        -- Tab Button
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
        
        -- Tab Content
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
        
        -- Tab switching
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
        
        -- Tab Elements
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
                wait(0.1)
                Tween(ButtonFrame, {BackgroundTransparency = 0.5}, 0.1)
                callback()
            end)
            
            local element = {Update = function(self) end}
            table.insert(Tab.Elements, element)
            return Button
        end
        
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
                Update = function(self) end
            }
            table.insert(Tab.Elements, element)
            return element
        end
        
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
            
            SliderButton.MouseButton1Click:Connect(function(input)
                UpdateSlider(input)
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
                Update = function(self) end
            }
            table.insert(Tab.Elements, element)
            return element
        end
        
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
            DropdownLabel.Size = UDim2.new(1, -80, 1, 0)
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
            
            local DropdownArrow = Instance.new("TextLabel")
            DropdownArrow.Size = UDim2.new(0, 20, 0, 20)
            DropdownArrow.Position = UDim2.new(1, -30, 0.5, -10)
            DropdownArrow.BackgroundTransparency = 1
            DropdownArrow.Text = "▼"
            DropdownArrow.TextColor3 = Theme.TextSecondary
            DropdownArrow.TextSize = 10
            DropdownArrow.Font = Enum.Font.Gotham
            DropdownArrow.ZIndex = 3
            DropdownArrow.Parent = DropdownFrame
            
            local DropdownValue = Instance.new("TextLabel")
            DropdownValue.Size = UDim2.new(0, 100, 1, 0)
            DropdownValue.Position = UDim2.new(1, -120, 0, 0)
            DropdownValue.BackgroundTransparency = 1
            DropdownValue.Text = default
            DropdownValue.TextColor3 = Theme.Accent
            DropdownValue.TextSize = 12
            DropdownValue.Font = Enum.Font.GothamBold
            DropdownValue.TextXAlignment = Enum.TextXAlignment.Right
            DropdownValue.ZIndex = 3
            DropdownValue.Parent = DropdownFrame
            
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
            OptionsFrame.Position = UDim2.new(0, 0, 1, 4)
            OptionsFrame.BackgroundColor3 = Theme.Secondary
            OptionsFrame.BackgroundTransparency = 0.3
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
                    wait(0.2)
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
                    local targetHeight = #options * 38 + (#options - 1) * 4 + 12
                    Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, targetHeight)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 180}, 0.2)
                else
                    Tween(OptionsFrame, {Size = UDim2.new(1, 0, 0, 0)}, 0.2)
                    Tween(DropdownArrow, {Rotation = 0}, 0.2)
                    wait(0.2)
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
                Update = function(self) end
            }
            table.insert(Tab.Elements, element)
            return element
        end
        
        function Tab:AddColorPicker(config)
            config = config or {}
            local colorText = config.Name or "Color"
            local default = config.Default or Color3.fromRGB(100, 150, 255)
            local callback = config.Callback or function() end
            
            local ColorFrame = Instance.new("Frame")
            ColorFrame.Size = UDim2.new(1, 0, 0, 100)
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
            ColorLabel.Position = UDim2.new(0, 15, 0, 8)
            ColorLabel.BackgroundTransparency = 1
            ColorLabel.Text = colorText
            ColorLabel.TextColor3 = Theme.Text
            ColorLabel.TextSize = 13
            ColorLabel.Font = Enum.Font.Gotham
            ColorLabel.TextXAlignment = Enum.TextXAlignment.Left
            ColorLabel.Parent = ColorFrame
            
            local HueSliderBg = Instance.new("Frame")
            HueSliderBg.Size = UDim2.new(1, -30, 0, 8)
            HueSliderBg.Position = UDim2.new(0, 15, 0, 32)
            HueSliderBg.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            HueSliderBg.BorderSizePixel = 0
            HueSliderBg.Parent = ColorFrame
            
            local HueCorner = Instance.new("UICorner")
            HueCorner.CornerRadius = UDim.new(1, 0)
            HueCorner.Parent = HueSliderBg
            
            local HueGradient = Instance.new("UIGradient")
            HueGradient.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.16, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.32, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.66, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.82, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
            })
            HueGradient.Parent = HueSliderBg
            
            local HueButton = Instance.new("TextButton")
            HueButton.Size = UDim2.new(1, 0, 1, 0)
            HueButton.BackgroundTransparency = 1
            HueButton.Text = ""
            HueButton.Parent = HueSliderBg
            
            local SaturationSliderBg = Instance.new("Frame")
            SaturationSliderBg.Size = UDim2.new(1, -30, 0, 8)
            SaturationSliderBg.Position = UDim2.new(0, 15, 0, 45)
            SaturationSliderBg.BackgroundColor3 = default
            SaturationSliderBg.BorderSizePixel = 0
            SaturationSliderBg.Parent = ColorFrame
            
            local SatCorner = Instance.new("UICorner")
            SatCorner.CornerRadius = UDim.new(1, 0)
            SatCorner.Parent = SaturationSliderBg
            
            local SatGradient = Instance.new("UIGradient")
            SatGradient.Color = ColorSequence.new(Color3.fromRGB(200, 200, 200), default)
            SatGradient.Parent = SaturationSliderBg
            
            local SatButton = Instance.new("TextButton")
            SatButton.Size = UDim2.new(1, 0, 1, 0)
            SatButton.BackgroundTransparency = 1
            SatButton.Text = ""
            SatButton.Parent = SaturationSliderBg
            
            local PreviewColor = Instance.new("Frame")
            PreviewColor.Size = UDim2.new(0, 70, 0, 35)
            PreviewColor.Position = UDim2.new(1, -80, 0.5, -18)
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
            
            local currentColor = default
            local hueDragging = false
            local satDragging = false
            
            local function HSVtoRGB(h, s, v)
                local c = v * s
                local x = c * (1 - ((h / 60) % 2 - 1))
                local m = v - c
                local r, g, b
                
                if h < 60 then r, g, b = c, x, 0
                elseif h < 120 then r, g, b = x, c, 0
                elseif h < 180 then r, g, b = 0, c, x
                elseif h < 240 then r, g, b = 0, x, c
                elseif h < 300 then r, g, b = x, 0, c
                else r, g, b = c, 0, x end
                
                return Color3.fromRGB((r + m) * 255, (g + m) * 255, (b + m) * 255)
            end
            
            HueButton.MouseButton1Down:Connect(function() hueDragging = true end)
            SatButton.MouseButton1Down:Connect(function() satDragging = true end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    hueDragging = false
                    satDragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseMovement then
                    if hueDragging then
                        local huePos = math.clamp((input.Position.X - HueSliderBg.AbsolutePosition.X) / HueSliderBg.AbsoluteSize.X, 0, 1)
                        local hue = huePos * 360
                        currentColor = HSVtoRGB(hue, 1, 1)
                        Tween(PreviewColor, {BackgroundColor3 = currentColor}, 0.05)
                        Tween(SaturationSliderBg, {BackgroundColor3 = currentColor}, 0.05)
                        callback(currentColor)
                    elseif satDragging then
                        local satPos = math.clamp((input.Position.X - SaturationSliderBg.AbsolutePosition.X) / SaturationSliderBg.AbsoluteSize.X, 0, 1)
                        currentColor = Color3.new(
                            currentColor.R + (1 - satPos) * (200/255 - currentColor.R),
                            currentColor.G + (1 - satPos) * (200/255 - currentColor.G),
                            currentColor.B + (1 - satPos) * (200/255 - currentColor.B)
                        )
                        Tween(PreviewColor, {BackgroundColor3 = currentColor}, 0.05)
                        callback(currentColor)
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
                    currentColor = col
                    Tween(PreviewColor, {BackgroundColor3 = col})
                    callback(col)
                end,
                Update = function(self) end
            }
            table.insert(Tab.Elements, element)
            return element
        end
        
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
            Textbox.Size = UDim2.new(1, -120, 0, 26)
            Textbox.Position = UDim2.new(0, 110, 0.5, -13)
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
                Update = function(self) end
            }
            table.insert(Tab.Elements, element)
            return element
        end
        
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
