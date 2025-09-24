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
spawnButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
spawnButton.Parent = ScreenGui

local swapButton = Instance.new("TextButton")
swapButton.Size = UDim2.new(0, 120, 0, 40)
swapButton.Position = UDim2.new(0, 10, 0, 250)
swapButton.Text = "Intercambiar"
swapButton.BackgroundColor3 = Color3.fromRGB(200, 200, 100)
swapButton.Parent = ScreenGui

-- Crear clon con la misma apariencia del jugador
local function crearClon()
    local dummy = Instance.new("Model")
    dummy.Name = "ClonDummy"

    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = dummy

    local root = Instance.new("Part")
    root.Name = "HumanoidRootPart"
    root.Size = Vector3.new(2,2,1)
    root.Anchored = true
    root.CanCollide = false
    root.Transparency = 1
    root.Position = HumanoidRootPart.Position + (HumanoidRootPart.CFrame.LookVector * 6)
    root.Parent = dummy
    dummy.PrimaryPart = root

    -- copiar apariencia del jugador
    local desc = Character:FindFirstChildOfClass("Humanoid"):GetAppliedDescription()
    humanoid:ApplyDescription(desc)

    dummy.Parent = workspace
    return dummy
end

-- ON/OFF Clon
spawnButton.MouseButton1Click:Connect(function()
    if clonActivo then
        if clon and clon.Parent then clon:Destroy() end
        clon = nil
        clonActivo = false
        spawnButton.Text = "Clon OFF"
        spawnButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
    else
        clon = crearClon()
        clonActivo = true
        spawnButton.Text = "Clon ON"
        spawnButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
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
