-- Mi Hub v3 - Infinity Jump + Velocidad + Vida Infinita + Caída Lenta
-- Todo local, móvil perfecto, arrastrable, botón H/+

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal (alto 260px)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 260)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner", mainFrame)
corner.CornerRadius = UDim.new(0, 12)

-- Hacer arrastrable el hub
local dragging, dragStart, startPos
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
mainFrame.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
mainFrame.InputEnded:Connect(function() dragging = false end)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
title.Text = "Mi Hub"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

-- Botón flotante H/+
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0.5, -27.5, 0.5, -27.5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.Text = "H"
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = screenGui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1, 0)

-- Arrastrar botón H también
local draggingBtn = false
toggleBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = true
        dragStart = i.Position
        startPos = toggleBtn.Position
    end
end)
toggleBtn.InputChanged:Connect(function(i)
    if draggingBtn and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local delta = i.Position - dragStart
        toggleBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
toggleBtn.InputEnded:Connect(function() draggingBtn = false end)

local visible = true
toggleBtn.MouseButton1Click:Connect(function()
    visible = not visible
    mainFrame.Visible = visible
    toggleBtn.Text = visible and "H" or "+"
    toggleBtn.BackgroundColor3 = visible and Color3.fromRGB(0,170,255) or Color3.fromRGB(255,170,0)
end)

-- Variables
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local currentSpeed = 16
local infJumpEnabled = false
local godEnabled = false
local slowFallEnabled = false
local connections = {}

-- Respawn
player.CharacterAdded:Connect(function(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoid.WalkSpeed = currentSpeed
    wait(0.1)
    if godEnabled then startGod() end
    if slowFallEnabled then startSlowFall() end
    if infJumpEnabled then startInfJump() end
end)

-- === VELOCIDAD ===
local y = 45
local speedFrame = Instance.new("Frame", mainFrame)
speedFrame.Size = UDim2.new(1,-20,0,35)
speedFrame.Position = UDim2.new(0,10,0,y)
speedFrame.BackgroundTransparency = 1

local minus = Instance.new("TextButton", speedFrame)
minus.Size = UDim2.new(0.3,0,1,0)
minus.BackgroundColor3 = Color3.fromRGB(200,50,50)
minus.Text = "-"
minus.TextScaled = true
Instance.new("UICorner", minus).CornerRadius = UDim.new(0,8)

local speedLbl = Instance.new("TextLabel", speedFrame)
speedLbl.Size = UDim2.new(0.4,0,1,0)
speedLbl.Position = UDim2.new(0.3,0,0,0)
speedLbl.BackgroundTransparency = 1
speedLbl.Text = "16"
speedLbl.TextColor3 = Color3.new(1,1,1)
speedLbl.TextScaled = true

local plus = Instance.new("TextButton", speedFrame)
plus.Size = UDim2.new(0.3,0,1,0)
plus.Position = UDim2.new(0.7,0,0,0)
plus.BackgroundColor3 = Color3.fromRGB(50,200,50)
plus.Text = "+"
plus.TextScaled = true
Instance.new("UICorner", plus).CornerRadius = UDim.new(0,8)

minus.MouseButton1Click:Connect(function()
    currentSpeed = math.max(16, currentSpeed - 8)
    humanoid.WalkSpeed = currentSpeed
    speedLbl.Text = tostring(currentSpeed)
end)
plus.MouseButton1Click:Connect(function()
    currentSpeed = math.min(200, currentSpeed + 8)
    humanoid.WalkSpeed = currentSpeed
    speedLbl.Text = tostring(currentSpeed)
end)

-- === VIDA INFINITA ===
y += 45
local godBtn = Instance.new("TextButton", mainFrame)
godBtn.Size = UDim2.new(1,-20,0,35)
godBtn.Position = UDim2.new(0,10,0,y)
godBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
godBtn.Text = "Vida Infinita: OFF"
godBtn.TextColor3 = Color3.new(1,1,1)
godBtn.TextScaled = true
Instance.new("UICorner", godBtn).CornerRadius = UDim.new(0,8)

local function startGod()
    connections.god = RunService.Heartbeat:Connect(function()
        if humanoid.Health < humanoid.MaxHealth and humanoid.Health > 0 then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

godBtn.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    godBtn.Text = "Vida Infinita: " .. (godEnabled and "ON" or "OFF")
    godBtn.BackgroundColor3 = godEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(60,60,60)
    if godEnabled then startGod() else if connections.god then connections.god:Disconnect() end end
end)

-- === CAÍDA LENTA ===
y += 45
local fallBtn = Instance.new("TextButton", mainFrame)
fallBtn.Size = UDim2.new(1,-20,0,35)
fallBtn.Position = UDim2.new(0,10,0,y)
fallBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
fallBtn.Text = "Caída Lenta: OFF"
fallBtn.TextColor3 = Color3.new(1,1,1)
fallBtn.TextScaled = true
Instance.new("UICorner", fallBtn).CornerRadius = UDim.new(0,8)

local function startSlowFall()
    connections.fall = RunService.Heartbeat:Connect(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, math.max(hrp.Velocity.Y, -25), hrp.Velocity.Z)
        end
    end)
end

fallBtn.MouseButton1Click:Connect(function()
    slowFallEnabled = not slowFallEnabled
    fallBtn.Text = "Caída Lenta: " .. (slowFallEnabled and "ON" or "OFF")
    fallBtn.BackgroundColor3 = slowFallEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(60,60,60)
    if slowFallEnabled then startSlowFall() else if connections.fall then connections.fall:Disconnect() end end
end)

-- === INFINITY JUMP (NUEVO) ===
y += 45
local infJumpBtn = Instance.new("TextButton", mainFrame)
infJumpBtn.Size = UDim2.new(1,-20,0,35)
infJumpBtn.Position = UDim2.new(0,10,0,y)
infJumpBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
infJumpBtn.Text = "Infinity Jump: OFF"
infJumpBtn.TextColor3 = Color3.new(1,1,1)
infJumpBtn.TextScaled = true
Instance.new("UICorner", infJumpBtn).CornerRadius = UDim.new(0,8)

local function startInfJump()
    connections.infjump = UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Space and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

infJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    infJumpBtn.Text = "Infinity Jump: " .. (infJumpEnabled and "ON" or "OFF")
    infJumpBtn.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(0,255,0) or Color3.fromRGB(60,60,60)
    if infJumpEnabled then startInfJump() else if connections.infjump then connections.infjump:Disconnect() end end
end)

print("Mi Hub v3 cargado - Infinity Jump agregado!")
