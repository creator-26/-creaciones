-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- GUI principal (esto NO se destruye al morir)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImmortalGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Botón inmortal
local inmortalButton = Instance.new("TextButton")
inmortalButton.Size = UDim2.new(0, 150, 0, 50)
inmortalButton.Position = UDim2.new(0, 20, 0, 200)
inmortalButton.Text = "INMORTAL: OFF"
inmortalButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
inmortalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
inmortalButton.Font = Enum.Font.SourceSansBold
inmortalButton.TextSize = 16
inmortalButton.Parent = ScreenGui
inmortalButton.Active = true
inmortalButton.Draggable = true

-- Estado inmortal (variables GLOBALES que no se pierden)
local inmortal = false
local connections = {}

-- FUNCIÓN QUE SOBREVIVE A LA MUERTE
local function setupImmortality()
    if not inmortal then return end
    
    -- Esperar a que el NUEVO character aparezca
    local character = LocalPlayer.Character
    if not character then
        character = LocalPlayer.CharacterAdded:Wait()
    end
    
    wait(1) -- Esperar a que el character se estabilice completamente
    
    local Humanoid = character:WaitForChild("Humanoid")
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    -- 🔥 MÉTODO 1: SALUD INFINITA
    Humanoid.MaxHealth = math.huge
    Humanoid.Health = math.huge
    
    -- 🔥 MÉTODO 2: PROTECCIÓN CONSTANTE (SOBREVIVE A LA MUERTE)
    local heartbeatConnection = RunService.Heartbeat:Connect(function()
        if not inmortal or not character.Parent then 
            -- Si el character murió, reconectar
            if not character.Parent then
                setupImmortality()
                return
            end
        end
        
        -- Mantener salud infinita
        if Humanoid.Health < math.huge then
            Humanoid.Health = math.huge
        end
        
        -- Revivir inmediatamente
        if Humanoid.Health <= 0 then
            Humanoid.Health = math.huge
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
    
    table.insert(connections, heartbeatConnection)
    
    -- 🔥 MÉTODO 3: PROTECCIÓN CONTRA CAÍDA
    if HumanoidRootPart then
        local steppedConnection = RunService.Stepped:Connect(function()
            if not inmortal then return end
            if HumanoidRootPart.Position.Y < -500 then
                HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
            end
        end)
        table.insert(connections, steppedConnection)
    end
    
    -- 🔥 MÉTODO 4: DETECTAR MUERTE Y REACTIVAR
    Humanoid.Died:Connect(function()
        if inmortal then
            wait(2) -- Esperar el respawn
            setupImmortality() -- Reactivar inmortalidad en el NUEVO character
        end
    end)
end

-- Limpiar conexiones
local function cleanConnections()
    for _, connection in ipairs(connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    connections = {}
end

-- Activar/desactivar inmortalidad
local function setImmortal(state)
    inmortal = state
    
    if inmortal then
        inmortalButton.Text = "INMORTAL: ON"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Activar inmediatamente
        setupImmortality()
        
    else
        inmortalButton.Text = "INMORTAL: OFF"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        cleanConnections()
        
        -- Restaurar valores normales si hay character
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.MaxHealth = 100
            LocalPlayer.Character.Humanoid.Health = 100
        end
    end
end

-- Click del botón (esto NO se destruye)
inmortalButton.MouseButton1Click:Connect(function()
    setImmortal(not inmortal)
end)

-- Protección inicial contra zonas de muerte
wait(3)
for _, part in ipairs(Workspace:GetDescendants()) do
    if part:IsA("Part") and (
        part.Name:lower():find("kill") or 
        part.Name:lower():find("death") or
        part.Name:lower():find("lava")
    ) then
        part.CanTouch = false
    end
end

print("✅ INMORTALIDAD PERMANENTE ACTIVADA")
print("✅ El script SOBREVIVE a la muerte del personaje")
