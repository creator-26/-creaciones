-- Sistema de Suelo Centrado para Exploit
local function Main()
    print("🎮 Iniciando Sistema de Suelo Centrado...")
    
    -- Esperar a que el juego cargue
    if not game:IsLoaded() then
        game.Loaded:Wait()
        print("✅ Juego cargado")
    end
    
    -- Servicios
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    
    -- Variables
    local localPlayer = Players.LocalPlayer
    local activeFloors = {}
    local floorEnabled = true
    
    print("👤 Jugador: " .. localPlayer.Name)
    
    -- Configuración
    local CONFIG = {
        FLOOR_DURATION = 3.0,
        FLOOR_COLOR = Color3.fromRGB(255, 0, 0),
        FLOOR_SIZE = Vector3.new(8, 0.5, 8),  -- Más ancho para no fallar
        FLOOR_OFFSET = 3,  -- Distancia debajo de los pies
        COOLDOWN = 0.2
    }
    
    -- Función para crear suelo centrado
    local function createCenteredFloor(character)
        if not floorEnabled or not character then return end
        
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- Calcular posición exacta debajo de los pies
        local playerPosition = humanoidRootPart.Position
        local floorPosition = Vector3.new(
            playerPosition.X,  -- Misma X
            playerPosition.Y - CONFIG.FLOOR_OFFSET,  -- Justo debajo
            playerPosition.Z   -- Misma Z
        )
        
        -- Verificar si ya hay un suelo muy cerca
        for _, floorData in pairs(activeFloors) do
            if floorData.part and floorData.part.Parent then
                local distance = (floorData.part.Position - floorPosition).Magnitude
                if distance < 4 then
                    return nil  -- Ya hay un suelo muy cerca
                end
            end
        end
        
        local floor = Instance.new("Part")
        floor.Name = "CenteredFloor_" .. math.random(1000, 9999)
        floor.Size = CONFIG.FLOOR_SIZE
        floor.Position = floorPosition
        floor.Anchored = true
        floor.CanCollide = true
        floor.Material = Enum.Material.Neon
        floor.BrickColor = BrickColor.new("Really red")
        floor.Transparency = 0.1
        
        -- Efecto de luz
        local light = Instance.new("PointLight")
        light.Brightness = 2
        light.Range = 10
        light.Color = CONFIG.FLOOR_COLOR
        light.Parent = floor
        
        -- Partículas
        local sparkles = Instance.new("Sparkles")
        sparkles.SparkleColor = CONFIG.FLOOR_COLOR
        sparkles.Parent = floor
        
        floor.Parent = workspace
        
        -- Animación de aparición desde el centro
        local originalSize = CONFIG.FLOOR_SIZE
        floor.Size = Vector3.new(1, 0.1, 1)
        local tween = TweenService:Create(
            floor, 
            TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = originalSize, Transparency = 0.1}
        )
        tween:Play()
        
        -- Guardar referencia
        local floorData = {
            part = floor,
            createdAt = tick()
        }
        table.insert(activeFloors, floorData)
        
        print("🎯 Suelo centrado creado en posición: " .. tostring(floorPosition))
        return floor
    end
    
    -- Sistema de limpieza
    local function cleanFloors()
        local currentTime = tick()
        for i = #activeFloors, 1, -1 do
            local data = activeFloors[i]
            if currentTime - data.createdAt > CONFIG.FLOOR_DURATION then
                if data.part and data.part.Parent then
                    -- Animación de desaparición
                    local tween = TweenService:Create(
                        data.part, 
                        TweenInfo.new(0.6, Enum.EasingStyle.Quad),
                        {Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)}
                    )
                    tween:Play()
                    game:GetService("Debris"):AddItem(data.part, 0.7)
                end
                table.remove(activeFloors, i)
            end
        end
    end
    
    -- Detector de caída y movimiento
    local function setupCharacter(character)
        print("🎯 Configurando detección de caída...")
        
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        local lastPosition = rootPart.Position
        local lastFloorTime = 0
        local wasFalling = false
        local connection
        
        connection = RunService.Heartbeat:Connect(function()
            if not character or not rootPart or not humanoid then
                connection:Disconnect()
                return
            end
            
            local currentPos = rootPart.Position
            local currentTime = tick()
            local velocity = rootPart.VectorVelocity
            
            -- Detectar si está cayendo (velocidad Y negativa)
            local isFalling = velocity.Y < -5  -- Cayendo rápido
            local justStartedFalling = isFalling and not wasFalling
            
            -- Detectar si acaba de saltar (velocidad Y positiva)
            local isJumping = velocity.Y > 20
            
            -- Crear suelo cuando empieza a caer
            if justStartedFalling and currentTime - lastFloorTime > CONFIG.COOLDOWN then
                createCenteredFloor(character)
                lastFloorTime = currentTime
                print("⬇️ Suelo por caída")
            end
            
            -- Crear suelo cuando está en el punto más alto del salto
            if isJumping and math.abs(velocity.Y) < 5 and currentTime - lastFloorTime > CONFIG.COOLDOWN then
                createCenteredFloor(character)
                lastFloorTime = currentTime
                print("🔼 Suelo en punto alto del salto")
            end
            
            -- Crear suelo continuo al correr en tierra
            local onGround = humanoid.FloorMaterial ~= Enum.Material.Air
            local isMoving = (Vector3.new(currentPos.X, 0, currentPos.Z) - Vector3.new(lastPosition.X, 0, lastPosition.Z)).Magnitude > 3
            
            if onGround and isMoving and currentTime - lastFloorTime > CONFIG.COOLDOWN + 0.3 then
                createCenteredFloor(character)
                lastFloorTime = currentTime
                print("🏃 Suelo por movimiento")
            end
            
            wasFalling = isFalling
            lastPosition = currentPos
        end)
        
        print("✅ Detección de caída configurada")
    end
    
    -- Hub de control
    local function createHub()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "CenteredFloorHub"
        screenGui.ResetOnSpawn = false
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 320, 0, 160)
        mainFrame.Position = UDim2.new(0, 10, 0, 10)
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        
        -- Título
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 35)
        title.BackgroundColor3 = CONFIG.FLOOR_COLOR
        title.Text = "🎯 SUELO CENTRADO ACTIVO"
        title.TextColor3 = Color3.new(1, 1, 1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.Parent = mainFrame
        
        -- Información
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1, -20, 0, 70)
        info.Position = UDim2.new(0, 10, 0, 40)
        info.BackgroundTransparency = 1
        info.Text = "• Al CAER → Suelo automático\n• Al SALTAR → Suelo en punto alto\n• Al CORRER → Camino continuo\n• SIEMPRE centrado en tus pies\n• Tamaño: " .. math.floor(CONFIG.FLOOR_SIZE.X) .. "x" .. math.floor(CONFIG.FLOOR_SIZE.Z)
        info.TextColor3 = Color3.new(1, 1, 1)
        info.Font = Enum.Font.Gotham
        info.TextSize = 12
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.Parent = mainFrame
        
        -- Botón toggle
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 140, 0, 35)
        toggleBtn.Position = UDim2.new(0.5, -70, 1, -45)
        toggleBtn.BackgroundColor3 = CONFIG.FLOOR_COLOR
        toggleBtn.Text = "🔴 DESACTIVAR"
        toggleBtn.TextColor3 = Color3.new(1, 1, 1)
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextSize = 13
        toggleBtn.Parent = mainFrame
        
        toggleBtn.MouseButton1Click:Connect(function()
            floorEnabled = not floorEnabled
            if floorEnabled then
                toggleBtn.Text = "🔴 DESACTIVAR"
                toggleBtn.BackgroundColor3 = CONFIG.FLOOR_COLOR
                title.Text = "🎯 SUELO CENTRADO ACTIVO"
            else
                toggleBtn.Text = "🟢 ACTIVAR"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                title.Text = "❌ SUELO CENTRADO DESACTIVADO"
            end
        end)
        
        screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
        print("📱 Hub de suelo centrado creado")
        return screenGui
    end
    
    -- Inicialización
    local function init()
        createHub()
        RunService.Heartbeat:Connect(cleanFloors)
        
        if localPlayer.Character then
            setupCharacter(localPlayer.Character)
        end
        
        localPlayer.CharacterAdded:Connect(function(char)
            wait(1)
            setupCharacter(char)
        end)
        
        print("🎉 SISTEMA DE SUELO CENTRADO LISTO!")
        print("🎯 El suelo siempre aparecerá centrado en tus pies")
        print("⬇️ Salta y cae sobre las plataformas perfectamente")
    end
    
    local success, err = pcall(init)
    if not success then
        warn("❌ Error: " .. tostring(err))
    end
end

-- Ejecutar
local success, errorMsg = pcall(Main)
if not success then
    warn("🚫 Error al cargar: " .. tostring(errorMsg))
else
    print("✅ Script de suelo centrado ejecutado correctamente")
end
