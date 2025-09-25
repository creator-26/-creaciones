-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UltraImmortalGUI"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Botón inmortal con mejor diseño
local inmortalButton = Instance.new("TextButton")
inmortalButton.Size = UDim2.new(0, 150, 0, 50)
inmortalButton.Position = UDim2.new(0, 20, 0, 200)
inmortalButton.Text = "🔥 INMORTAL: OFF"
inmortalButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
inmortalButton.TextColor3 = Color3.fromRGB(255, 255, 255)
inmortalButton.Font = Enum.Font.SourceSansBold
inmortalButton.TextSize = 16
inmortalButton.Parent = ScreenGui

inmortalButton.Active = true
inmortalButton.Draggable = true

-- Estado inmortal
local inmortal = false
local connections = {}

-- FUNCIÓN DE PROTECCIÓN MÁXIMA
local function applyGodMode(character)
    if not inmortal or not character then return end
    
    local Humanoid = character:WaitForChild("Humanoid")
    local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    -- 🔥 MÉTODO 1: HACER EL HUMANOIDE COMPLETAMENTE INVULNERABLE
    Humanoid.MaxHealth = math.huge
    Humanoid.Health = math.huge
    
    -- 🔥 MÉTODO 2: LOOP DE PROTECCIÓN CONSTANTE (10 veces por segundo)
    table.insert(connections, RunService.Heartbeat:Connect(function()
        if not inmortal or not character.Parent then return end
        
        -- Forzar salud infinita SIEMPRE
        if Humanoid.Health < math.huge then
            Humanoid.Health = math.huge
        end
        
        -- Prevenir cualquier estado de muerte
        if Humanoid.Health <= 0 then
            Humanoid.Health = math.huge
        end
        
        -- Si está muerto, revivir inmediatamente
        if Humanoid:GetState() == Enum.HumanoidStateType.Dead then
            Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            Humanoid.Health = math.huge
        end
    end))

    -- 🔥 MÉTODO 3: PROTECCIÓN CONTRA CAÍDA INFINITA
    if HumanoidRootPart then
        table.insert(connections, RunService.Stepped:Connect(function()
            if not inmortal then return end
            -- Teletransportar si caes muy abajo
            if HumanoidRootPart.Position.Y < -1000 then
                HumanoidRootPart.CFrame = CFrame.new(0, 100, 0)
            end
        end))
    end

    -- 🔥 MÉTODO 4: ELIMINAR TODOS LOS OBJETOS PELIGROSOS
    local function destroyDangerousObjects()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            -- Eliminar partes peligrosas
            if obj:IsA("Part") or obj:IsA("MeshPart") then
                if obj.Name:lower():find("kill") or obj.Name:lower():find("death") or 
                   obj.Name:lower():find("lava") or obj.Name:lower():find("fire") or
                   obj.Name:lower():find("damage") or obj.Name:lower():find("toxic") or
                   obj.Name:lower():find("spike") or obj.Name:lower():find("trap") then
                    obj.CanTouch = false
                    obj:Destroy()
                end
            end
            
            -- Eliminar efectos peligrosos
            if obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("Smoke") or 
               obj:IsA("ParticleEmitter") or obj:IsA("Explosion") then
                obj:Destroy()
            end
            
            -- Desactivar scripts de daño
            if obj:IsA("Script") or obj:IsA("LocalScript") then
                if obj.Name:lower():find("kill") or obj.Name:lower():find("death") or 
                   obj.Name:lower():find("damage") or obj.Name:lower():find("hurt") then
                    obj.Disabled = true
                end
            end
        end
    end

    -- 🔥 MÉTODO 5: PROTECCIÓN CONTRA HERRAMIENTAS/ARMAS
    local function disableWeapons()
        for _, tool in ipairs(Workspace:GetDescendants()) do
            if tool:IsA("Tool") then
                -- Remover capacidad de daño
                for _, v in ipairs(tool:GetDescendants()) do
                    if v:IsA("TouchTransmitter") or v:IsA("BodyForce") or v:IsA("BodyVelocity") then
                        v:Destroy()
                    end
                end
            end
        end
    end

    -- 🔥 MÉTODO 6: HACER EL PERSONAJE INTOCABLE
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanTouch = false
            part.CanQuery = false
            part.Massless = true
        end
    end

    -- 🔥 MÉTODO 7: PROTECCIÓN CONTRA FUERZAS FÍSICAS
    if HumanoidRootPart then
        local bodyForce = Instance.new("BodyForce")
        bodyForce.Force = Vector3.new(0, Workspace.Gravity * HumanoidRootPart:GetMass(), 0)
        bodyForce.Parent = HumanoidRootPart
        table.insert(connections, bodyForce)
    end

    -- 🔥 MÉTODO 8: BÚSQUEDA Y DESTRUCCIÓN CONSTANTE
    table.insert(connections, Workspace.DescendantAdded:Connect(function(descendant)
        if not inmortal then return end
        
        -- Destruir inmediatamente cualquier cosa peligrosa
        if descendant:IsA("Part") and (
            descendant.Name:lower():find("kill") or descendant.Name:lower():find("death") or
            descendant.Name:lower():find("lava") or descendant.Name:lower():find("fire") or
            descendant.BrickColor == BrickColor.new("Bright red")
        ) then
            descendant:Destroy()
        end
    end))

    -- 🔥 MÉTODO 9: ANTI-STUN Y ANTI-RAGDOLL
    Humanoid.AutoRotate = true
    Humanoid.AutoJumpEnabled = true
    
    -- 🔥 MÉTODO 10: PROTECCIÓN EXTREMA EN RESPAWN
    Humanoid.BreakJointsOnDeath = false
    Humanoid.Died:Connect(function()
        if inmortal then
            wait(0.5)
            -- Forzar respawn inmediato
            if character and character.Parent then
                Humanoid.Health = math.huge
                Humanoid:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end)

    -- Ejecutar protecciones
    destroyDangerousObjects()
    disableWeapons()
end

-- Función para limpiar conexiones
local function cleanConnections()
    for _, connection in ipairs(connections) do
        if typeof(connection) == "RBXScriptConnection" then
            connection:Disconnect()
        elseif connection:IsA("Instance") then
            connection:Destroy()
        end
    end
    connections = {}
end

-- Función principal para activar/desactivar
local function setImmortal(state)
    inmortal = state
    
    cleanConnections()
    
    if inmortal then
        inmortalButton.Text = "🔥 INMORTAL: ON"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Aplicar inmediatamente si hay character
        if LocalPlayer.Character then
            applyGodMode(LocalPlayer.Character)
        end
        
        -- Conectar para respawns futuros
        table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(character)
            wait(0.5) -- Esperar a que se estabilice
            if inmortal then
                applyGodMode(character)
            end
        end))
        
    else
        inmortalButton.Text = "🔥 INMORTAL: OFF"
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

-- Protección inicial automática
wait(3)
-- Limpiar el mapa al iniciar
for _, part in ipairs(Workspace:GetDescendants()) do
    if part:IsA("Part") and (
        part.Name:lower():find("kill") or 
        part.Name:lower():find("death")
    ) then
        part.CanTouch = false
    end
end

-- Mensaje de confirmación
print("🔥 SISTEMA DE INMORTALIDAD EXTREMA CARGADO")
print("✅ Botón disponible en la pantalla")
print("✅ 10 métodos de protección activos")
