-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Botón inmortal
local inmortalButton = Instance.new("TextButton")
inmortalButton.Size = UDim2.new(0, 120, 0, 40)
inmortalButton.Position = UDim2.new(0, 20, 0, 200)
inmortalButton.Text = "Inmortal: OFF"
inmortalButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
inmortalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
inmortalButton.Parent = ScreenGui

inmortalButton.Active = true
inmortalButton.Draggable = true

-- Estado inmortal
local inmortal = false
local connections = {}

-- FUNCIONES AVANZADAS DE INMORTALIDAD
local function setupUltraImmortality()
    if not inmortal then return end
    
    local Character = LocalPlayer.Character
    if not Character then return end
    
    local Humanoid = Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
    
    -- MÉTODO 1: LOOP CONSTANTE DE PROTECCIÓN
    table.insert(connections, RunService.Heartbeat:Connect(function()
        if not inmortal or not Character or not Character.Parent then return end
        
        -- Forzar salud máxima SIEMPRE
        if Humanoid and Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
        end
        
        -- Prevenir muerte
        if Humanoid and Humanoid.Health <= 0 then
            Humanoid.Health = 100
        end
        
        -- Resetear estado de muerte
        if Humanoid and Humanoid:GetState() == Enum.HumanoidStateType.Dead then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end))
    
    -- MÉTODO 2: PROTECCIÓN ANTIDMG AVANZADA
    table.insert(connections, Humanoid.HealthChanged:Connect(function(hp)
        if not inmortal then return end
        
        -- Si la salud baja, restaurar inmediatamente
        if hp < Humanoid.MaxHealth then
            Humanoid.Health = math.huge
        end
        
        -- Si muere, revivir instantáneamente
        if hp <= 0 then
            wait(0.1)
            if Humanoid then
                Humanoid.Health = math.huge
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end))
    
    -- MÉTODO 3: ELIMINAR TODAS LAS ZONAS DE DAÑO
    table.insert(connections, Workspace.DescendantAdded:Connect(function(descendant)
        if not inmortal then return end
        
        -- Eliminar killbricks, lava, fuego, etc.
        if descendant:IsA("Part") and (
            descendant.Name:lower():find("kill") or 
            descendant.Name:lower():find("death") or 
            descendant.Name:lower():find("lava") or
            descendant.Name:lower():find("fire") or
            descendant.Name:lower():find("damage") or
            descendant.BrickColor == BrickColor.new("Bright red")
        ) then
            descendant.CanTouch = false
            descendant:Destroy()
        end
        
        -- Eliminar fuegos y efectos de daño
        if descendant:IsA("Fire") or descendant:IsA("Sparkles") or descendant:IsA("Smoke") then
            descendant:Destroy()
        end
    end))
    
    -- MÉTODO 4: HACER EL PERSONAJE INVULNERABLE A TODO
    Humanoid.MaxHealth = math.huge
    Humanoid.Health = math.huge
    
    -- MÉTODO 5: PROTEGER DE HERRAMIENTAS DE DAÑO
    for _, tool in ipairs(Workspace:GetDescendants()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
            local handle = tool.Handle
            for _, touch in ipairs(handle:GetChildren()) do
                if touch:IsA("TouchTransmitter") then
                    touch:Destroy()
                end
            end
        end
    end
    
    -- MÉTODO 6: DESACTIVAR SCRIPTS DE MUERTE
    for _, script in ipairs(Workspace:GetDescendants()) do
        if script:IsA("Script") and (
            script.Name:lower():find("kill") or 
            script.Name:lower():find("death") or
            script.Name:lower():find("damage")
        ) then
            script.Disabled = true
        end
    end
    
    -- MÉTODO 7: PROTECCIÓN CONTRA CAÍDA
    if HumanoidRootPart then
        table.insert(connections, RunService.Stepped:Connect(function()
            if not inmortal then return end
            if HumanoidRootPart.Position.Y < -500 then
                HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
            end
        end))
    end
    
    -- MÉTODO 8: ANTI-TELEPORT A ZONAS DE MUERTE
    local lastSafePosition = HumanoidRootPart and HumanoidRootPart.Position or Vector3.new(0, 10, 0)
    table.insert(connections, RunService.Heartbeat:Connect(function()
        if not inmortal or not HumanoidRootPart then return end
        
        -- Detectar si te teleportan a zona de muerte
        if (HumanoidRootPart.Position - lastSafePosition).Magnitude > 100 then
            local ray = Workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -10, 0))
            if not ray or ray.Instance and (
                ray.Instance.Name:lower():find("kill") or 
                ray.Instance.Name:lower():find("death")
            ) then
                HumanoidRootPart.CFrame = CFrame.new(lastSafePosition)
            else
                lastSafePosition = HumanoidRootPart.Position
            end
        end
    end))
end

-- Función para limpiar conexiones
local function cleanConnections()
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    connections = {}
end

-- Función para activar/desactivar
local function setImmortal(state)
    inmortal = state
    
    cleanConnections() -- Limpiar conexiones anteriores
    
    if inmortal then
        inmortalButton.Text = "Inmortal: ON"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Esperar a que el character esté listo
        if LocalPlayer.Character then
            setupUltraImmortality()
        end
        
        -- Conectar para cuando respawnees
        LocalPlayer.CharacterAdded:Connect(function()
            wait(1) -- Esperar a que cargue
            if inmortal then
                setupUltraImmortality()
            end
        end)
        
    else
        inmortalButton.Text = "Inmortal: OFF"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        -- Restaurar valores normales
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.MaxHealth = 100
            LocalPlayer.Character.Humanoid.Health = 100
        end
    end
end

-- Click del botón
inmortalButton.MouseButton1Click:Connect(function()
    setImmortal(not inmortal)
end)

-- Protección inicial
wait(2)
if LocalPlayer.Character then
    -- Limpiar zonas de muerte al iniciar
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("Part") and (
            part.Name:lower():find("kill") or 
            part.Name:lower():find("death")
        ) then
            part.CanTouch = false
        end
    end
end
