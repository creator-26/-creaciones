-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FixedImmortalGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 20, 0, 200)
button.Text = "INMORTAL: OFF"
button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 16
button.Parent = screenGui
button.Active = true
button.Draggable = true

-- 🔥 VARIABLES GLOBALES CORREGIDAS
local immortal = false
local activeConnections = {}

-- 🔥 FUNCIÓN MEJORADA SIN ERRORES
local function activateImmortality()
    if not immortal then return end
    
    local character = LocalPlayer.Character
    if not character then
        character = LocalPlayer.CharacterAdded:Wait()
    end
    
    -- Esperar a que el character esté listo
    wait(1)
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid then return end
    
    -- 🔥 CONEXIÓN PRINCIPAL SIMPLE
    local mainConnection = RunService.Heartbeat:Connect(function()
        if not immortal or not character or not character.Parent then 
            return
        end
        
        -- Verificar que humanoid aún existe
        local currentHumanoid = character:FindFirstChild("Humanoid")
        if not currentHumanoid then return end
        
        -- Curar solo si es necesario
        if currentHumanoid.Health < 100 then
            currentHumanoid.Health = 100
        end
        
        -- Prevenir muerte
        if currentHumanoid.Health <= 0 then
            currentHumanoid.Health = 100
            currentHumanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
    
    table.insert(activeConnections, mainConnection)
    
    -- 🔥 PROTECCIÓN CONTRA CAÍDA (OPCIONAL)
    if rootPart then
        local fallConnection = RunService.Stepped:Connect(function()
            if not immortal or not character or not character.Parent then return end
            if rootPart.Position.Y < -500 then
                rootPart.CFrame = CFrame.new(0, 100, 0)
            end
        end)
        table.insert(activeConnections, fallConnection)
    end
end

-- 🔥 FUNCIÓN DE DESACTIVACIÓN CORREGIDA
local function deactivateImmortality()
    -- Desconectar TODAS las conexiones
    for i, connection in ipairs(activeConnections) do
        if typeof(connection) == "RBXScriptConnection" then
            pcall(function() -- 🔥 EVITA ERRORES SI LA CONEXIÓN YA NO EXISTE
                connection:Disconnect()
            end)
        end
    end
    activeConnections = {} -- 🔥 LIMPIAR LA TABLA COMPLETAMENTE
end

-- 🔥 CONTROL PRINCIPAL SIMPLIFICADO
button.MouseButton1Click:Connect(function()
    immortal = not immortal
    
    if immortal then
        -- DESACTIVAR PRIMERO para evitar duplicados
        deactivateImmortality()
        
        button.Text = "INMORTAL: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Activar en character actual
        activateImmortality()
        
        -- Conectar para futuros characters
        local respawnConnection = LocalPlayer.CharacterAdded:Connect(function(character)
            if immortal then
                wait(1)
                deactivateImmortality() -- Limpiar antes de reactivar
                activateImmortality()
            end
        end)
        
        table.insert(activeConnections, respawnConnection)
        
        print("🟢 INMORTALIDAD ACTIVADA")
    else
        button.Text = "INMORTAL: OFF"
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        deactivateImmortality()
        print("🔴 INMORTALIDAD DESACTIVADA")
    end
end)

print("✅ SISTEMA 100% CORREGIDO")
