-- Modern Custom GUI - Advanced Hack Menu
-- Beautiful design with glassmorphism and animations

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Settings Storage
local Settings = {
    ESP = {
        Enabled = false,
        Box = false,
        Health = false,
        Tracer = false,
        Skeleton = false,
        Distance = false,
        MaxDistance = 1000
    },
    Aim = {
        Enabled = false,
        FOV = false,
        FOVSize = 100,
        Smooth = false,
        Smoothness = 5
    },
    Autofarm = {
        Lixeiro = false,
        LixeiroSpeed = 5,
        Ifood = false,
        IfoodSpeed = 5,
        Uber = false,
        UberSpeed = 5
    },
    Misc = {
        Speed = false,
        SpeedValue = 16,
        Noclip = false,
        InfiniteJump = false,
        SpinBot = false
    }
}

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ModernHackGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Protection
if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = game.CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = LocalPlayer.PlayerGui
end

-- Main Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 650, 0, 480)
MainFrame.Position = UDim2.new(0.5, -325, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

-- Add corner radius
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

-- Add gradient
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 20))
}
Gradient.Rotation = 45
Gradient.Parent = MainFrame

-- Dragging functionality
local dragging = false
local dragInput, dragStart, startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Top Bar
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

-- Fix for top corners
local TopBarFix = Instance.new("Frame")
TopBarFix.Size = UDim2.new(1, 0, 0, 12)
TopBarFix.Position = UDim2.new(0, 0, 1, -12)
TopBarFix.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TopBarFix.BorderSizePixel = 0
TopBarFix.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ ADVANCED MENU"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

-- Animated accent line
local AccentLine = Instance.new("Frame")
AccentLine.Name = "AccentLine"
AccentLine.Size = UDim2.new(0, 0, 0, 3)
AccentLine.Position = UDim2.new(0, 0, 1, -3)
AccentLine.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
AccentLine.BorderSizePixel = 0
AccentLine.Parent = TopBar

local AccentGradient = Instance.new("UIGradient")
AccentGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 170))
}
AccentGradient.Parent = AccentLine

-- Animate accent line
TweenService:Create(AccentLine, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
    Size = UDim2.new(1, 0, 0, 3)
}):Play()

-- Close Button
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 40, 0, 40)
CloseButton.Position = UDim2.new(1, -45, 0, 5)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseButton.Text = "✕"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 18
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BorderSizePixel = 0
CloseButton.AutoButtonColor = false
CloseButton.Parent = TopBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

CloseButton.MouseButton1Click:Connect(function()
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    task.wait(0.3)
    ScreenGui:Destroy()
end)

CloseButton.MouseEnter:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)

CloseButton.MouseLeave:Connect(function()
    TweenService:Create(CloseButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 50, 50)}):Play()
end)

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Size = UDim2.new(0, 40, 0, 40)
MinimizeButton.Position = UDim2.new(1, -90, 0, 5)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
MinimizeButton.Text = "−"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BorderSizePixel = 0
MinimizeButton.AutoButtonColor = false
MinimizeButton.Parent = TopBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 8)
MinCorner.Parent = MinimizeButton

local isMinimized = false
local ContentContainer
local TabContainer

MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 250, 0, 50)
        }):Play()
        MinimizeButton.Text = "+"
        if ContentContainer then ContentContainer.Visible = false end
        if TabContainer then TabContainer.Visible = false end
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 650, 0, 480)
        }):Play()
        MinimizeButton.Text = "−"
        if ContentContainer then ContentContainer.Visible = true end
        if TabContainer then TabContainer.Visible = true end
    end
end)

MinimizeButton.MouseEnter:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 200, 50)}):Play()
end)

MinimizeButton.MouseLeave:Connect(function()
    TweenService:Create(MinimizeButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 170, 0)}):Play()
end)

-- Tab Container
TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 150, 1, -65)
TabContainer.Position = UDim2.new(0, 10, 0, 60)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 8)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabContainer

-- Content Container
ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, -175, 1, -70)
ContentContainer.Position = UDim2.new(0, 165, 0, 60)
ContentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
ContentContainer.BorderSizePixel = 0
ContentContainer.ClipsDescendants = true
ContentContainer.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 10)
ContentCorner.Parent = ContentContainer

-- Tab System
local tabs = {}
local currentTab = nil

local function CreateTab(name, icon)
    local tab = {}
    
    tab.Button = Instance.new("TextButton")
    tab.Button.Name = name .. "Tab"
    tab.Button.Size = UDim2.new(1, 0, 0, 45)
    tab.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tab.Button.BorderSizePixel = 0
    tab.Button.Text = icon .. " " .. name
    tab.Button.TextColor3 = Color3.fromRGB(180, 180, 190)
    tab.Button.TextSize = 14
    tab.Button.Font = Enum.Font.GothamSemibold
    tab.Button.TextXAlignment = Enum.TextXAlignment.Left
    tab.Button.AutoButtonColor = false
    tab.Button.Parent = TabContainer
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = tab.Button
    
    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 15)
    Padding.Parent = tab.Button
    
    -- Create ScrollFrame for each tab
    tab.ScrollFrame = Instance.new("ScrollingFrame")
    tab.ScrollFrame.Name = name .. "Scroll"
    tab.ScrollFrame.Size = UDim2.new(1, -10, 1, -10)
    tab.ScrollFrame.Position = UDim2.new(0, 5, 0, 5)
    tab.ScrollFrame.BackgroundTransparency = 1
    tab.ScrollFrame.ScrollBarThickness = 4
    tab.ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
    tab.ScrollFrame.BorderSizePixel = 0
    tab.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tab.ScrollFrame.Visible = false
    tab.ScrollFrame.Parent = ContentContainer
    
    local ContentLayout = Instance.new("UIListLayout")
    ContentLayout.Padding = UDim.new(0, 8)
    ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ContentLayout.Parent = tab.ScrollFrame
    
    -- Auto-resize canvas
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tab.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y + 10)
    end)
    
    tab.Button.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.ScrollFrame.Visible = false
            TweenService:Create(t.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 45),
                TextColor3 = Color3.fromRGB(180, 180, 190)
            }):Play()
        end
        
        tab.ScrollFrame.Visible = true
        currentTab = tab
        
        TweenService:Create(tab.Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 170, 255),
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
    end)
    
    tab.Button.MouseEnter:Connect(function()
        if currentTab ~= tab then
            TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(45, 45, 55)
            }):Play()
        end
    end)
    
    tab.Button.MouseLeave:Connect(function()
        if currentTab ~= tab then
            TweenService:Create(tab.Button, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(35, 35, 45)
            }):Play()
        end
    end)
    
    table.insert(tabs, tab)
    return tab
end

-- UI Elements Creation Functions
local function CreateToggle(parent, text, defaultValue, callback)
    local Toggle = Instance.new("Frame")
    Toggle.Size = UDim2.new(1, -10, 0, 40)
    Toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Toggle.BorderSizePixel = 0
    Toggle.Parent = parent
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = Toggle
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.Parent = Toggle
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 45, 0, 25)
    Button.Position = UDim2.new(1, -50, 0.5, -12.5)
    Button.BackgroundColor3 = defaultValue and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 70)
    Button.Text = ""
    Button.BorderSizePixel = 0
    Button.AutoButtonColor = false
    Button.Parent = Toggle
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(1, 0)
    ButtonCorner.Parent = Button
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 19, 0, 19)
    Circle.Position = defaultValue and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = Button
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local enabled = defaultValue
    
    Button.MouseButton1Click:Connect(function()
        enabled = not enabled
        callback(enabled)
        
        TweenService:Create(Button, TweenInfo.new(0.3), {
            BackgroundColor3 = enabled and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(60, 60, 70)
        }):Play()
        
        TweenService:Create(Circle, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Position = enabled and UDim2.new(1, -22, 0.5, -9.5) or UDim2.new(0, 3, 0.5, -9.5)
        }):Play()
    end)
    
    return Toggle
end

local function CreateSlider(parent, text, min, max, defaultValue, callback)
    local Slider = Instance.new("Frame")
    Slider.Size = UDim2.new(1, -10, 0, 55)
    Slider.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    Slider.BorderSizePixel = 0
    Slider.Parent = parent
    
    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = Slider
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(220, 220, 230)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextTruncate = Enum.TextTruncate.AtEnd
    Label.Parent = Slider
    
    local Value = Instance.new("TextLabel")
    Value.Size = UDim2.new(0, 50, 0, 20)
    Value.Position = UDim2.new(1, -60, 0, 5)
    Value.BackgroundTransparency = 1
    Value.Text = tostring(defaultValue)
    Value.TextColor3 = Color3.fromRGB(0, 170, 255)
    Value.TextSize = 13
    Value.Font = Enum.Font.GothamBold
    Value.TextXAlignment = Enum.TextXAlignment.Right
    Value.Parent = Slider
    
    local SliderBack = Instance.new("Frame")
    SliderBack.Size = UDim2.new(1, -20, 0, 6)
    SliderBack.Position = UDim2.new(0, 10, 1, -15)
    SliderBack.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    SliderBack.BorderSizePixel = 0
    SliderBack.Parent = Slider
    
    local SliderBackCorner = Instance.new("UICorner")
    SliderBackCorner.CornerRadius = UDim.new(1, 0)
    SliderBackCorner.Parent = SliderBack
    
    local SliderFill = Instance.new("Frame")
    SliderFill.Size = UDim2.new((defaultValue - min) / (max - min), 0, 1, 0)
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    SliderFill.BorderSizePixel = 0
    SliderFill.Parent = SliderBack
    
    local SliderFillCorner = Instance.new("UICorner")
    SliderFillCorner.CornerRadius = UDim.new(1, 0)
    SliderFillCorner.Parent = SliderFill
    
    local SliderButton = Instance.new("TextButton")
    SliderButton.Size = UDim2.new(1, 0, 1, 0)
    SliderButton.BackgroundTransparency = 1
    SliderButton.Text = ""
    SliderButton.AutoButtonColor = false
    SliderButton.Parent = SliderBack
    
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
        local function update()
            local mouse = UserInputService:GetMouseLocation()
            local pos = math.clamp((mouse.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            Value.Text = tostring(value)
            callback(value)
        end
        update()
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mouse = UserInputService:GetMouseLocation()
            local pos = math.clamp((mouse.X - SliderBack.AbsolutePosition.X) / SliderBack.AbsoluteSize.X, 0, 1)
            local value = math.floor(min + (max - min) * pos)
            
            SliderFill.Size = UDim2.new(pos, 0, 1, 0)
            Value.Text = tostring(value)
            callback(value)
        end
    end)
    
    return Slider
end

local function CreateButton(parent, text, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -10, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.AutoButtonColor = false
    Button.Parent = parent
    
    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 8)
    ButtonCorner.Parent = Button
    
    local ButtonGradient = Instance.new("UIGradient")
    ButtonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 170, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 120, 200))
    }
    ButtonGradient.Rotation = 90
    ButtonGradient.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(0, 150, 220)
        }):Play()
        task.wait(0.1)
        TweenService:Create(Button, TweenInfo.new(0.1), {
            BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        }):Play()
        callback()
    end)
    
    Button.MouseEnter:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 190, 255)
        }):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        TweenService:Create(Button, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        }):Play()
    end)
    
    return Button
end

local function CreateSection(parent, text)
    local Section = Instance.new("TextLabel")
    Section.Size = UDim2.new(1, -10, 0, 30)
    Section.BackgroundTransparency = 1
    Section.Text = "━━ " .. text .. " ━━"
    Section.TextColor3 = Color3.fromRGB(0, 170, 255)
    Section.TextSize = 14
    Section.Font = Enum.Font.GothamBold
    Section.Parent = parent
    
    return Section
end

-- Create Tabs
local ESPTab = CreateTab("ESP", "👁")
local AimTab = CreateTab("Aim", "🎯")
local FarmTab = CreateTab("Farm", "⚡")
local MiscTab = CreateTab("Misc", "⚙")

-- ESP Tab Content
CreateSection(ESPTab.ScrollFrame, "ESP Settings")
CreateToggle(ESPTab.ScrollFrame, "Enable ESP", false, function(state)
    Settings.ESP.Enabled = state
end)
CreateToggle(ESPTab.ScrollFrame, "ESP Box", false, function(state)
    Settings.ESP.Box = state
end)
CreateToggle(ESPTab.ScrollFrame, "ESP Health Bar", false, function(state)
    Settings.ESP.Health = state
end)
CreateToggle(ESPTab.ScrollFrame, "ESP Tracer", false, function(state)
    Settings.ESP.Tracer = state
end)
CreateToggle(ESPTab.ScrollFrame, "ESP Skeleton", false, function(state)
    Settings.ESP.Skeleton = state
end)
CreateToggle(ESPTab.ScrollFrame, "ESP Distance", false, function(state)
    Settings.ESP.Distance = state
end)
CreateSlider(ESPTab.ScrollFrame, "Max Distance", 100, 5000, 1000, function(value)
    Settings.ESP.MaxDistance = value
end)

-- Aim Tab Content
CreateSection(AimTab.ScrollFrame, "Aimbot Settings")
CreateToggle(AimTab.ScrollFrame, "Enable Aimbot", false, function(state)
    Settings.Aim.Enabled = state
end)
CreateToggle(AimTab.ScrollFrame, "FOV Circle", false, function(state)
    Settings.Aim.FOV = state
end)
CreateSlider(AimTab.ScrollFrame, "FOV Size", 50, 500, 100, function(value)
    Settings.Aim.FOVSize = value
end)
CreateToggle(AimTab.ScrollFrame, "Smooth Aim", false, function(state)
    Settings.Aim.Smooth = state
end)
CreateSlider(AimTab.ScrollFrame, "Smoothness", 1, 20, 5, function(value)
    Settings.Aim.Smoothness = value
end)

-- Farm Tab Content
CreateSection(FarmTab.ScrollFrame, "Auto Lixeiro")
CreateToggle(FarmTab.ScrollFrame, "Enable Auto Lixeiro", false, function(state)
    Settings.Autofarm.Lixeiro = state
end)
CreateSlider(FarmTab.ScrollFrame, "Lixeiro Speed", 1, 20, 5, function(value)
    Settings.Autofarm.LixeiroSpeed = value
end)

CreateSection(FarmTab.ScrollFrame, "Auto Ifood")
CreateToggle(FarmTab.ScrollFrame, "Enable Auto Ifood", false, function(state)
    Settings.Autofarm.Ifood = state
end)
CreateSlider(FarmTab.ScrollFrame, "Ifood Speed", 1, 20, 5, function(value)
    Settings.Autofarm.IfoodSpeed = value
end)

CreateSection(FarmTab.ScrollFrame, "Auto Uber")
CreateToggle(FarmTab.ScrollFrame, "Enable Auto Uber", false, function(state)
    Settings.Autofarm.Uber = state
end)
CreateSlider(FarmTab.ScrollFrame, "Uber Speed", 1, 20, 5, function(value)
    Settings.Autofarm.UberSpeed = value
end)

-- Misc Tab Content
CreateSection(MiscTab.ScrollFrame, "Movement")
CreateToggle(MiscTab.ScrollFrame, "Player Speed", false, function(state)
    Settings.Misc.Speed = state
end)
CreateSlider(MiscTab.ScrollFrame, "Speed Value", 16, 200, 16, function(value)
    Settings.Misc.SpeedValue = value
end)
CreateToggle(MiscTab.ScrollFrame, "Noclip", false, function(state)
    Settings.Misc.Noclip = state
end)
CreateToggle(MiscTab.ScrollFrame, "Infinite Jump", false, function(state)
    Settings.Misc.InfiniteJump = state
end)

CreateSection(MiscTab.ScrollFrame, "Fun")
CreateToggle(MiscTab.ScrollFrame, "Spin Bot", false, function(state)
    Settings.Misc.SpinBot = state
end)
CreateButton(MiscTab.ScrollFrame, "🌀 Bring All Players", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- Select first tab by default
task.wait(0.1)
if tabs[1] then
    tabs[1].Button.MouseButton1Click:Fire()
end

-- Animation on open
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 650, 0, 480)
}):Play()

-- Functionality Loops
RunService.Heartbeat:Connect(function()
    -- Player Speed
    if Settings.Misc.Speed and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = Settings.Misc.SpeedValue
    end
    
    -- Noclip
    if Settings.Misc.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
    
    -- Spin Bot
    if Settings.Misc.SpinBot and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(20), 0)
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if Settings.Misc.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

print("✅ Modern GUI Loaded Successfully!")
print("🎨 Made with ❤ by Advanced Menu")