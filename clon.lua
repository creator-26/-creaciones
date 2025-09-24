local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local clon = nil
local clonActivo = false

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(0, 120, 0, 40)
spawnButton.Position = UDim2.new(0, 10, 0, 200)
spawnButton.Text = "Clon OFF"
spawnButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100) -- rojo = apagado
spawnButton.Parent = ScreenGui

local swapButton = Instance.new("TextButton")
swapButton.Size = UDim2.new(0, 120, 0, 40)
swapButton.Position = UDim2.new(0, 10, 0, 250)
swapButton.Text = "Intercambiar"
swapButton.BackgroundColor3 = Color3.fromRGB(200, 200, 100)
swapButton.Parent = ScreenGui

-- Crear un dummy estilo Robloxian clásico
local function crearClon()
    local dummy = Instance.new("Model")
    dummy.Name = "ClonDummy"

    -- Humanoid
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = dummy

    -- RootPart
    local root = Instance.new("Part")
    root.Name = "HumanoidRootPart"
    root.Size = Vector3.new(2, 2, 1)
    root.Transparency = 1
    root.Anchored = true
    root.CanCollide = false
    root.Position = HumanoidRootPart.Position + (HumanoidRootPart.CFrame.LookVector * 6)
    root.Parent = dummy
    dummy.PrimaryPart = root

    -- Torso
    local torso = Instance.new("Part")
    torso.Size = Vector3.new(2, 2, 1)
    torso.BrickColor = BrickColor.new("Bright blue")
    torso.Name = "Torso"
    torso.Position = root.Position + Vector3.new(0, 2, 0)
    torso.Parent = dummy

    -- Cabeza
    local head = Instance.new("Part")
    head.Size = Vector3.new(2, 1, 1)
    head.BrickColor = BrickColor.new("Pastel brown")
    head.Name = "Head"
    head.Position = torso.Position + Vector3.new(0, 1.5, 0)
    head.Parent = dummy

    -- Brazos
    local leftArm = Instance.new("Part")
    leftArm.Size = Vector3.new(1, 2, 1)
    leftArm.BrickColor = BrickColor.new("Pastel brown")
    leftArm.Name = "Left Arm"
    leftArm.Position = torso.Position + Vector3.new(-1.5, 0, 0)
    leftArm.Parent = dummy

    local rightArm = Instance.new("Part")
    rightArm.Size = Vector3.new(1, 2, 1)
    rightArm.BrickColor = BrickColor.new("Pastel brown")
    rightArm.Name = "Right Arm"
    rightArm.Position = torso.Position + Vector3.new(1.5, 0, 0)
    rightArm.Parent = dummy

    -- Piernas
    local leftLeg = Instance.new("Part")
    leftLeg.Size = Vector3.new(1, 2, 1)
    leftLeg.BrickColor = BrickColor.new("Black")
    leftLeg.Name = "Left Leg"
    leftLeg.Position = torso.Position + Vector3.new(-0.5, -2, 0)
    leftLeg.Parent = dummy

    local rightLeg = Instance.new("Part")
    rightLeg.Size = Vector3.new(1, 2, 1)
    rightLeg.BrickColor = BrickColor.new("Black")
    rightLeg.Name = "Right Leg"
    rightLeg.Position = torso.Position + Vector3.new(0.5, -2, 0)
    rightLeg.Parent = dummy

    -- Welds para que no se separen
    local function weld(part0, part1)
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = part0
        weld.Part1 = part1
        weld.Parent = part0
    end

    weld(root, torso)
    weld(torso, head)
    weld(torso, leftArm)
    weld(torso, rightArm)
    weld(torso, leftLeg)
    weld(torso, rightLeg)

    dummy.Parent = workspace
    return dummy
end

-- ON/OFF Clon
spawnButton.MouseButton1Click:Connect(function()
    if clonActivo then
        -- Apagar clon
        if clon and clon.Parent then clon:Destroy() end
        clon = nil
        clonActivo = false
        spawnButton.Text = "Clon OFF"
        spawnButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100) -- rojo
    else
        -- Encender clon
        clon = crearDummy()
        clonActivo = true
        spawnButton.Text = "Clon ON"
        spawnButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100) -- verde
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
