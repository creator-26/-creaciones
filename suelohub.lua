-- Sistema de Suelo Rojo para Exploit
if not LPH_OBFUSCATED then
    LPH_JIT_MAX = function(f) return f end
    LPH_NO_VIRTUALIZE = function(f) return f end
end

local LPH_JIT = (function() return function(f) return f end end)()

local function safeCall(callback, ...)
    local success, result = pcall(callback, ...)
    if not success then
        warn("Error: " .. tostring(result))
        return nil
    end
    return result
end

-- Inicialización principal
local function Main()
    print("🎮 Iniciando Sistema de Suelo Rojo...")
    
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
    
    print("👤 Jugador: " .. localPlayer.Name)
    
    -- Configuración
    local CONFIG = {
        FLOOR_DURATION = 2.5,
        FLOOR_COLOR = Color3.fromRGB(255, 50, 50),
        FLOOR_SIZE = Vector3.new(5, 0.3, 5),
        JUMP_COOLDOWN = 0.4,
        RUN_COOLDOWN = 0.6
    }
    
    -- Función optimizada para crear suelos
    local function createFloor(position)
        if not floorEnabled then return end
        
        local floor = Instance.new("Part")
        floor.Name = "RedFloor_" .. math.random(1000, 9999)
        floor.Size = CONFIG.FLOOR_SIZE
        floor.Position = Vector3.new(
            math.floor(position.X / 4) * 4,
            position.Y - 3.5,
            math.floor(position.Z / 4) * 4
        )
        floor.Anchored = true
        floor.CanCollide = true
        floor.Material = Enum.Material.Neon
        floor.BrickColor = BrickColor.new("Really red")
        floor.Transparency = 0.1
        
        -- Efecto de luz
        local light = Instance.new("PointLight")
        light.Brightness = 2
        light.Range = 8
        light.Color = CONFIG.FLOOR_COLOR
        light.Parent = floor
        
        -- Efecto de partículas simple
        local sparkles = Instance.new("Sparkles")
        sparkles.SparkleColor = CONFIG.FLOOR_COLOR
        sparkles.Parent = floor
        
        floor.Parent = workspace
        
        -- Guardar referencia
        local floorData = {
            part = floor,
            createdAt = tick()
        }
        table.insert(activeFloors, floorData)
        
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
                        TweenInfo.new(0.5, Enum.EasingStyle.Quad),
                        {Transparency = 1, Size = Vector3.new(0.1, 0.1, 0.1)}
                    )
                    tween:Play()
                    game:GetService("Debris"):AddItem(data.part, 0.6)
                end
                table.remove(activeFloors, i)
            end
        end
    end
    
    -- Detector de movimiento mejorado
    local function setupCharacter(character)
        print("🎯 Configurando personaje...")
        
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        local lastPosition = rootPart.Position
        local lastJumpTime = 0
        local lastRunTime = 0
        local connection
        
        connection = RunService.Heartbeat:Connect(function()
            if not character or not rootPart or not humanoid then
                connection:Disconnect()
                return
            end
            
            local currentPos = rootPart.Position
            local currentTime = tick()
            local state = humanoid:GetState()
            
            -- Detectar salto
            if state == Enum.HumanoidStateType.Jumping then
                if currentTime - lastJumpTime > CONFIG.JUMP_COOLDOWN then
                    createFloor(currentPos)
                    lastJumpTime = currentTime
                end
            end
            
            -- Detectar carrera
            local distance = (currentPos - lastPosition).Magnitude
            local velocity = rootPart.VectorVelocity
            local isMoving = distance > 2 and velocity.Magnitude > 5
            
            if isMoving and state == Enum.HumanoidStateType.Running then
                if currentTime - lastRunTime > CONFIG.RUN_COOLDOWN then
                    createFloor(currentPos)
                    lastRunTime = currentTime
                end
            end
            
            lastPosition = currentPos
        end)
        
        print("✅ Personaje configurado")
    end
    
    -- Hub simple y funcional
    local function createHub()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Name = "RedFloorHub"
        screenGui.ResetOnSpawn = false
        
        local mainFrame = Instance.new("Frame")
        mainFrame.Size = UDim2.new(0, 280, 0, 150)
        mainFrame.Position = UDim2.new(0, 10, 0, 10)
        mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        mainFrame.BorderSizePixel = 0
        mainFrame.Active = true
        mainFrame.Draggable = true
        
        -- Título
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 35)
        title.BackgroundColor3 = CONFIG.FLOOR_COLOR
        title.Text = "🔥 SUELO ROJO ACTIVADO"
        title.TextColor3 = Color3.new(1, 1, 1)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.Parent = mainFrame
        
        -- Información
        local info = Instance.new("TextLabel")
        info.Size = UDim2.new(1, -20, 0, 60)
        info.Position = UDim2.new(0, 10, 0, 40)
        info.BackgroundTransparency = 1
        info.Text = "• SALTA → Crear suelo\n• CORRE → Suelo continuo\n• Suelos duran " .. CONFIG.FLOOR_DURATION .. "s\n• Color: ROJO NEÓN"
        info.TextColor3 = Color3.new(1, 1, 1)
        info.Font = Enum.Font.Gotham
        info.TextSize = 12
        info.TextXAlignment = Enum.TextXAlignment.Left
        info.Parent = mainFrame
        
        -- Botón toggle
        local toggleBtn = Instance.new("TextButton")
        toggleBtn.Size = UDim2.new(0, 120, 0, 30)
        toggleBtn.Position = UDim2.new(0.5, -60, 1, -40)
        toggleBtn.BackgroundColor3 = CONFIG.FLOOR_COLOR
        toggleBtn.Text = "DESACTIVAR"
        toggleBtn.TextColor3 = Color3.new(1, 1, 1)
        toggleBtn.Font = Enum.Font.GothamBold
        toggleBtn.TextSize = 12
        toggleBtn.Parent = mainFrame
        
        toggleBtn.MouseButton1Click:Connect(function()
            floorEnabled = not floorEnabled
            if floorEnabled then
                toggleBtn.Text = "DESACTIVAR"
                toggleBtn.BackgroundColor3 = CONFIG.FLOOR_COLOR
                title.Text = "🔥 SUELO ROJO ACTIVADO"
            else
                toggleBtn.Text = "ACTIVAR"
                toggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                title.Text = "❌ SUELO ROJO DESACTIVADO"
            end
        end)
        
        screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
        print("📱 Hub creado exitosamente")
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
            wait(1) -- Esperar a que el character esté listo
            setupCharacter(char)
        end)
        
        print("🎉 SISTEMA LISTO!")
        print("🟥 Salta o corre para crear suelos rojos")
        print("📱 Usa el hub para controlar el sistema")
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
end
