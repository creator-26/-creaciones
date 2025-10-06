-- Sistema de Alfombra Voladora Roja para Exploit
local function Main()
    print("🎮 Iniciando Sistema de Alfombra Voladora...")
    
    -- Esperar a que el juego cargue
    if not game:IsLoaded() then
        game.Loaded:Wait()
        print("✅ Juego cargado")
    end
    
    -- Servicios
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    
    -- Variables
    local localPlayer = Players.LocalPlayer
    local activeFloors = {}
    local floorEnabled = true
    local lastYPosition = 0
    
    print("👤 Jugador: " .. localPlayer.Name)
    
    -- Configuración
    local CONFIG = {
        FLOOR_DURATION = 3.0,  -- Más tiempo para escalar
        FLOOR_COLOR = Color3.fromRGB(255, 50, 50),
        FLOOR_SIZE = Vector3.new(6, 0.4, 6),  -- Más grande para mejor plataforma
        JUMP_COOLDOWN = 0.3,
        RUN_COOLDOWN = 0.5,
        MAX_HEIGHT_DIFFERENCE = 20  -- Máxima diferencia de altura entre suelos
    }
    
    -- Función para crear suelos en el aire
    local function createFlyingFloor(position, isJump)
        if not floorEnabled then return end
        
        -- Para saltos, crear el suelo justo debajo de los pies
        local floorHeight = position.Y - 4
        if isJump then
            floorHeight = position.Y - 2  -- Más cerca al jugador durante saltos
        end
        
        -- Verificar que no estemos creando suelos muy altos
        if math.abs(floorHeight - lastYPosition) > CONFIG.MAX_HEIGHT_DIFFERENCE then
            floorHeight = lastYPosition + (position.Y > lastYPosition and 8 or -8)
        end
        
        local floor = Instance.new("Part")
        floor.Name = "FlyingFloor_" .. math.random(1000, 9999)
        floor.Size = CONFIG.FLOOR_SIZE
        floor.Position = Vector3.new(
            math.floor(position.X / 4) * 4,
            floorHeight,
            math.floor(position.Z / 4) * 4
        )
        floor.Anchored = true
        floor.CanCollide = true
        floor.Material = Enum.Material.Neon
        floor.BrickColor = BrickColor.new("Really red")
        floor.Transparency = 0.15
        
        -- Efecto de luz más intenso
        local light = Instance.new("PointLight")
        light.Brightness = 3
        light.Range = 12
        light.Color = CONFIG.FLOOR_COLOR
        light.Parent = floor
        
        -- Efecto de partículas flotantes
        local sparkles = Instance.new("Sparkles")
        sparkles.SparkleColor = CONFIG.FLOOR_COLOR
        sparkles.Parent = floor
        
        -- Humo mágico
        local smoke = Instance.new("Smoke")
        smoke.Color = Color3.new(1, 0.3, 0.3)
        smoke.Opacity = 0.3
        smoke.Size = 0.5
        smoke.RiseVelocity = 2
        smoke.Parent = floor
        
        floor.Parent = workspace
        
        -- Animación de aparición
        floor.Size = Vector3.new(0.1, 0.1, 0.1)
        local tween = TweenService:Create(
            floor, 
            TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Size = CONFIG.FLOOR_SIZE, Transparency = 0.15}
        )
        tween:Play()
        
        -- Guardar referencia
        local floorData = {
            part = floor,
            createdAt = tick(),
            height = floorHeight
        }
        table.insert(activeFloors, floorData)
        
        lastYPosition = floorHeight
        print("🪄 Alfombra creada a altura: " .. math.floor(floorHeight))
        
        return floor
    end
    
    -- Sistema de limpieza
    local function cleanFloors()
        local currentTime = tick()
        for i = #activeFloors, 1, -1 do
            local data = activeFloors[i]
            if currentTime - data.createdAt > CONFIG.FLOOR_DURATION then
                if data.part and data.part.Parent then
                    -- Animación de desaparición suave
                    local tween = TweenService:Create(
                        data.part, 
                        TweenInfo.new(0.8, Enum.EasingStyle.Quad),
                        {Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)}
                    )
                    tween:Play()
                    game:GetService("Debris"):AddItem(data.part, 1)
                end
                table.remove(activeFloors, i)
            end
        end
    end
    
    -- Detector de movimiento aéreo
    local function setupCharacter(character)
        print("🎯 Configurando personaje para alfombra voladora...")
        
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        local lastPosition = rootPart.Position
        local lastJumpTime = 0
        local lastRunTime = 0
        local lastAirTime = 0
        local isInAir = false
        local connection
        
        connection = RunService.Heartbeat:Connect(function()
            if not character or not rootPart or not humanoid then
                connection:Disconnect()
                return
            end
            
            local currentPos = rootPart.Position
            local currentTime = tick()
            local state = humanoid:GetState()
            
            -- Verificar si está en el aire
            local nowInAir = humanoid.FloorMaterial == Enum.Material.Air
            local justLeftGround = not isInAir and nowInAir
            isInAir = nowInAir
            
            -- Detectar salto (crear suelo en el aire)
            if state == Enum.HumanoidStateType.Jumping or (isInAir and currentPos.Y > lastPosition.Y + 1) then
                if currentTime - lastJumpTime > CONFIG.JUMP_COOLDOWN then
                    createFlyingFloor(currentPos, true)
                    lastJumpTime = currentTime
                    lastAirTime = currentTime
                end
            end
            
            -- Crear suelos mientras estás en el aire y te mueves
            if isInAir and (state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping) then
                local distance = (Vector3.new(currentPos.X, 0, currentPos.Z) - Vector3.new(lastPosition.X, 0, lastPosition.Z)).Magnitude
                
                if distance > 2 and currentTime - lastAirTime > 0.4 then
                    createFlyingFloor(currentPos, false)
                    lastAirTime = currentTime
                end
            end
            
            -- Detectar carrera en el suelo (crear camino)
            local distance = (currentPos - lastPosition).Magnitude
            local isMoving = distance > 1.5 and not isInAir
            
            if isMoving and state == Enum.HumanoidStateType.Running then
                if currentTime - lastRunTime > CONFIG.RUN_COOLDOWN then
                    createFlyingFloor(currentPos, false)
                    lastRunTime = currentTime
                end
            end
            
            lastPosition = currentPos
        end)
        
        print("✅ Personaje configurado para vuelo")
    end
    
    -- Hub de control de alfombra voladora
    local function createHub()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "FlyingCarpetHub"
        screenGui.ResetOnSpawn = false
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 300, 0, 180)
        mainFrame.Position = UDim2.new(0, 10, 0, 10)
        mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        
        -- Título con estilo mágico
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 40)
        title.BackgroundColor3 = CONFIG.FLOOR_COLOR
        title.Text = "🧙‍♂️ ALFOMBRA VOLADORA ROJA"
        title.TextColor3 = Color3.new(1, 1, 1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 16
        title.Parent = mainFrame
        
        -- Información de controles
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1, -20, 0, 80)
        info.Position = UDim2.new(0, 10, 0, 45)
        info.BackgroundTransparency = 1
        info.Text = "• SALTA → Crear plataformas aéreas\n• CORRE → Crear camino terrestre\n• EN EL AIRE → Plataformas continuas\n• Duración: " .. CONFIG.FLOOR_DURATION .. " segundos"
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
        toggleBtn.Text = "🪄 DESACTIVAR MAGIA"
        toggleBtn.TextColor3 = Color3.new(1, 1, 1)
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextSize = 13
        toggleBtn.Parent = mainFrame
        
        toggleBtn.MouseButton1Click:Connect(function()
            floorEnabled = not floorEnabled
            if floorEnabled then
                toggleBtn.Text = "🪄 DESACTIVAR MAGIA"
                toggleBtn.BackgroundColor3 = CONFIG.FLOOR_COLOR
                title.Text = "🧙‍♂️ ALFOMBRA VOLADORA ACTIVADA"
            else
                toggleBtn.Text = "✨ ACTIVAR MAGIA"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                title.Text = "❌ ALFOMBRA VOLADORA DESACTIVADA"
            end
        end)
        
        screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
        print("📱 Hub de alfombra voladora creado")
        return screenGui
    end
    
    -- Inicialización completa
    local function init()
        -- Crear interfaz
        createHub()
        
        -- Sistema de limpieza
        RunService.Heartbeat:Connect(cleanFloors)
        
        -- Configurar personaje actual
        if localPlayer.Character then
            setupCharacter(localPlayer.Character)
        end
        
        -- Reconectar al respawnear
        localPlayer.CharacterAdded:Connect(function(char)
            wait(2) -- Esperar a que el character esté completamente listo
            setupCharacter(char)
        end)
        
        print("🎉 ALFOMBRA VOLADORA LISTA!")
        print("🪄 Salta para crear escaleras aéreas")
        print("🏃 Corre para crear caminos terrestres")
        print("✨ Disfruta de tu alfombra mágica roja!")
    end
    
    -- Ejecutar inicialización
    local success, err = pcall(init)
    if not success then
        warn("❌ Error crítico: " .. tostring(err))
    end
end

-- Ejecutar con protección
local success, errorMsg = pcall(Main)
if not success then
    warn("🚫 Error al cargar el script: " .. tostring(errorMsg))
else
    print("✅ Script de alfombra voladora ejecutado correctamente")
end
