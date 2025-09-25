-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

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

-- Hacer el botón arrastrable
inmortalButton.Active = true
inmortalButton.Draggable = true

-- Estado inmortal
local inmortal = false
local healthConnection = nil
local renderConnection = nil

-- Función para manejar el cambio de personaje
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    wait(1) -- Esperar a que el character se estabilice
    if inmortal then
        setImmortal(true)
    end
end)

-- Función para activar/desactivar
local function setImmortal(state)
    inmortal = state
    
    -- Limpiar conexiones anteriores
    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end
    if renderConnection then
        renderConnection:Disconnect()
        renderConnection = nil
    end
    
    if inmortal then
        inmortalButton.Text = "Inmortal: ON"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        local function setupImmortality()
            local Character = LocalPlayer.Character
            if not Character then return end
            
            local Humanoid = Character:FindFirstChild("Humanoid")
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            
            if Humanoid then
                -- MÉTODO 1: HealthChanged (básico)
                healthConnection = Humanoid.HealthChanged:Connect(function(hp)
                    if inmortal and hp < Humanoid.MaxHealth then
                        Humanoid.Health = Humanoid.MaxHealth
                    end
                end)
                
                -- MÉTODO 2: MaxHealth infinito
                Humanoid.MaxHealth = math.huge
                Humanoid.Health = math.huge
                
                -- MÉTODO 3: Prevenir muerte por fall damage
                if Humanoid:FindFirstChild("PlatformStand") then
                    Humanoid.PlatformStand = false
                end
                
                -- MÉTODO 4: Loop de protección constante
                renderConnection = RunService.Heartbeat:Connect(function()
                    if not inmortal then return end
                    
                    -- Verificar si el personaje existe
                    if not Character or not Character.Parent then
                        return
                    end
                    
                    -- Forzar salud máxima constantemente
                    if Humanoid and Humanoid.Health < Humanoid.MaxHealth then
                        Humanoid.Health = Humanoid.MaxHealth
                    end
                    
                    -- Prevenir muerte instantánea (kill scripts)
                    if Humanoid and Humanoid.Health <= 0 then
                        Humanoid.Health = Humanoid.MaxHealth
                    end
                    
                    -- Protección contra herramientas de daño
                    for _, tool in ipairs(Character:GetChildren()) do
                        if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                            local handle = tool.Handle
                            -- Prevenir daño por contacto
                            for _, touchInterest in ipairs(handle:GetChildren()) do
                                if touchInterest:IsA("TouchTransmitter") then
                                    touchInterest:Destroy()
                                end
                            end
                        end
                    end
                end)
                
                -- MÉTODO 5: Protección contra fuego/veneno
                for _, child in ipairs(Character:GetChildren()) do
                    if child:IsA("Fire") or child:IsA("Sparkles") or child.Name:lower():find("fire") or child.Name:lower():find("damage") then
                        child:Destroy()
                    end
                end
                
                -- MÉTODO 6: Conectar evento de muerte
                Humanoid.Died:Connect(function()
                    if inmortal then
                        wait(2)
                        if LocalPlayer.Character then
                            setImmortal(true)
                        end
                    end
                end)
            end
        end
        
        -- Ejecutar ahora y en cada respawn
        setupImmortality()
        
    else
        inmortalButton.Text = "Inmortal: OFF"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        -- Restaurar valores normales
        local Character = LocalPlayer.Character
        if Character and Character:FindFirstChild("Humanoid") then
            Character.Humanoid.MaxHealth = 100
            Character.Humanoid.Health = 100
        end
    end
end

-- Click del botón
inmortalButton.MouseButton1Click:Connect(function()
    setImmortal(not inmortal)
end)

-- Protección extra para MM2 y juegos con anti-cheat
local function antiKillProtection()
    -- Prevenir scripts de kill instantáneo
    for _, script in ipairs(LocalPlayer.PlayerScripts:GetDescendants()) do
        if script:IsA("LocalScript") and script.Name:lower():find("kill") or script.Name:lower():find("death") then
            script.Disabled = true
        end
    end
end

-- Ejecutar protección anti-kill al iniciar
wait(3)
antiKillProtection()
