local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local clon = nil
local clonActivo = false

-- GUI simple
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))

local spawnButton = Instance.new("TextButton", ScreenGui)
spawnButton.Size = UDim2.new(0, 120, 0, 40)
spawnButton.Position = UDim2.new(0, 10, 0, 200)
spawnButton.Text = "Clon OFF"
spawnButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)

local swapButton = Instance.new("TextButton", ScreenGui)
swapButton.Size = UDim2.new(0, 120, 0, 40)
swapButton.Position = UDim2.new(0, 10, 0, 250)
swapButton.Text = "Intercambiar"
swapButton.BackgroundColor3 = Color3.fromRGB(200, 200, 100)

-- Crear clon igual al jugador
local function crearClon()
    local char = LocalPlayer.Character
    if not char then return end

    -- clonar
    local dummy = char:Clone()
    dummy.Name = "ClonDummy"

    -- eliminar scripts que den problemas
    for _, obj in pairs(dummy:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") then
            obj:Destroy()
        end
    end

    -- posicionar al frente
    local hrp = dummy:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = HumanoidRootPart.CFrame * CFrame.new(0, 0, -6)
        hrp.Anchored = true
    end

    -- congelar
    local hum = dummy:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.PlatformStand = true
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    dummy.Parent = workspace
    return dummy
end

-- Botón ON/OFF
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

-- Botón intercambiar
swapButton.MouseButton1Click:Connect(function()
    if clon and clon.PrimaryPart then
        local playerPos = HumanoidRootPart.CFrame
        HumanoidRootPart.CFrame = clon.PrimaryPart.CFrame
        clon.PrimaryPart.CFrame = playerPos
    end
end)
