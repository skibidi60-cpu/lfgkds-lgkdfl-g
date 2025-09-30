-- LOAD LIBRARY
local library = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/ShaddowScripts/Main/main/Library"))()
local Main = library:CreateWindow("MT HAZE","Crimson")

-- CREATE TABS
local tabRage = Main:CreateTab("Rage")
local tabAim = Main:CreateTab("Aim")
local tabVisual = Main:CreateTab("Visual")

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

---------------------------------------------------------
-- SINGLE GUI MINIMIZE (Insert)
local guiHidden = false
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        guiHidden = not guiHidden
        local ok = pcall(function() Main:Toggle(not guiHidden) end)
        if not ok then
            pcall(function() Main:Toggle() end)
        end
        local CoreGui = game:GetService("CoreGui")
        for _,g in pairs(CoreGui:GetChildren()) do
            if g:IsA("ScreenGui") and (g.Name:lower():find("shaddow") or g.Name:lower():find("library") or g.Name:lower():find("by shaddow")) then
                g.Enabled = not guiHidden
            end
        end
    end
end)

---------------------------------------------------------
-- SHARED FLAGS / CONFIGS
ESPTracerUpEnabled = false

-- ESP
local ESPEnabled = false
local ESPBoxEnabled = false
local ESPNameEnabled = false
local ESPDistanceEnabled = false
local MaxESPDistance = 800
local ESPs = {}

-- AIMBOT
local AimbotEnabled = false
local AimFOV = 100
local AimTarget = "Cabesa"
local AimSmooth = 50
local MIN_LERP_ALPHA = 0.01

-- Drawings: Aim circle
local AimCircle = Drawing.new("Circle")
AimCircle.Radius = AimFOV
AimCircle.Color = Color3.fromRGB(255,0,0)
AimCircle.Thickness = 2
AimCircle.Filled = false
AimCircle.Visible = false

-- RAGE FEATURES
local BigHeadEnabled = false
local HeadSizeValue = 6

local FlyEnabled = false
local FlySpeed = 50

local SpinbotEnabled = false
local SpinSpeed = 50

local ClickTPEnabled = false
local BringPlayersEnabled = false
local lastTP = 0 -- cooldown ClickTP

---------------------------------------------------------
-- UTIL: create/remove ESP drawings
local function CreateESP(player)
    if ESPs[player] then return ESPs[player] end

    local box = Drawing.new("Square")
    box.Visible = false
    box.Color = Color3.fromRGB(255,0,0)
    box.Thickness = 2
    box.Filled = false

    local name = Drawing.new("Text")
    name.Visible = false
    name.Text = player.Name
    name.Color = Color3.fromRGB(255,255,255)
    name.Size = 18
    name.Center = true

    local distance = Drawing.new("Text")
    distance.Visible = false
    distance.Text = ""
    distance.Color = Color3.fromRGB(255,255,0)
    distance.Size = 16
    distance.Center = true

    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 1

    ESPs[player] = {Box = box, Name = name, Distance = distance, Tracer = tracer}
    return ESPs[player]
end

local function RemoveESP(player)
    if ESPs[player] then
        if ESPs[player].Box then ESPs[player].Box:Remove() end
        if ESPs[player].Name then ESPs[player].Name:Remove() end
        if ESPs[player].Distance then ESPs[player].Distance:Remove() end
        if ESPs[player].Tracer then ESPs[player].Tracer:Remove() end
        ESPs[player] = nil
    end
end

Players.PlayerRemoving:Connect(RemoveESP)
for _,p in pairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        CreateESP(p)
    end
end

---------------------------------------------------------
-- UTIL: get all other players' "Cabesa" parts (alive)
local function getOtherPlayersHeads()
    local heads = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            local head = player.Character:FindFirstChild("Cabesa")
            if head and humanoid and humanoid.Health > 0 then
                table.insert(heads, head)
            end
        end
    end
    return heads
end

---------------------------------------------------------
-- AIM UTIL
local function getClosestPart()
    local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local closest = nil
    local minDist = AimFOV
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char then
                local targetPart = char:FindFirstChild(AimTarget)
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

local function smoothToAlpha(smoothValue)
    if smoothValue <= 0 then
        return 1
    end
    if smoothValue >= 100 then
        return MIN_LERP_ALPHA
    end
    local t = (100 - smoothValue) / 100
    local alpha = MIN_LERP_ALPHA + (1 - MIN_LERP_ALPHA) * t
    return alpha
end

---------------------------------------------------------
-- MAIN LOOP
RunService.RenderStepped:Connect(function()
    local localRootPart = nil
    if LocalPlayer.Character then
        localRootPart = LocalPlayer.Character:FindFirstChild("Cabesa") or LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end

    -- BIG HEAD
    if BigHeadEnabled then
        for _, head in pairs(getOtherPlayersHeads()) do
            if head and head:IsA("BasePart") then
                pcall(function()
                    head.Size = Vector3.new(HeadSizeValue, HeadSizeValue, HeadSizeValue)
                    head.Transparency = 0.5
                end)
            end
        end
    else
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Cabesa")
                if head and head:IsA("BasePart") then
                    pcall(function()
                        head.Size = Vector3.new(2,1,1)
                        head.Transparency = 0
                    end)
                end
            end
        end
    end

    -- FLY
    if FlyEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local camLook = Camera.CFrame.LookVector
        local moveDir = Vector3.new(0,0,0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camLook end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0,1,0) end
        if moveDir.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + moveDir.Unit * FlySpeed * 0.01
        end
    end

    -- SPINBOT
    if SpinbotEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(SpinSpeed*2), 0)
    end

    -- CLICK TP (com delay de 0.5s)
    if ClickTPEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and UserInputService:IsKeyDown(Enum.KeyCode.T) then
            local now = tick()
            if now - lastTP >= 0.5 then
                local mouse = LocalPlayer:GetMouse()
                if mouse and mouse.Hit then
                    pcall(function()
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0,3,0))
                    end)
                end
                lastTP = now
            end
        end
    end

    -- BRING PLAYERS
    if BringPlayersEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local camCFrame = Camera.CFrame
        local frontPos = camCFrame.Position + camCFrame.LookVector * 15
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local head = player.Character:FindFirstChild("Cabesa")
                local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                if head and humanoid and humanoid.Health > 0 then
                    pcall(function()
                        head.CFrame = CFrame.new(frontPos)
                    end)
                end
            end
        end
    end

    -- ESP
    for _,player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local esp = CreateESP(player)
            local char = player.Character
            if not char then
                if esp.Box then esp.Box.Visible = false end
                esp.Name.Visible = false
                esp.Distance.Visible = false
                if esp.Tracer then esp.Tracer.Visible = false end
            else
                local cabesa = char:FindFirstChild("Cabesa")
                local humanoid = char:FindFirstChildOfClass("Humanoid")
                if not cabesa or (humanoid and humanoid.Health <= 0) then
                    if esp.Box then esp.Box.Visible = false end
                    esp.Name.Visible = false
                    esp.Distance.Visible = false
                    if esp.Tracer then esp.Tracer.Visible = false end
                else
                    if not localRootPart then
                        if esp.Box then esp.Box.Visible = false end
                        esp.Name.Visible = false
                        esp.Distance.Visible = false
                        if esp.Tracer then esp.Tracer.Visible = false end
                    else
                        local distance = (cabesa.Position - localRootPart.Position).Magnitude
                        if distance > MaxESPDistance or not ESPEnabled then
                            if esp.Box then esp.Box.Visible = false end
                            esp.Name.Visible = false
                            esp.Distance.Visible = false
                            if esp.Tracer then esp.Tracer.Visible = false end
                        else
                            local screenPos, onScreen = Camera:WorldToViewportPoint(cabesa.Position + Vector3.new(0,0.5,0))
                            if onScreen then
                                if ESPNameEnabled then
                                    esp.Name.Position = Vector2.new(screenPos.X, screenPos.Y - 18)
                                    esp.Name.Text = player.Name
                                    esp.Name.Visible = true
                                else
                                    esp.Name.Visible = false
                                end

                                if ESPDistanceEnabled then
                                    esp.Distance.Position = Vector2.new(screenPos.X, screenPos.Y)
                                    esp.Distance.Text = "[" .. math.floor(distance) .. "m]"
                                    esp.Distance.Visible = true
                                else
                                    esp.Distance.Visible = false
                                end

                                if ESPTracerUpEnabled and esp.Tracer then
                                    esp.Tracer.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                                    esp.Tracer.To = Vector2.new(screenPos.X, screenPos.Y)
                                    esp.Tracer.Visible = true
                                    esp.Tracer.Color = Color3.fromRGB(255, 0, 0)
                                else
                                    if esp.Tracer then esp.Tracer.Visible = false end
                                end
                            else
                                esp.Name.Visible = false
                                esp.Distance.Visible = false
                                if esp.Tracer then esp.Tracer.Visible = false end
                            end

                            if ESPBoxEnabled and esp.Box then
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
                        end
                    end
                end
            end
        end
    end

    -- AIMBOT
    AimCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    if AimbotEnabled and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = getClosestPart()
        if target and LocalPlayer.Character then
            if AimSmooth == 0 then
                Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            else
                local alpha = smoothToAlpha(AimSmooth)
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), alpha)
            end
        end
    end
end)

---------------------------------------------------------
-- GUI AIM
tabAim:CreateCheckbox("Aimbot", function(state)
    AimbotEnabled = state
    AimCircle.Visible = state
end)

tabAim:CreateSlider("Aim FOV", 1, 300, function(value)
    AimFOV = value
    AimCircle.Radius = value
end)

tabAim:CreateSlider("Aim Smooth", 0, 100, function(value)
    AimSmooth = value
end)

tabAim:CreateToggle("Big Head", function(state)
    BigHeadEnabled = state
end)
tabAim:CreateSlider("Head Size", 1, 20, function(value)
    HeadSizeValue = value
end)

tabAim:Show()

---------------------------------------------------------
-- GUI RAGE
tabRage:CreateToggle("Fly", function(state) FlyEnabled = state end)
tabRage:CreateSlider("Fly Speed", 10, 200, function(value) FlySpeed = value end)

tabRage:CreateToggle("Spinbot", function(state) SpinbotEnabled = state end)
tabRage:CreateSlider("Spin Speed", 1, 100, function(value) SpinSpeed = value end)

tabRage:CreateToggle("Click TP (Hold T + LMB)", function(state) ClickTPEnabled = state end)
tabRage:CreateToggle("Bring Players", function(state) BringPlayersEnabled = state end)

---------------------------------------------------------
-- GUI VISUAL
tabVisual:CreateCheckbox("ESP", function(state)
    ESPEnabled = state
end)

tabVisual:CreateCheckbox("ESP Box", function(state)
    ESPBoxEnabled = state
end)

tabVisual:CreateCheckbox("ESP Name", function(state)
    ESPNameEnabled = state
end)

tabVisual:CreateCheckbox("ESP Tracer", function(state)
    ESPTracerUpEnabled = state
end)

tabVisual:CreateCheckbox("ESP Distance", function(state)
    ESPDistanceEnabled = state
end)

tabVisual:CreateSlider("Distance", 50, 1000, function(value)
    MaxESPDistance = value
end)

---------------------------------------------------------
-- CLEANUP ON LEAVE
game:BindToClose(function()
    for _, t in pairs(ESPs) do
        if t.Box then pcall(function() t.Box:Remove() end) end
        if t.Name then pcall(function() t.Name:Remove() end) end
        if t.Distance then pcall(function() t.Distance:Remove() end) end
        if t.Tracer then pcall(function() t.Tracer:Remove() end) end
    end
    if AimCircle then pcall(function() AimCircle:Remove() end) end
end)
