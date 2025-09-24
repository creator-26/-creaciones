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

-- Crear un clon igual al personaje del jugador
local function crearClon()
    local char = LocalPlayer.Character
    if not char then return end

    -- Copiar el modelo del Character entero
    local dummy = char:Clone()
    dummy.Name = "ClonDummy"

    -- Quitar scripts que puedan hacerlo desaparecer
    for _, obj in pairs(dummy:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") then
            obj:Destroy()
        end
    end

    -- Posición frente al jugador
    local hrp = dummy:FindFirstChild("HumanoidRootPart")
    if hrp then
        local frente = HumanoidRootPart.CFrame.LookVector * 6
        hrp.CFrame = HumanoidRootPart.CFrame + frente
    end

    -- Evitar que el clon sea controlable
    local hum = dummy:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None -- oculta nombre
        hum:ChangeState(Enum.HumanoidStateType.Seated) -- lo deja quieto
        hum.PlatformStand = true -- congelado
    end

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
