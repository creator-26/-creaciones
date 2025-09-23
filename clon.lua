-- Clon simple tipo maniquí con botones de control
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local clon = nil

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

-- Botón de Spawn/Despawn
local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(0, 120, 0, 40)
spawnButton.Position = UDim2.new(0, 10, 0, 200)
spawnButton.Text = "Clon ON/OFF"
spawnButton.Parent = ScreenGui

-- Botón de Intercambio
local swapButton = Instance.new("TextButton")
swapButton.Size = UDim2.new(0, 120, 0, 40)
swapButton.Position = UDim2.new(0, 10, 0, 250)
swapButton.Text = "Intercambiar"
swapButton.Parent = ScreenGui

-- Función para crear un clon tipo maniquí
local function crearClon()
    local dummy = Instance.new("Model")
    dummy.Name = "ClonManiqui"

    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = dummy

    -- Crear torso simple
    local root = Instance.new("Part")
    root.Size = Vector3.new(2, 2, 1)
    root.Position = HumanoidRootPart.Position + Vector3.new(5, 0, 0)
    root.Anchored = false
    root.CanCollide = true
    root.BrickColor = BrickColor.new("Medium stone grey")
    root.Name = "HumanoidRootPart"
    root.Parent = dummy

    humanoid.RootPart = root
    dummy.Parent = workspace
    return dummy
end

-- Alternar spawn/despawn
spawnButton.MouseButton1Click:Connect(function()
    if clon and clon.Parent then
        clon:Destroy()
        clon = nil
    else
        clon = crearClon()
    end
end)

-- Intercambiar posiciones
swapButton.MouseButton1Click:Connect(function()
    if clon and clon:FindFirstChild("HumanoidRootPart") then
        local playerPos = HumanoidRootPart.Position
        HumanoidRootPart.CFrame = clon.HumanoidRootPart.CFrame
        clon.HumanoidRootPart.CFrame = CFrame.new(playerPos)
    end
end)
