-- Mi Hub v4 - Infinity Jump FIJADO (PC + MÓVIL), Velocidad, Vida Infinita, Caída Lenta
-- ¡Infinity Jump ahora PERFECTO en celular! Usa JumpRequest interno de Roblox.

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

-- Frame principal (260px alto)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 260)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -130)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Arrastrable PROPIO (PC + MÓVIL perfecto)
local dragging = false
local dragStart = nil
local startPos = nil

local function updateMainDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                conn:Disconnect()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateMainDrag(input)
    end
end)

-- Título (barra superior arrastrable también)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Mi Hub v4"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Botón flotante H/+ (también arrastrable)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 55, 0, 55)
toggleBtn.Position = UDim2.new(0.5, -27.5, 0.5, -27.5)
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.Text = "H"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(1, 0)
toggleCorner.Parent = toggleBtn

local draggingToggle = false
local dragStartToggle = nil
local startPosToggle = nil

local function updateToggleDrag(input)
    local delta = input.Position - dragStartToggle
    toggleBtn.Position = UDim2.new(startPosToggle.X.Scale, startPosToggle.X.Offset + delta.X, startPosToggle.Y.Scale, startPosToggle.Y.Offset + delta.Y)
end

toggleBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingToggle = true
        dragStartToggle = input.Position
        startPosToggle = toggleBtn.Position
        
        local conn
        conn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingToggle = false
                conn:Disconnect()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateToggleDrag(input)
    end
end)

-- Toggle hub
local hubVisible = true
toggleBtn.MouseButton1Click:Connect(function()
    hubVisible = not hubVisible
    mainFrame.Visible = hubVisible
    toggleBtn.Text = hubVisible and "H" or "+"
    toggleBtn.BackgroundColor3 = hubVisible and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(255, 170, 0)
end)

-- Variables
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local currentSpeed = 16
local infJumpEnabled = false
local godEnabled = false
local slowFallEnabled = false
local connections = {}

-- Respawn handler
local function onCharacterAdded(newChar)
    char = newChar
    humanoid = newChar:WaitForChild("Humanoid")
    humanoid.WalkSpeed = currentSpeed
    wait(0.1)
    if godEnabled then startGod() end
    if slowFallEnabled then startSlowFall() end
    if infJumpEnabled then startInfJump() end
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

-- === VELOCIDAD Ajustable ===
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, -20, 0, 35)
speedFrame.Position = UDim2.new(0, 10, 0, 45)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainFrame

local minusSpeed = Instance.new("TextButton")
minusSpeed.Size = UDim2.new(0.3, 0, 1, 0)
minusSpeed.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minusSpeed.Text = "-"
minusSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
minusSpeed.TextScaled = true
minusSpeed.Font = Enum.Font.GothamBold
minusSpeed.Parent = speedFrame

local speedCorner1 = Instance.new("UICorner")
speedCorner1.CornerRadius = UDim.new(0, 8)
speedCorner1.Parent = minusSpeed

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 1, 0)
speedLabel.Position = UDim2.new(0.3, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "16"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = speedFrame

local plusSpeed = Instance.new("TextButton")
plusSpeed.Size = UDim2.new(0.3, 0, 1, 0)
plusSpeed.Position = UDim2.new(0.7, 0, 0, 0)
plusSpeed.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
plusSpeed.Text = "+"
plusSpeed.TextColor3 = Color3.fromRGB(255, 255, 255)
plusSpeed.TextScaled = true
plusSpeed.Font = Enum.Font.GothamBold
plusSpeed.Parent = speedFrame

local speedCorner2 = Instance.new("UICorner")
speedCorner2.CornerRadius = UDim.new(0, 8)
speedCorner2.Parent = plusSpeed

local function applySpeed()
    if humanoid then
        humanoid.WalkSpeed = currentSpeed
        speedLabel.Text = tostring(math.floor(currentSpeed))
    end
end

minusSpeed.MouseButton1Click:Connect(function()
    currentSpeed = math.max(16, currentSpeed - 8)
    applySpeed()
end)

plusSpeed.MouseButton1Click:Connect(function()
    currentSpeed = math.min(200, currentSpeed + 8)
    applySpeed()
end)

-- === VIDA INFINITA ===
local godBtn = Instance.new("TextButton")
godBtn.Size = UDim2.new(1, -20, 0, 35)
godBtn.Position = UDim2.new(0, 10, 0, 90)
godBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
godBtn.Text = "Vida Infinita: OFF"
godBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
godBtn.TextScaled = true
godBtn.Font = Enum.Font.Gotham
godBtn.Parent = mainFrame

local godCorner = Instance.new("UICorner")
godCorner.CornerRadius = UDim.new(0, 8)
godCorner.Parent = godBtn

local function startGod()
    if connections.god then return end
    connections.god = RunService.Heartbeat:Connect(function()
        if humanoid and humanoid.Health < humanoid.MaxHealth and humanoid.Health > 0 then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

local function stopGod()
    if connections.god then
        connections.god:Disconnect()
        connections.god = nil
    end
end

godBtn.MouseButton1Click:Connect(function()
    godEnabled = not godEnabled
    godBtn.Text = "Vida Infinita: " .. (godEnabled and "ON" or "OFF")
    godBtn.BackgroundColor3 = godEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
    if godEnabled then
        startGod()
    else
        stopGod()
    end
end)

-- === CAÍDA LENTA ===
local slowFallBtn = Instance.new("TextButton")
slowFallBtn.Size = UDim2.new(1, -20, 0, 35)
slowFallBtn.Position = UDim2.new(0, 10, 0, 135)
slowFallBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
slowFallBtn.Text = "Caída Lenta: OFF"
slowFallBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
slowFallBtn.TextScaled = true
slowFallBtn.Font = Enum.Font.Gotham
slowFallBtn.Parent = mainFrame

local slowCorner = Instance.new("UICorner")
slowCorner.CornerRadius = UDim.new(0, 8)
slowCorner.Parent = slowFallBtn

local function startSlowFall()
    if connections.fall then return end
    connections.fall = RunService.Heartbeat:Connect(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, math.max(hrp.Velocity.Y, -25), hrp.Velocity.Z)
        end
    end)
end

local function stopSlowFall()
    if connections.fall then
        connections.fall:Disconnect()
        connections.fall = nil
    end
end

slowFallBtn.MouseButton1Click:Connect(function()
    slowFallEnabled = not slowFallEnabled
    slowFallBtn.Text = "Caída Lenta: " .. (slowFallEnabled and "ON" or "OFF")
    slowFallBtn.BackgroundColor3 = slowFallEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
    if slowFallEnabled then
        startSlowFall()
    else
        stopSlowFall()
    end
end)

-- === INFINITY JUMP FIJADO (PC + CELULAR) ===
local infJumpBtn = Instance.new("TextButton")
infJumpBtn.Size = UDim2.new(1, -20, 0, 35)
infJumpBtn.Position = UDim2.new(0, 10, 0, 180)
infJumpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
infJumpBtn.Text = "Infinity Jump: OFF"
infJumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
infJumpBtn.TextScaled = true
infJumpBtn.Font = Enum.Font.Gotham
infJumpBtn.Parent = mainFrame

local infCorner = Instance.new("UICorner")
infCorner.CornerRadius = UDim.new(0, 8)
infCorner.Parent = infJumpBtn

local function startInfJump()
    if connections.infjump then return end
    connections.infjump = UserInputService.JumpRequest:Connect(function()
        if humanoid and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function stopInfJump()
    if connections.infjump then
        connections.infjump:Disconnect()
        connections.infjump = nil
    end
end

infJumpBtn.MouseButton1Click:Connect(function()
    infJumpEnabled = not infJumpEnabled
    infJumpBtn.Text = "Infinity Jump: " .. (infJumpEnabled and "ON" or "OFF")
    infJumpBtn.BackgroundColor3 = infJumpEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
    if infJumpEnabled then
        startInfJump()
    else
        stopInfJump()
    end
end)

print("¡Mi Hub v4 cargado! Infinity Jump FIJADO para MÓVIL 🚀")
