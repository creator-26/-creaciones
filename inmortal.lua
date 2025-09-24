-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
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

-- Función para activar/desactivar
local function setImmortal(state)
    inmortal = state
    if inmortal then
        inmortalButton.Text = "Inmortal: ON"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        -- Conectar función de evitar muertes
        Humanoid.HealthChanged:Connect(function(hp)
            if inmortal and hp < Humanoid.MaxHealth then
                Humanoid.Health = Humanoid.MaxHealth
            end
        end)
    else
        inmortalButton.Text = "Inmortal: OFF"
        inmortalButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    end
end

-- Click del botón
inmortalButton.MouseButton1Click:Connect(function()
    setImmortal(not inmortal)
end)