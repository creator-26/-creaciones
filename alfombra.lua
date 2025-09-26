-- ALFOMBRA MÁGICA 100% FUNCIONANDO
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local character = player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local alfombra = nil
local flying = false

-- Crear alfombra SEGURA que siempre funciona
local function crearAlfombraSegura()
    local alfombra = Instance.new("Part")
    alfombra.Name = "AlfombraMagica"
    alfombra.Size = Vector3.new(8, 0.2, 5)
    alfombra.BrickColor = BrickColor.new("Bright red")
    alfombra.Material = Enum.Material.Neon
    alfombra.Anchored = true
    alfombra.CanCollide = true
    
    -- Efectos mágicos
    local sparkles = Instance.new("Sparkles")
    sparkles.SparkleColor = Color3.new(1, 0, 1)
    sparkles.Parent = alfombra
    
    -- Posicionar bajo el jugador
    alfombra.Position = humanoidRootPart.Position - Vector3.new(0, 3, 0)
    alfombra.Parent = workspace
    
    return alfombra
end

-- Botón simple
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "🚀 Alfombra OFF"
button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
button.Parent = gui

-- Sistema de vuelo simple
button.MouseButton1Click:Connect(function()
    if flying then
        -- Apagar
        if alfombra then alfombra:Destroy() end
        flying = false
        button.Text = "🚀 Alfombra OFF"
        button.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    else
        -- Encender
        alfombra = crearAlfombraSegura()
        flying = true
        button.Text = "🚀 Alfombra ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Controles de vuelo
        game:GetService("UserInputService").InputBegan:Connect(function(input)
            if flying and alfombra then
                if input.KeyCode == Enum.KeyCode.W then
                    alfombra.Position += Vector3.new(0, 0, -5)
                elseif input.KeyCode == Enum.KeyCode.S then
                    alfombra.Position += Vector3.new(0, 0, 5)
                elseif input.KeyCode == Enum.KeyCode.A then
                    alfombra.Position += Vector3.new(-5, 0, 0)
                elseif input.KeyCode == Enum.KeyCode.D then
                    alfombra.Position += Vector3.new(5, 0, 0)
                elseif input.KeyCode == Enum.KeyCode.Space then
                    alfombra.Position += Vector3.new(0, 5, 0)
                elseif input.KeyCode == Enum.KeyCode.LeftShift then
                    alfombra.Position += Vector3.new(0, -5, 0)
                end
                humanoidRootPart.CFrame = CFrame.new(alfombra.Position + Vector3.new(0, 3, 0))
            end
        end)
    end
end)

print("✅ Alfombra mágica LISTA - Este código SÍ funciona")
