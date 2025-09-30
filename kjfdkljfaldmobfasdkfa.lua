-- MT_HAZE - GUI + Features (BigHead V1 final, slider fix) - Integrated (WITH BUTTON)
-- Paste in a LocalScript. Assumes game uses "Cabesa".

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer and LocalPlayer:GetMouse()

-- Root GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MT_HAZE_GUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Settings
local Settings = {}
local function sget(k, d) if Settings[k] == nil then return d end return Settings[k] end

-- Keep references to slider UI widgets so external buttons can update them
local SliderWidgets = {}

-- ===== Window & UI (layout) =====
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0,650,0,400)
MainFrame.Position = UDim2.new(0.5,-325,0.5,-200)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0,10)

local DragBar = Instance.new("Frame", MainFrame)
DragBar.Size = UDim2.new(1,0,0,36)
DragBar.BackgroundTransparency = 1

local TitleLabel = Instance.new("TextLabel", DragBar)
TitleLabel.Size = UDim2.new(1,-120,1,0)
TitleLabel.Position = UDim2.new(0,12,0,0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 18
TitleLabel.TextColor3 = Color3.fromRGB(255,255,255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Text = "MT HAZE"

local CloseBtn = Instance.new("TextButton", DragBar)
CloseBtn.Size = UDim2.new(0,30,0,28)
CloseBtn.Position = UDim2.new(1,-40,0,4)
CloseBtn.BackgroundColor3 = Color3.fromRGB(160,0,0)
CloseBtn.Text = "X"
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,6)

local MinimizeBtn = Instance.new("TextButton", DragBar)
MinimizeBtn.Size = UDim2.new(0,30,0,28)
MinimizeBtn.Position = UDim2.new(1,-80,0,4)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(80,80,80)
MinimizeBtn.Text = "-"
Instance.new("UICorner", MinimizeBtn).CornerRadius = UDim.new(0,6)

local Watermark = Instance.new("TextLabel", MainFrame)
Watermark.Size = UDim2.new(0,200,0,30)
Watermark.Position = UDim2.new(0,10,1,-40)
Watermark.BackgroundTransparency = 1
Watermark.Text = "MT HAZE"
Watermark.TextColor3 = Color3.fromRGB(255,0,0)
Watermark.Font = Enum.Font.GothamBold
Watermark.TextSize = 20
Watermark.TextXAlignment = Enum.TextXAlignment.Left
Watermark.TextYAlignment = Enum.TextYAlignment.Bottom
Watermark.TextTransparency = 0.1

-- Minimized ball
local MiniBall = Instance.new("Frame", ScreenGui)
MiniBall.Size = UDim2.new(0,40,0,40)
MiniBall.Position = UDim2.new(0.05,0,0.3,0)
MiniBall.BackgroundColor3 = Color3.fromRGB(100,100,100)
MiniBall.BackgroundTransparency = 0.3
MiniBall.Visible = false
Instance.new("UICorner", MiniBall).CornerRadius = UDim.new(1,0)

local MiniBtn = Instance.new("TextButton", MiniBall)
MiniBtn.Size = UDim2.new(1,0,1,0)
MiniBtn.BackgroundTransparency = 1
MiniBtn.AutoButtonColor = false
MiniBtn.Text = ""

-- Minimize behavior (show ball)
MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MiniBall.Visible = true
end)
MiniBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MiniBall.Visible = false
end)

-- MiniBall drag/click (direct follow while dragging; tween only on release to snap)
local ballDragging, ballDragStart, ballStartAbs, ballMoved = false, nil, nil, false
MiniBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        ballDragging = true
        ballDragStart = input.Position
        ballStartAbs = MiniBall.AbsolutePosition
        ballMoved = false
    end
end)
MiniBtn.InputChanged:Connect(function(input)
    if ballDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local deltaX = input.Position.X - ballDragStart.X
        local deltaY = input.Position.Y - ballDragStart.Y
        local newAbsX = math.clamp(ballStartAbs.X + deltaX, 0, Camera.ViewportSize.X - MiniBall.AbsoluteSize.X)
        local newAbsY = math.clamp(ballStartAbs.Y + deltaY, 0, Camera.ViewportSize.Y - MiniBall.AbsoluteSize.Y)
        MiniBall.Position = UDim2.fromOffset(newAbsX, newAbsY)
        ballMoved = true
    end
end)
MiniBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        ballDragging = false
        local screenSize = Camera.ViewportSize
        local absX = MiniBall.AbsolutePosition.X
        local targetUDim
        if absX < screenSize.X / 2 then
            targetUDim = UDim2.new(0, 0, MiniBall.Position.Y.Scale, MiniBall.Position.Y.Offset)
        else
            targetUDim = UDim2.new(1, -MiniBall.AbsoluteSize.X, MiniBall.Position.Y.Scale, MiniBall.Position.Y.Offset)
        end
        pcall(function()
            TweenService:Create(MiniBall, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetUDim}):Play()
        end)
        -- edge transparency tween
        if MiniBall.AbsolutePosition.X < 50 or MiniBall.AbsolutePosition.X > (screenSize.X - 50) then
            pcall(function() TweenService:Create(MiniBall, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play() end)
        else
            pcall(function() TweenService:Create(MiniBall, TweenInfo.new(0.12), {BackgroundTransparency = 0.3}):Play() end)
        end
        if not ballMoved then
            MainFrame.Visible = true
            MiniBall.Visible = false
        end
    end
end)

-- Drag only by DragBar (main window)
do
    local dragging, dragStart, startPos = false, nil, nil
    DragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
        end
    end)
    DragBar.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    DragBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Sidebar / Content
local SideTabs = Instance.new("Frame", MainFrame)
SideTabs.Size = UDim2.new(0,150,1,-36)
SideTabs.Position = UDim2.new(0,0,0,36)
SideTabs.BackgroundColor3 = Color3.fromRGB(35,35,35)
Instance.new("UICorner", SideTabs).CornerRadius = UDim.new(0,8)

local SideLayout = Instance.new("UIListLayout", SideTabs)
SideLayout.FillDirection = Enum.FillDirection.Vertical
SideLayout.Padding = UDim.new(0,12)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ContentFrame = Instance.new("ScrollingFrame", MainFrame)
ContentFrame.Size = UDim2.new(1,-150,1,-36)
ContentFrame.Position = UDim2.new(0,150,0,36)
ContentFrame.BackgroundTransparency = 1
ContentFrame.CanvasSize = UDim2.new(0,0,0,0)
ContentFrame.ScrollBarThickness = 6
ContentFrame.ScrollBarImageColor3 = Color3.fromRGB(150,0,0)

local ContentLayout = Instance.new("UIListLayout", ContentFrame)
ContentLayout.FillDirection = Enum.FillDirection.Vertical
ContentLayout.Padding = UDim.new(0,12)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
local ContentPadding = Instance.new("UIPadding", ContentFrame)
ContentPadding.PaddingTop = UDim.new(0,15)
ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    ContentFrame.CanvasSize = UDim2.new(0,0,0,ContentLayout.AbsoluteContentSize.Y + 20)
end)

-- UI helper builders (toggles, sliders, tabs)
local function clearContent()
    for _,c in pairs(ContentFrame:GetChildren()) do
        if not c:IsA("UIListLayout") and not c:IsA("UIPadding") then
            c:Destroy()
        end
    end
end
local function createTab(name, onClick)
    local btn = Instance.new("TextButton", SideTabs)
    btn.Size = UDim2.new(0,130,0,40)
    btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)
    btn.MouseButton1Click:Connect(function()
        clearContent()
        onClick()
    end)
end

-- createToggle & createSlider now add to ContentFrame; order handled by UIListLayout
local function createToggle(id, name)
    Settings[id] = Settings[id] or false
    local frame = Instance.new("Frame", ContentFrame)
    frame.Size = UDim2.new(0,400,0,40)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7,0,1,0)
    label.Position = UDim2.new(0,10,0,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Text = name

    local toggleBtn = Instance.new("TextButton", frame)
    toggleBtn.Size = UDim2.new(0,60,0,25)
    toggleBtn.Position = UDim2.new(1,-70,0.5,-12)
    toggleBtn.BackgroundColor3 = Settings[id] and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,0,0)
    toggleBtn.Text = Settings[id] and "ON" or "OFF"
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 14
    toggleBtn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0,6)

    toggleBtn.MouseButton1Click:Connect(function()
        Settings[id] = not Settings[id]
        toggleBtn.Text = Settings[id] and "ON" or "OFF"
        toggleBtn.BackgroundColor3 = Settings[id] and Color3.fromRGB(0,120,0) or Color3.fromRGB(80,0,0)
    end)
end

local function createButton(id, name, buttonText, onClick)
    Settings[id] = Settings[id] or false
    local frame = Instance.new("Frame", ContentFrame)
    frame.Size = UDim2.new(0,400,0,40)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7,0,1,0)
    label.Position = UDim2.new(0,10,0,0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Text = name

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0,140,0,28)
    btn.Position = UDim2.new(1,-150,0.5,-14)
    btn.BackgroundColor3 = Color3.fromRGB(120,0,0)
    btn.Text = buttonText
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(function()
        pcall(onClick)
    end)
end

local function createSlider(id, name, min, max)
    -- ensure integer slider between min and max
    min = math.floor(min or 0)
    max = math.floor(max or 100)
    if min >= max then max = min + 1 end
    Settings[id] = Settings[id] or math.floor((min+max)/2)
    local frame = Instance.new("Frame", ContentFrame)
    frame.Size = UDim2.new(0,400,0,70)
    frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,6)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.7,0,0,20)
    label.Position = UDim2.new(0,10,0,5)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.Text = name

    local valueLabel = Instance.new("TextLabel", frame)
    valueLabel.Size = UDim2.new(0.3,-20,0,20)
    valueLabel.Position = UDim2.new(0.7,0,0,5)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 16
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.TextColor3 = Color3.fromRGB(255,100,100)
    valueLabel.Text = tostring(Settings[id])

    local sliderBar = Instance.new("Frame", frame)
    sliderBar.Size = UDim2.new(0.9,0,0,8)
    sliderBar.Position = UDim2.new(0.05,0,0,40)
    sliderBar.BackgroundColor3 = Color3.fromRGB(70,70,70)
    Instance.new("UICorner", sliderBar).CornerRadius = UDim.new(1,0)

    local rel = (Settings[id]-min)/(max-min)
    local fill = Instance.new("Frame", sliderBar)
    fill.Size = UDim2.new(rel,0,1,0)
    fill.BackgroundColor3 = Color3.fromRGB(200,0,0)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

    local knob = Instance.new("Frame", sliderBar)
    knob.Size = UDim2.new(0,16,0,16)
    knob.Position = UDim2.new(rel,-8,0.5,-8)
    knob.BackgroundColor3 = Color3.fromRGB(255,100,100)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)

    -- store widgets for external updates (e.g., BigHead button)
    SliderWidgets[id] = {
        valueLabel = valueLabel,
        fill = fill,
        knob = knob,
        sliderBar = sliderBar,
        min = min,
        max = max
    }

    -- isolated slider drag (integer steps) + immediate click response
    local dragging = false
    local function setValueFromPosition(pos)
        local relX = math.clamp((pos.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
        local newValue = math.floor(min + (max-min) * relX + 0.5)
        if newValue < min then newValue = min end
        if newValue > max then newValue = max end
        Settings[id] = newValue
        local frac = (newValue-min)/(max-min)
        fill.Size = UDim2.new(frac,0,1,0)
        knob.Position = UDim2.new(frac,-8,0.5,-8)
        valueLabel.Text = tostring(newValue)
    end

    local function onInputBegan(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            -- also set immediately on click start
            if input.Position then
                pcall(function() setValueFromPosition(input.Position) end)
            end
        end
    end
    local function onInputEnded(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end
    sliderBar.InputBegan:Connect(onInputBegan)
    sliderBar.InputEnded:Connect(onInputEnded)
    knob.InputBegan:Connect(onInputBegan)
    knob.InputEnded:Connect(onInputEnded)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            setValueFromPosition(input.Position)
        end
    end)
end

-- Tabs and controls
createTab("Rage", function()
    createToggle("fly","Fly")
    createSlider("flyspeed","Fly Speed",10,200)
    createToggle("spinbot","Spinbot")
    createSlider("spinspeed","Spin Speed",1,100)
    createToggle("clicktp","Click TP (Hold T + LMB)")
    createToggle("bring","Bring Players")
end)

createTab("Aim", function()
    createToggle("aimbot","Aimbot")
    createSlider("fov","Aim FOV",10,360)
    createSlider("smooth","Aim Smooth",0,100)
    createToggle("bighead","Big Head")          -- BigHead in AIM tab
    createSlider("headsize","Head Size",1,6)    -- slider 1..6 (integer)

    -- create clickable button to increment head size
    createButton("head_inc", "Head Size", "Increase Head Size", function()
        -- increment stored value and update slider widget
        local cur = tonumber(sget("headsize", 3)) or 3
        cur = cur + 1
        if cur > 6 then cur = 1 end
        Settings["headsize"] = cur
        -- update slider UI if present
        local w = SliderWidgets["headsize"]
        if w then
            local min, max = w.min, w.max
            local frac = (cur - min) / (max - min)
            w.fill.Size = UDim2.new(frac, 0, 1, 0)
            w.knob.Position = UDim2.new(frac, -8, 0.5, -8)
            w.valueLabel.Text = tostring(cur)
        end
    end)
end)

createTab("Visual", function()
    createToggle("esp","ESP")
    createToggle("espbox","ESP Box")
    createToggle("espname","ESP Name")
    createToggle("esptracer","ESP Tracer")
    createToggle("espdist","ESP Distance")
    createSlider("distvalue","Distance",50,2000)
end)

-- ===== Features: ESP, Aim, etc. =====
local ESPs = {}
local function CreateESP(player)
    if ESPs[player] then return ESPs[player] end
    local ok, box = pcall(function() return Drawing.new("Square") end)
    local ok2, name = pcall(function() return Drawing.new("Text") end)
    local ok3, distance = pcall(function() return Drawing.new("Text") end)
    local ok4, tracer = pcall(function() return Drawing.new("Line") end)
    -- if Drawing fails, return a safe table to avoid later nil errors
    local tbl = {}
    tbl.Box = (ok and box) and box or nil
    if tbl.Box then tbl.Box.Visible=false; tbl.Box.Color=Color3.fromRGB(255,0,0); tbl.Box.Thickness=2; tbl.Box.Filled=false end
    tbl.Name = (ok2 and name) and name or nil
    if tbl.Name then tbl.Name.Visible=false; tbl.Name.Text=player.Name; tbl.Name.Color=Color3.fromRGB(255,255,255); tbl.Name.Size=18; tbl.Name.Center=true end
    tbl.Distance = (ok3 and distance) and distance or nil
    if tbl.Distance then tbl.Distance.Visible=false; tbl.Distance.Text=""; tbl.Distance.Color=Color3.fromRGB(255,255,0); tbl.Distance.Size=16; tbl.Distance.Center=true end
    tbl.Tracer = (ok4 and tracer) and tracer or nil
    if tbl.Tracer then tbl.Tracer.Visible=false; tbl.Tracer.Thickness=1; tbl.Tracer.Color=Color3.fromRGB(255,0,0) end
    ESPs[player] = tbl
    return ESPs[player]
end
local function RemoveESP(player)
    if ESPs[player] then
        if ESPs[player].Box then pcall(function() ESPs[player].Box:Remove() end) end
        if ESPs[player].Name then pcall(function() ESPs[player].Name:Remove() end) end
        if ESPs[player].Distance then pcall(function() ESPs[player].Distance:Remove() end) end
        if ESPs[player].Tracer then pcall(function() ESPs[player].Tracer:Remove() end) end
        ESPs[player] = nil
    end
end
Players.PlayerRemoving:Connect(RemoveESP)
Players.PlayerAdded:Connect(function(plr) if plr ~= LocalPlayer then CreateESP(plr) end end)
for _,p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then CreateESP(p) end end

-- BigHead sizes mapping (index 1..6) as requested
local BigHeadSizes = {
    Vector3.new(2,1,1), -- 1
    Vector3.new(2,2,2), -- 2
    Vector3.new(3,3,3), -- 3
    Vector3.new(4,4,4), -- 4
    Vector3.new(5,5,5), -- 5
    Vector3.new(6,6,6), -- 6
}

-- Use Cabesa ONLY for bighead functions (per request)
local function getOtherPlayersHeads()
    local heads = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character:FindFirstChild("Cabesa") -- only Cabesa
            if head and humanoid and humanoid.Health > 0 then
                table.insert(heads, head)
            end
        end
    end
    return heads
end

local AimCircle = Drawing.new and Drawing.new("Circle") or nil
if AimCircle then
    AimCircle.Radius = sget("fov",100)
    AimCircle.Color = Color3.fromRGB(255,0,0)
    AimCircle.Thickness = 2
    AimCircle.Filled = false
    AimCircle.Visible = false
end

local MIN_LERP_ALPHA = 0.01
local function smoothToAlpha(smoothValue)
    if smoothValue <= 0 then return 1 end
    if smoothValue >= 100 then return MIN_LERP_ALPHA end
    local t = (100 - smoothValue) / 100
    return MIN_LERP_ALPHA + (1 - MIN_LERP_ALPHA) * t
end
local AimTargetName = "Cabesa"
local function getClosestPart()
    local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest = nil
    local minDist = sget("fov",100)
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local targetPart = char:FindFirstChild(AimTargetName) or char:FindFirstChild("Head")
                if targetPart then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if (not humanoid) or (humanoid and humanoid.Health > 0) then
                        local headPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local dist = (Vector2.new(headPos.X, headPos.Y) - mousePos).Magnitude
                            if dist < minDist then
                                minDist = dist
                                closest = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    return closest
end

local lastTP = 0

-- helper to safely get head part (for restore) - only Cabesa as requested
local function getPlayerHeadPart(character)
    if not character then return nil end
    return character:FindFirstChild("Cabesa") -- only Cabesa
end

-- fallback finder (unchanged)
local function findFallbackPart(character)
    if not character then return nil end
    local candidates = {"Cabesa","Head","HumanoidRootPart","Torso","UpperTorso","LowerTorso","HumanoidRootPart"}
    for _,name in ipairs(candidates) do
        local p = character:FindFirstChild(name)
        if p and p:IsA("BasePart") then return p end
    end
    -- otherwise pick any BasePart
    for _,obj in pairs(character:GetChildren()) do
        if obj:IsA("BasePart") then return obj end
    end
    return nil
end

-- restore original head visuals & size (best-effort) -> restores to 2,1,1
local function restoreOriginalHead(player)
    if not player or not player.Character then return end
    local head = getPlayerHeadPart(player.Character)
    if head and head:IsA("BasePart") then
        pcall(function()
            head.Size = Vector3.new(2,1,1)
            local mesh = head:FindFirstChildOfClass("SpecialMesh")
            if mesh then mesh.Scale = Vector3.new(1,1,1) end
            head.Transparency = 0
            local face = head:FindFirstChild("face")
            if face and face:IsA("Decal") then face.Transparency = 0 end
            head.Massless = false
            head.CanCollide = true
        end)
    end
end

-- ===== BigHead V1 only (applies to others except localplayer) =====
local function ApplyBigHeadV1(player, scaleIndex)
    if not player or not player.Character then return end
    local head = getPlayerHeadPart(player.Character)
    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
    if head and head:IsA("BasePart") and (not humanoid or (humanoid and humanoid.Health > 0)) then
        pcall(function()
            local idx = tonumber(scaleIndex) or 1
            idx = math.floor(idx)
            if idx < 1 then idx = 1 end
            if idx > #BigHeadSizes then idx = #BigHeadSizes end
            local chosen = BigHeadSizes[idx]
            head.Size = chosen
            -- SpecialMesh handling: set scale to (1,1,1) to avoid weird deformation (we use explicit sizes)
            local mesh = head:FindFirstChildOfClass("SpecialMesh")
            if mesh then
                mesh.Scale = Vector3.new(1,1,1)
            end
            head.Transparency = 0 -- keep visuals visible
            head.Massless = true
            head.CanCollide = false
        end)
    end
end

-- Setup CharacterAdded: reapply BigHead if active (skip LocalPlayer)
local function setupCharacterHandlerFor(player)
    if not player then return end
    player.CharacterAdded:Connect(function()
        task.spawn(function()
            task.wait(0.25)
            if sget("bighead", false) and player ~= LocalPlayer and player.Character then
                local scale = tonumber(sget("headsize",3)) or 3
                if scale < 1 then scale = 1 end
                if scale > 6 then scale = 6 end
                ApplyBigHeadV1(player, scale)
            end
        end)
    end)
end
for _, plr in pairs(Players:GetPlayers()) do setupCharacterHandlerFor(plr) end
Players.PlayerAdded:Connect(function(plr) setupCharacterHandlerFor(plr) end)
Players.PlayerRemoving:Connect(function(plr) RemoveESP(plr) end)

-- ===== Main RenderStepped loop (aplica V1 e demais features) =====
RunService.RenderStepped:Connect(function()
    -- aim circle
    if AimCircle then
        AimCircle.Radius = sget("fov",100)
        AimCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        AimCircle.Visible = sget("aimbot", false)
    end

    local localRoot = nil
    if LocalPlayer and LocalPlayer.Character then
        localRoot = LocalPlayer.Character:FindFirstChild("Cabesa") or LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end

    -- BIGHEAD V1 (affects OTHER players only, uses slider headsize 1..6 mapping)
    if sget("bighead", false) then
        local scale = tonumber(sget("headsize",3)) or 3
        if scale < 1 then scale = 1 end
        if scale > 6 then scale = 6 end
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                ApplyBigHeadV1(player, scale)
            end
        end
    else
        -- restore heads when disabled
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                restoreOriginalHead(p)
            end
        end
    end

    -- FLY
    if sget("fly", false) and LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local speed = tonumber(sget("flyspeed",50)) or 50
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - Camera.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDir = moveDir - Vector3.new(0,1,0) end
        if moveDir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + moveDir.Unit * speed * 0.01
        end
    end

    -- SPINBOT
    if sget("spinbot", false) and LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local spd = tonumber(sget("spinspeed",50)) or 50
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(spd*2), 0)
    end

    -- CLICK TP (Hold T + LMB)
    if sget("clicktp", false) and LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and UserInputService:IsKeyDown(Enum.KeyCode.T) then
            local now = tick()
            if now - lastTP >= 0.5 then
                if Mouse and Mouse.Hit then
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0,3,0))
                    end)
                end
                lastTP = now
            end
        end
    end

    -- BRING PLAYERS
    if sget("bring", false) and LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local camCFrame = Camera.CFrame
        local frontPos = camCFrame.Position + camCFrame.LookVector * 15
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Cabesa") or player.Character:FindFirstChild("Head")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if head and humanoid and humanoid.Health > 0 then
                    pcall(function() head.CFrame = CFrame.new(frontPos) end)
                end
            end
        end
    end

    -- ESP
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local esp = CreateESP(player)
            local char = player.Character
            if not char then
                if esp.Box then esp.Box.Visible = false end
                if esp.Name then esp.Name.Visible = false end
                if esp.Distance then esp.Distance.Visible = false end
                if esp.Tracer then esp.Tracer.Visible = false end
            else
                local cabesa = char:FindFirstChild("Cabesa") or char:FindFirstChild("Head")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if not cabesa or (humanoid and humanoid.Health <= 0) or not sget("esp", false) then
                    if esp.Box then esp.Box.Visible = false end
                    if esp.Name then esp.Name.Visible = false end
                    if esp.Distance then esp.Distance.Visible = false end
                    if esp.Tracer then esp.Tracer.Visible = false end
                else
                    if not localRoot then
                        if esp.Box then esp.Box.Visible = false end
                        if esp.Name then esp.Name.Visible = false end
                        if esp.Distance then esp.Distance.Visible = false end
                        if esp.Tracer then esp.Tracer.Visible = false end
                    else
                        local distance = (cabesa.Position - localRoot.Position).Magnitude
                        if distance > tonumber(sget("distvalue",800)) then
                            if esp.Box then esp.Box.Visible = false end
                            if esp.Name then esp.Name.Visible = false end
                            if esp.Distance then esp.Distance.Visible = false end
                            if esp.Tracer then esp.Tracer.Visible = false end
                        else
                            local screenPos, onScreen = Camera:WorldToViewportPoint(cabesa.Position + Vector3.new(0,0.5,0))
                            if onScreen then
                                if sget("espname", false) and esp.Name then
                                    esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - 18)
                                    esp.Name.Text = player.Name
                                    esp.Name.Visible = true
                                else
                                    if esp.Name then esp.Name.Visible = false end
                                end

                                if sget("espdist", false) and esp.Distance then
                                    esp.Distance.Position = Vector2.new(screenPos.X, screenPos.Y)
                                    esp.Distance.Text = "[" .. math.floor(distance) .. "m]"
                                    esp.Distance.Visible = true
                                else
                                    if esp.Distance then esp.Distance.Visible = false end
                                end

                                if sget("esptracer", false) and esp.Tracer then
                                    esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                                    esp.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                                    esp.Tracer.Visible = true
                                else
                                    if esp.Tracer then esp.Tracer.Visible = false end
                                end

                                if sget("espbox", false) and esp.Box then
                                    local points = {}
                                    for _, part in pairs(char:GetChildren()) do
                                        if part:IsA("BasePart") then
                                            local pScreen, pOnScreen = Camera:WorldToViewportPoint(part.Position)
                                            if pOnScreen then
                                                table.insert(points, Vector2.new(pScreen.X, pScreen.Y))
                                            end
                                        end
                                    end
                                    if #points >= 2 then
                                        local minX, maxX = math.huge, -math.huge
                                        local minY, maxY = math.huge, -math.huge
                                        for _, pt in pairs(points) do
                                            if pt.X < minX then minX = pt.X end
                                            if pt.X > maxX then maxX = pt.X end
                                            if pt.Y < minY then minY = pt.Y end
                                            if pt.Y > maxY then maxY = pt.Y end
                                        end
                                        esp.Box.Position = Vector2.new(minX, minY)
                                        esp.Box.Size = Vector2.new(math.max(1, maxX - minX), math.max(1, maxY - minY))
                                        esp.Box.Visible = true
                                    else
                                        esp.Box.Visible = false
                                    end
                                else
                                    if esp.Box then esp.Box.Visible = false end
                                end
                            else
                                if esp.Name then esp.Name.Visible = false end
                                if esp.Distance then esp.Distance.Visible = false end
                                if esp.Tracer then esp.Tracer.Visible = false end
                                if esp.Box then esp.Box.Visible = false end
                            end
                        end
                    end
                end
            end
        end
    end

    -- AIMBOT
    if sget("aimbot", false) and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPart()
        if target and LocalPlayer and LocalPlayer.Character then
            local smooth = tonumber(sget("smooth",50)) or 50
            if smooth <= 0 then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            else
                local alpha = smoothToAlpha(smooth)
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), alpha)
            end
        end
    end
end)

-- Close cleanup
CloseBtn.MouseButton1Click:Connect(function()
    for _, t in pairs(ESPs) do
        if t.Box then pcall(function() t.Box:Remove() end) end
        if t.Name then pcall(function() t.Name:Remove() end) end
        if t.Distance then pcall(function() t.Distance:Remove() end) end
        if t.Tracer then pcall(function() t.Tracer:Remove() end) end
    end
    if AimCircle then pcall(function() AimCircle:Remove() end) end
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            restoreOriginalHead(p)
        end
    end
    -- remove GUI elements
    if MiniBall then pcall(function() MiniBall:Destroy() end) end
    if ScreenGui then pcall(function() ScreenGui:Destroy() end) end
end)

if game.BindToClose then
    game:BindToClose(function()
        for _, t in pairs(ESPs) do
            if t.Box then pcall(function() t.Box:Remove() end) end
            if t.Name then pcall(function() t.Name:Remove() end) end
            if t.Distance then pcall(function() t.Distance:Remove() end) end
            if t.Tracer then pcall(function() t.Tracer:Remove() end) end
        end
        if AimCircle then pcall(function() AimCircle:Remove() end) end
    end)
end

-- Ensure handlers for existing & new players
Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then CreateESP(plr) end
    setupCharacterHandlerFor(plr)
end)
for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then CreateESP(plr) end
    setupCharacterHandlerFor(plr)
end

-- End of script
