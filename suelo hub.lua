-- Variables globales
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Configuración
local FLOOR_DURATION = 2  -- Segundos que dura el suelo
local FLOOR_COLOR = Color3.fromRGB(255, 0, 0)  -- Color rojo
local FLOOR_SIZE = Vector3.new(4, 0.2, 4)  -- Tamaño de las plataformas

-- Almacenar suelos creados
local activeFloors = {}

-- Función para crear un suelo temporal
local function createTemporaryFloor(position, player)
    -- Crear la parte
    local floor = Instance.new("Part")
    floor.Name = "TemporaryFloor"
    floor.Size = FLOOR_SIZE
    floor.Position = position + Vector3.new(0, -2.5, 0)  -- Un poco por debajo del jugador
    floor.Anchored = true
    floor.CanCollide = true
    floor.Material = Enum.Material.Neon
    floor.BrickColor = BrickColor.new("Really red")
    floor.Transparency = 0.3
    
    -- Efecto de luz
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 2
    pointLight.Range = 8
    pointLight.Color = FLOOR_COLOR
    pointLight.Parent = floor
    
    -- Efecto de partículas
    local particleEmitter = Instance.new("ParticleEmitter")
    particleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
    particleEmitter.Lifetime = NumberRange.new(0.5, 1)
    particleEmitter.Rate = 20
    particleEmitter.SpreadAngle = Vector2.new(45, 45)
    particleEmitter.Color = ColorSequence.new(FLOOR_COLOR)
    particleEmitter.Parent = floor
    
    floor.Parent = workspace
    
    -- Guardar referencia
    local floorData = {
        part = floor,
        createdAt = tick(),
        player = player
    }
    table.insert(activeFloors, floorData)
    
    return floor
end

-- Función para limpiar suelos antiguos
local function cleanupOldFloors()
    local currentTime = tick()
    local toRemove = {}
    
    for i, floorData in ipairs(activeFloors) do
        if currentTime - floorData.createdAt > FLOOR_DURATION then
            -- Animación de desaparición
            local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            local tween = TweenService:Create(floorData.part, tweenInfo, {
                Transparency = 1,
                Size = Vector3.new(0.1, 0.1, 0.1)
            })
            
            tween:Play()
            tween.Completed:Connect(function()
                if floorData.part and floorData.part.Parent then
                    floorData.part:Destroy()
                end
            end)
            
            table.insert(toRemove, i)
        end
    end
    
    -- Remover de la lista
    for i = #toRemove, 1, -1 do
        table.remove(activeFloors, toRemove[i])
    end
end

-- Detectar movimiento y saltos
local function setupPlayerCharacter(character, player)
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    
    local lastPosition = rootPart.Position
    local lastJumpTime = 0
    local lastRunTime = 0
    
    -- Conexión para actualizar posición
    local connection
    connection = RunService.Heartbeat:Connect(function()
        if not character or not rootPart then
            connection:Disconnect()
            return
        end
        
        local currentPosition = rootPart.Position
        local velocity = humanoid:GetState() == Enum.HumanoidStateType.Running
        local jumping = humanoid:GetState() == Enum.HumanoidStateType.Jumping
        local currentTime = tick()
        
        -- Detectar salto
        if jumping and currentTime - lastJumpTime > 0.5 then
            createTemporaryFloor(currentPosition, player)
            lastJumpTime = currentTime
        end
        
        -- Detectar carrera (cambio de posición significativo)
        local distanceMoved = (currentPosition - lastPosition).Magnitude
        if velocity and distanceMoved > 3 and currentTime - lastRunTime > 0.3 then
            createTemporaryFloor(currentPosition, player)
            lastRunTime = currentTime
        end
        
        lastPosition = currentPosition
    end)
end

-- Sistema de Hub Desplazable
local function createMovableHub()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MovableHub"
    screenGui.ResetOnSpawn = false
    
    -- Frame principal
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 300, 0, 200)
    mainFrame.Position = UDim2.new(0, 50, 0, 50)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Botón para ocultar/mostrar
    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0, 30, 0, 30)
    toggleButton.Position = UDim2.new(1, -35, 0, 5)
    toggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    toggleButton.Text = "X"
    toggleButton.TextColor3 = Color3.white
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = mainFrame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    title.Text = "Sistema de Suelo Rojo"
    title.TextColor3 = Color3.white
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = mainFrame
    
    -- Información
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 1, -60)
    infoLabel.Position = UDim2.new(0, 10, 0, 40)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "• Salta para crear suelo rojo\n• Corre para crear suelo continuo\n• El suelo desaparece automáticamente\n• ¡Disfruta del efecto!"
    infoLabel.TextColor3 = Color3.white
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextSize = 12
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextYAlignment = Enum.TextYAlignment.Top
    infoLabel.Parent = mainFrame
    
    -- Función para ocultar/mostrar
    local isVisible = true
    toggleButton.MouseButton1Click:Connect(function()
        isVisible = not isVisible
        if isVisible then
            mainFrame.Visible = true
            toggleButton.Text = "X"
        else
            mainFrame.Visible = false
            toggleButton.Text = ">"
            mainFrame.Position = UDim2.new(0, 10, 0, 50)
        end
    end)
    
    return screenGui
end

-- Inicialización
local function initialize()
    -- Crear el hub
    local hub = createMovableHub()
    hub.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Configurar limpieza continua
    RunService.Heartbeat:Connect(cleanupOldFloors)
    
    -- Configurar jugador actual
    local player = Players.LocalPlayer
    if player.Character then
        setupPlayerCharacter(player.Character, player)
    end
    
    player.CharacterAdded:Connect(function(character)
        setupPlayerCharacter(character, player)
    end)
end

-- Ejecutar inicialización
initialize()

print("✅ Sistema de suelo rojo activado!")
print("🎮 Salta o corre para crear plataformas temporales")
print("📱 Usa el hub desplazable para controlar la interfaz")