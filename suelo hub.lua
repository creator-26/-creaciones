-- Sistema mejorado con verificación
local function initializeSystem()
    print("🎮 Iniciando sistema de suelo rojo...")
    
    -- Verificar que estamos en un lugar donde funciona
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local TweenService = game:GetService("TweenService")
    
    print("✅ Servicios cargados correctamente")
    
    -- Configuración
    local FLOOR_DURATION = 2
    local FLOOR_COLOR = Color3.fromRGB(255, 0, 0)
    local FLOOR_SIZE = Vector3.new(4, 0.2, 4)
    
    local activeFloors = {}
    local localPlayer = Players.LocalPlayer
    
    print("👤 Jugador local: " .. tostring(localPlayer.Name))
    
    -- Función para crear suelo
    local function createTemporaryFloor(position, player)
        local floor = Instance.new("Part")
        floor.Name = "TemporaryFloor_" .. tick()
        floor.Size = FLOOR_SIZE
        floor.Position = position + Vector3.new(0, -3, 0)
        floor.Anchored = true
        floor.CanCollide = true
        floor.Material = Enum.Material.Neon
        floor.BrickColor = BrickColor.new("Really red")
        floor.Transparency = 0.2
        
        -- Luz
        local pointLight = Instance.new("PointLight")
        pointLight.Brightness = 1.5
        pointLight.Range = 6
        pointLight.Color = FLOOR_COLOR
        pointLight.Parent = floor
        
        floor.Parent = workspace
        
        local floorData = {
            part = floor,
            createdAt = tick(),
            player = player
        }
        table.insert(activeFloors, floorData)
        
        print("🟥 Suelo creado en: " .. tostring(position))
        return floor
    end

    -- Limpieza
    local function cleanupOldFloors()
        local currentTime = tick()
        for i = #activeFloors, 1, -1 do
            local floorData = activeFloors[i]
            if currentTime - floorData.createdAt > FLOOR_DURATION then
                if floorData.part then
                    floorData.part:Destroy()
                end
                table.remove(activeFloors, i)
            end
        end
    end

    -- Detectar movimiento
    local function setupCharacter(character)
        print("🎯 Configurando character: " .. character.Name)
        
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        local lastPosition = rootPart.Position
        local lastActionTime = 0
        
        RunService.Heartbeat:Connect(function()
            if not character or not rootPart then return end
            
            local currentPosition = rootPart.Position
            local moving = (currentPosition - lastPosition).Magnitude > 0.1
            local onGround = humanoid.FloorMaterial ~= Enum.Material.Air
            local currentTime = tick()
            
            -- Crear suelo al saltar
            if humanoid:GetState() == Enum.HumanoidStateType.Jumping then
                if currentTime - lastActionTime > 0.3 then
                    createTemporaryFloor(currentPosition, localPlayer)
                    lastActionTime = currentTime
                    print("🦘 Suelo por salto")
                end
            end
            
            -- Crear suelo al correr
            if moving and onGround and humanoid.MoveDirection.Magnitude > 0 then
                if currentTime - lastActionTime > 0.5 then
                    createTemporaryFloor(currentPosition, localPlayer)
                    lastActionTime = currentTime
                    print("🏃 Suelo por carrera")
                end
            end
            
            lastPosition = currentPosition
        end)
    end

    -- Hub simple
    local function createSimpleHub()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "RedFloorHub"
        screenGui.ResetOnSpawn = false
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 250, 0, 100)
        mainFrame.Position = UDim2.new(0, 10, 0, 10)
        mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 30)
        title.BackgroundColor3 = FLOOR_COLOR
        title.Text = "Suelo Rojo Activado ✅"
        title.TextColor3 = Color3.white
        title.Font = Enum.Font.GothamBold
        title.Parent = mainFrame
        
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1, -10, 1, -40)
        info.Position = UDim2.new(0, 5, 0, 35)
        info.BackgroundTransparency = 1
        info.Text = "Salta o corre para crear suelos"
        info.TextColor3 = Color3.white
        info.Font = Enum.Font.Gotham
        info.TextSize = 12
        info.Parent = mainFrame
        
        mainFrame.Parent = screenGui
        screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
        
        print("📱 Hub creado correctamente")
        return screenGui
    end

    -- Inicializar
    createSimpleHub()
    
    -- Limpieza continua
    RunService.Heartbeat:Connect(cleanupOldFloors)
    
    -- Configurar character
    if localPlayer.Character then
        setupCharacter(localPlayer.Character)
    end
    
    localPlayer.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart")
        setupCharacter(character)
    end)
    
    print("🎉 Sistema completamente inicializado!")
    print("🟥 Salta o corre para probar los suelos rojos")
end

-- Ejecutar con protección de errores
local success, errorMsg = pcall(initializeSystem)
if not success then
    warn("❌ Error al inicializar: " .. tostring(errorMsg))
else
    print("✅ Sistema ejecutado correctamente")
end
