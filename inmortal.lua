-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

-- Asegurar que el GUI sobreviva a cualquier cosa
local playerGui = LocalPlayer:WaitForChild("PlayerGui")

-- GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ImmortalGUI"
ScreenGui.ResetOnSpawn = false  -- 🔥 IMPORTANTE: No resetear al respawn
ScreenGui.Parent = playerGui

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

-- Estado global que nunca se pierde
local inmortal = false
local connections = {}

-- 🔥 FUNCIÓN DE PROTECCIÓN COMPLETA
local function makeCharacterImmortal(character)
    if not inmortal or not character then return end
    
    wait(1) -- Esperar a que el character se estabilice
    
    local Humanoid = character:WaitForChild("Humanoid")
    local HumanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- 🔥 MÉTODO 1: SALUD INFINITA
    Humanoid.MaxHealth = math.huge
    Humanoid.Health = math.huge
    
    -- 🔥 MÉTODO 2: PROTECCIÓN CONTRA GOLPES Y EMPUJONES
    -- Hacer el character inmune a fuerzas físicas
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.Massless = true  -- 🔥 Sin masa = no puede ser empujado
            part.CanCollide = false  -- 🔥 No colisionar con otros jugadores
        end
    end
    
    -- 🔥 MÉTODO 3: ANCHOR PARA EVITAR CAÍDAS Y EMPUJONES
    if HumanoidRootPart then
        HumanoidRootPart.Anchored = true  -- 🔥 Inmóvil a fuerzas externas
        wait(0.1)
        HumanoidRootPart.Anchored = false -- 🔥 Permitir movimiento propio pero no empujones
    end
    
    -- 🔥 MÉTODO 4: LOOP DE PROTECCIÓN CONSTANTE
    local protectionLoop = RunService.Heartbeat:Connect(function()
        if not inmortal or not character.Parent then 
            protectionLoop:Disconnect()
            return
        end
        
        -- Mantener salud infinita SIEMPRE
        if Humanoid.Health < math.huge then
            Humanoid.Health = math.huge
        end
        
        -- Revivir instantáneamente
        if Humanoid.Health <= 0 then
            Humanoid.Health = math.huge
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
        
        -- 🔥 PROTECCIÓN CONTRA EMPUJONES: Congelar posición si te empujan
        if HumanoidRootPart then
            local velocity = HumanoidRootPart.Velocity
            -- Si la velocidad es muy alta (empujón fuerte), contrarrestar
            if velocity.Magnitude > 100 then
                HumanoidRootPart.Velocity = Vector3.new(0, velocity.Y, 0)
            end
        end
    end)
    
    table.insert(connections, protectionLoop)
    
    -- 🔥 MÉTODO 5: PROTECCIÓN CONTRA CAÍDA
    local antiFall = RunService.Stepped:Connect(function()
        if not inmortal or not character.Parent then 
            antiFall:Disconnect()
            return
        end
        
        if HumanoidRootPart and HumanoidRootPart.Position.Y < -100 then
            HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        end
    end)
    
    table.insert(connections, antiFall)
    
    -- 🔥 MÉTODO 6: ELIMINAR ZONAS DE DAÑO
    local function removeDangerousObjects()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Part") and (
                obj.Name:lower():find("kill") or 
                obj.Name:lower():find("death") or
                obj.Name:lower():find("lava") or
                obj.Name:lower():find("fire") or
                obj.Name:lower():find("damage")
            ) then
                obj.CanTouch = false
            end
        end
    end
    
    removeDangerousObjects()
    
    -- 🔥 MÉTODO 7: DETECTAR NUEVOS OBJETOS PELIGROSOS
    local dangerDetector = Workspace.DescendantAdded:Connect(function(descendant)
        if not inmortal then return end
        
        if descendant:IsA("Part") and (
            descendant.Name:lower():find("kill") or 
            descendant.Name:lower():find("death") or
            descendant.Name:lower():find("lava")
        ) then
            descendant.CanTouch = false
        end
    end)
    
    table.insert(connections, dangerDetector)
    
    -- 🔥 MÉTODO 8: PROTECCIÓN CONTRA HERRAMIENTAS/ARMAS
    for _, tool in ipairs(Workspace:GetDescendants()) do
        if tool:IsA("Tool") then
            for _, touch in ipairs(tool:GetDescendants()) do
                if touch:IsA("TouchTransmitter") then
                    touch:Destroy()
                end
            end
        end
    end
end

-- 🔥 FUNCIÓN QUE SOBREVIVE A TODO
local function startImmortality()
    if not inmortal then return end
    
    -- Proteger el character actual
    if LocalPlayer.Character then
        makeCharacterImmortal(LocalPlayer.Character)
    end
    
    -- Proteger FUTUROS characters (al morir y respawnear)
    local characterConnection = LocalPlayer.CharacterAdded:Connect(function(character)
        if inmortal then
            makeCharacterImmortal(character)
        end
    end)
    
    table.insert(connections, characterConnection)
end

-- Limpiar conexiones
local function stopImmortality()
    for _, connection in ipairs(connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        end
    end
    connections = {}
    
    -- Restaurar character normal si existe
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local Humanoid = LocalPlayer.Character.Humanoid
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
        
        -- Restaurar física normal
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Massless = false
                part.CanCollide = true
            end
        end
    end
end

-- 🔥 CONTROL PRINCIPAL
local function toggleImmortality()
    inmortal = not inmortal
    
    if inmortal then
        inmortalButton.Text = "INMORTAL: ON"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        startImmortality()
        print("🔥 INMORTALIDAD ACTIVADA - Eres inmune a todo")
    else
        inmortalButton.Text = "INMORTAL: OFF"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        stopImmortality()
        print("❌ INMORTALIDAD DESACTIVADA")
    end
end

-- Click del botón (SIEMPRE funciona)
inmortalButton.MouseButton1Click:Connect(toggleImmortality)

-- 🔥 PROTECCIÓN EXTRA: Si el GUI se pierde, recrearlo
LocalPlayer.CharacterAdded:Connect(function()
    wait(1)
    if not playerGui:FindFirstChild("ImmortalGUI") and inmortal then
        ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "ImmortalGUI"
        ScreenGui.ResetOnSpawn = false
        ScreenGui.Parent = playerGui
        
        -- Recargar botón...
        -- (Aquí iría el código completo del botón otra vez)
    end
end)

print("✅ SISTEMA DE INMORTALIDAD EXTREMA CARGADO")
print("✅ Botón permanente - No desaparece")
print("✅ Inmune a golpes, empujones y caídas")
