local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local clon = nil

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(0, 120, 0, 40)
spawnButton.Position = UDim2.new(0, 10, 0, 200)
spawnButton.Text = "Clon ON/OFF"
spawnButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
spawnButton.Parent = ScreenGui

local swapButton = Instance.new("TextButton")
swapButton.Size = UDim2.new(0, 120, 0, 40)
swapButton.Position = UDim2.new(0, 10, 0, 250)
swapButton.Text = "Intercambiar"
swapButton.BackgroundColor3 = Color3.fromRGB(200, 200, 100)
swapButton.Parent = ScreenGui

-- Crear un Dummy estilo personaje
local function crearDummy()
    local dummy = Instance.new("Model")
    dummy.Name = "ClonDummy"

    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = dummy

    local root = Instance.new("Part")
    root.Name = "HumanoidRootPart"
    root.Size = Vector3.new(2, 2, 1)
    root.Position = HumanoidRootPart.Position + Vector3.new(5, 0, 0)
    root.Anchored = false
    root.BrickColor = BrickColor.new("Medium stone grey")
    root.Parent = dummy
    dummy.PrimaryPart = root

    -- Crear cabeza
    local head = Instance.new("Part")
    head.Size = Vector3.new(2, 1, 1)
    head.Position = root.Position + Vector3.new(0, 3, 0)
    head.BrickColor = BrickColor.new("Really black")
    head.Name = "Head"
    head.Parent = dummy

    -- Crear torso
    local torso = Instance.new("Part")
    torso.Size = Vector3.new(2, 2, 1)
    torso.Position = root.Position + Vector3.new(0, 2, 0)
    torso.BrickColor = BrickColor.new("Bright blue")
    torso.Name = "Torso"
    torso.Parent = dummy

    -- Juntar piezas con welds
    local weld1 = Instance.new("WeldConstraint")
    weld1.Part0 = root
    weld1.Part1 = torso
    weld1.Parent = root

    local weld2 = Instance.new("WeldConstraint")
    weld2.Part0 = torso
    weld2.Part1 = head
    weld2.Parent = torso

    dummy.Parent = workspace
    return dummy
end

-- ON/OFF Clon
spawnButton.MouseButton1Click:Connect(function()
    if clon and clon.Parent then
        clon:Destroy()
        clon = nil
    else
        clon = crearDummy()
    end
end)

-- Intercambiar posiciones
swapButton.MouseButton1Click:Connect(function()
    if clon and clon.PrimaryPart then
        local playerPos = HumanoidRootPart.CFrame
        HumanoidRootPart.CFrame = clon.PrimaryPart.CFrame
        clon.PrimaryPart.CFrame = playerPos
    end
end)
