-- Script Hub Seguro para Roblox (Local - Usa bajo tu propio riesgo, no abuses para evitar detecciones)
-- Funciones: Velocidad Ajustable (+/-), Vida Infinita (Godmode), Caída Lenta
-- Hub pequeño, arrastrable, adaptado para móvil, aparece centrado. Botón flotante H/+ para mostrar/ocultar.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui  -- Cambia a game:GetService("CoreGui") si tu executor lo requiere

-- Frame principal (pequeño y centrado)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 200)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Hacer arrastrable (funciona en PC y móvil)
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
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
        updateDrag(input)
    end
end)

-- Barra de título
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
titleLabel.Text = "Mi Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = titleBar

-- Botón flotante para mostrar/ocultar (H cuando visible, + cuando oculto)
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

-- Arrastrable para botón flotante también
local draggingToggle = false
local dragStartToggle = nil
local startPosToggle = nil

local function updateDragToggle(input)
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
        updateDragToggle(input)
    end
end)

-- Toggle visibilidad
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
local minSpeed = 16
local maxSpeed = 200  -- Máx para no abusar
local godEnabled = false
local slowFallEnabled = false
local godConnection = nil
local slowFallConnection = nil

-- Función para nuevo personaje (respawn)
local function onCharacterAdded(newChar)
    char = newChar
    humanoid = char:WaitForChild("Humanoid")
    humanoid.WalkSpeed = currentSpeed
    
    -- Reiniciar si activados
    wait(0.1)
    if godEnabled then startGod() end
    if slowFallEnabled then startSlowFall() end
end

player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then onCharacterAdded(player.Character) end

-- Speed: Botones +/-
local speedFrame = Instance.new("Frame")
speedFrame.Size = UDim2.new(1, -20, 0, 35)
speedFrame.Position = UDim2.new(0, 10, 0, 45)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainFrame

local minusBtn = Instance.new("TextButton")
minusBtn.Size = UDim2.new(0.3, 0, 1, 0)
minusBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minusBtn.Text = "-"
minusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minusBtn.TextScaled = true
minusBtn.Font = Enum.Font.GothamBold
minusBtn.Parent = speedFrame

local btnCorner1 = Instance.new("UICorner")
btnCorner1.CornerRadius = UDim.new(0, 8)
btnCorner1.Parent = minusBtn

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.4, 0, 1, 0)
speedLabel.Position = UDim2.new(0.3, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "16"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = speedFrame

local plusBtn = Instance.new("TextButton")
plusBtn.Size = UDim2.new(0.3, 0, 1, 0)
plusBtn.Position = UDim2.new(0.7, 0, 0, 0)
plusBtn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
plusBtn.Text = "+"
plusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
plusBtn.TextScaled = true
plusBtn.Font = Enum.Font.GothamBold
plusBtn.Parent = speedFrame

local btnCorner2 = Instance.new("UICorner")
btnCorner2.CornerRadius = UDim.new(0, 8)
btnCorner2.Parent = plusBtn

local function applySpeed()
    if humanoid then
        humanoid.WalkSpeed = currentSpeed
        speedLabel.Text = tostring(math.floor(currentSpeed))
    end
end

minusBtn.MouseButton1Click:Connect(function()
    currentSpeed = math.max(minSpeed, currentSpeed - 8)
    applySpeed()
end)

plusBtn.MouseButton1Click:Connect(function()
    currentSpeed = math.min(maxSpeed, currentSpeed + 8)
    applySpeed()
end)

-- Godmode Toggle
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
    if godConnection then return end
    godConnection = RunService.Heartbeat:Connect(function()
        if humanoid and humanoid.Health < humanoid.MaxHealth and humanoid.Health > 0 then
            humanoid.Health = humanoid.MaxHealth
        end
    end)
end

local function stopGod()
    if godConnection then
        godConnection:Disconnect()
        godConnection = nil
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

-- Caída Lenta Toggle
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
    if slowFallConnection then return end
    slowFallConnection = RunService.Heartbeat:Connect(function()
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            hrp.Velocity = Vector3.new(hrp.Velocity.X, math.max(hrp.Velocity.Y, -25), hrp.Velocity.Z)
        end
    end)
end

local function stopSlowFall()
    if slowFallConnection then
        slowFallConnection:Disconnect()
        slowFallConnection = nil
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

print("¡Hub cargado! Arrastra el botón H/+ y el hub. Usa con cuidadoo ⚠️")
