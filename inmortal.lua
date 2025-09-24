-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Esperar a que el character exista
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

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

-- Función para manejar el cambio de personaje
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = newCharacter:WaitForChild("Humanoid")
    
    -- Reconectar la función de inmortalidad si estaba activada
    if inmortal then
        setImmortal(true)
    end
end)

-- Función para activar/desactivar
local function setImmortal(state)
    inmortal = state
    
    -- Desconectar conexión anterior si existe
    if healthConnection then
        healthConnection:Disconnect()
        healthConnection = nil
    end
    
    if inmortal then
        inmortalButton.Text = "Inmortal: ON"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        
        -- Método 1: Prevenir daño inmediato
        healthConnection = Humanoid.HealthChanged:Connect(function(hp)
            if inmortal and hp < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
        
        -- Método 2: Hacer invencible (más efectivo)
        Humanoid.MaxHealth = math.huge
        Humanoid.Health = math.huge
        
        -- Método 3: Prevenir muerte por caída
        if Humanoid:FindFirstChild("PlatformStand") then
            Humanoid.PlatformStand = false
        end
        
    else
        inmortalButton.Text = "Inmortal: OFF"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        -- Restaurar valores normales
        Humanoid.MaxHealth = 100
        Humanoid.Health = 100
    end
end

-- Click del botón
inmortalButton.MouseButton1Click:Connect(function()
    setImmortal(not inmortal)
end)

-- Protección adicional contra respawn
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid").Died:Connect(function()
        if inmortal then
            -- Esperar un momento y reactivar la inmortalidad
            wait(1)
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                setImmortal(true)
            end
        end
    end)
end)
