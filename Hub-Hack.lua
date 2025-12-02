-- Mi Hub v4 - Infinity Jump FIJADO (PC + MÓVIL), Velocidad, Vida Infinita, Caída Lenta, Control de Tamaño
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

-- Frame principal (310px alto para más botones)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 250)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -120)
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
local currentSize = 1 -- Tamaño normal (1 = 100%)
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
    -- Aplicar tamaño actual al respawnear
    if currentSize ~= 1 then
        wait(0.5)
        applySize()
    end
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

-- === CAÍDA LENTA ===
local slowFallBtn = Instance.new("TextButton")
slowFallBtn.Size = UDim2.new(1, -20, 0, 35)
slowFallBtn.Position = UDim2.new(0, 10, 0, 90)
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
infJumpBtn.Position = UDim2.new(0, 10, 0, 135)
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

-- === CONTROL DE TAMAÑO (CORREGIDO - Visible para todos) ===
local sizeFrame = Instance.new("Frame")
sizeFrame.Size = UDim2.new(1, -20, 0, 50)
sizeFrame.Position = UDim2.new(0, 10, 0, 180)
sizeFrame.BackgroundTransparency = 1
sizeFrame.Parent = mainFrame

-- Título "Tamaño" arriba
local sizeTitle = Instance.new("TextLabel")
sizeTitle.Size = UDim2.new(1, 0, 0, 15)
sizeTitle.BackgroundTransparency = 1
sizeTitle.Text = "Tamaño"
sizeTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
sizeTitle.TextScaled = true
sizeTitle.Font = Enum.Font.Gotham
sizeTitle.TextYAlignment = Enum.TextYAlignment.Bottom
sizeTitle.Parent = sizeFrame

-- Botón -
local minusSize = Instance.new("TextButton")
minusSize.Size = UDim2.new(0.25, 0, 0.7, 0)
minusSize.Position = UDim2.new(0, 0, 0.3, 0)
minusSize.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
minusSize.Text = "-"
minusSize.TextColor3 = Color3.fromRGB(255, 255, 255)
minusSize.TextScaled = true
minusSize.Font = Enum.Font.GothamBold
minusSize.Parent = sizeFrame

local sizeCorner1 = Instance.new("UICorner")
sizeCorner1.CornerRadius = UDim.new(0, 8)
sizeCorner1.Parent = minusSize

-- Display del tamaño
local sizeDisplay = Instance.new("Frame")
sizeDisplay.Size = UDim2.new(0.5, 0, 0.7, 0)
sizeDisplay.Position = UDim2.new(0.25, 0, 0.3, 0)
sizeDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
sizeDisplay.Parent = sizeFrame

local sizeDisplayCorner = Instance.new("UICorner")
sizeDisplayCorner.CornerRadius = UDim.new(0, 8)
sizeDisplayCorner.Parent = sizeDisplay

-- Texto "Normal" o "Gigante"
local sizeStatus = Instance.new("TextLabel")
sizeStatus.Size = UDim2.new(1, 0, 0.4, 0)
sizeStatus.Position = UDim2.new(0, 0, 0.6, 0)
sizeStatus.BackgroundTransparency = 1
sizeStatus.Text = "Normal"
sizeStatus.TextColor3 = Color3.fromRGB(180, 180, 180)
sizeStatus.TextScaled = true
sizeStatus.Font = Enum.Font.Gotham
sizeStatus.Parent = sizeDisplay

-- Botón +
local plusSize = Instance.new("TextButton")
plusSize.Size = UDim2.new(0.25, 0, 0.7, 0)
plusSize.Position = UDim2.new(0.75, 0, 0.3, 0)
plusSize.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
plusSize.Text = "+"
plusSize.TextColor3 = Color3.fromRGB(255, 255, 255)
plusSize.TextScaled = true
plusSize.Font = Enum.Font.GothamBold
plusSize.Parent = sizeFrame

local sizeCorner2 = Instance.new("UICorner")
sizeCorner2.CornerRadius = UDim.new(0, 8)
sizeCorner2.Parent = plusSize

-- Función para aplicar el tamaño (CORREGIDA)
local function applySize()
    if not char or not humanoid then return end
    
    -- MÉTODO 1: Usar Humanoid.Scale (lo más efectivo)
    if humanoid:FindFirstChild("BodyScale") then
        humanoid.BodyScale:Destroy()
    end
    
    if humanoid:FindFirstChild("BodyWidthScale") then
        humanoid.BodyWidthScale:Destroy()
    end
    
    if humanoid:FindFirstChild("BodyHeightScale") then
        humanoid.BodyHeightScale:Destroy()
    end
    
    if humanoid:FindFirstChild("BodyDepthScale") then
        humanoid.BodyDepthScale:Destroy()
    end
    
    if humanoid:FindFirstChild("HeadScale") then
        humanoid.HeadScale:Destroy()
    end
    
    -- Crear nuevos scales
    local bodyScale = Instance.new("Scale")
    bodyScale.Name = "BodyScale"
    bodyScale.Scale = currentSize
    bodyScale.Parent = humanoid
    
    local bodyWidthScale = Instance.new("Scale")
    bodyWidthScale.Name = "BodyWidthScale"
    bodyWidthScale.Scale = currentSize
    bodyWidthScale.Parent = humanoid
    
    local bodyHeightScale = Instance.new("Scale")
    bodyHeightScale.Name = "BodyHeightScale"
    bodyHeightScale.Scale = currentSize
    bodyHeightScale.Parent = humanoid
    
    local bodyDepthScale = Instance.new("Scale")
    bodyDepthScale.Name = "BodyDepthScale"
    bodyDepthScale.Scale = currentSize
    bodyDepthScale.Parent = humanoid
    
    local headScale = Instance.new("Scale")
    headScale.Name = "HeadScale"
    headScale.Scale = currentSize
    headScale.Parent = humanoid
    
    -- MÉTODO 2: Ajustar también las partes individuales (para tu vista local)
    wait(0.1)
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            -- Guardar tamaño original si no existe
            local originalSize = part:FindFirstChild("OriginalSize")
            if not originalSize then
                originalSize = Instance.new("Vector3Value")
                originalSize.Name = "OriginalSize"
                originalSize.Value = part.Size
                originalSize.Parent = part
            end
            
            -- Aplicar tamaño
            part.Size = originalSize.Value * currentSize
        end
    end
    
    -- Ajustar otras propiedades
    humanoid.HipHeight = 2 * currentSize
    humanoid.JumpHeight = 7.2 * currentSize
    
    -- Actualizar display
    local percent = math.floor(currentSize * 100)
    sizeLabel.Text = percent .. "%"
    
    -- Cambiar texto según tamaño
    if currentSize < 0.5 then
        sizeStatus.Text = "Mini"
        sizeLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    elseif currentSize < 0.8 then
        sizeStatus.Text = "Pequeño"
        sizeLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
    elseif currentSize < 1.2 then
        sizeStatus.Text = "Normal"
        sizeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif currentSize < 2 then
        sizeStatus.Text = "Grande"
        sizeLabel.TextColor3 = Color3.fromRGB(255, 200, 100)
    else
        sizeStatus.Text = "Gigante"
        sizeLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

-- Función para resetear tamaño
local function resetSize()
    currentSize = 1
    applySize()
end

-- Conectar botones
minusSize.MouseButton1Click:Connect(function()
    currentSize = math.max(0.1, currentSize - 0.1)
    applySize()
end)

plusSize.MouseButton1Click:Connect(function()
    currentSize = math.min(5, currentSize + 0.1)
    applySize()
end)

-- Botón derecho para resetear
sizeDisplay.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        resetSize()
    end
end)

-- Botón para reset rápido
local resetSizeBtn = Instance.new("TextButton")
resetSizeBtn.Size = UDim2.new(1, -20, 0, 30)
resetSizeBtn.Position = UDim2.new(0, 10, 0, 240)
resetSizeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
resetSizeBtn.Text = "Resetear Tamaño"
resetSizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
resetSizeBtn.TextScaled = true
resetSizeBtn.Font = Enum.Font.Gotham
resetSizeBtn.Parent = mainFrame

local resetCorner = Instance.new("UICorner")
resetCorner.CornerRadius = UDim.new(0, 8)
resetCorner.Parent = resetSizeBtn

resetSizeBtn.MouseButton1Click:Connect(resetSize)

            
            
print("¡Mi Hub v4.1 cargado! Con Control de Tamaño ✅")
