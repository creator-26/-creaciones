-- minimap.lua
-- Minimapa optimizado con rotación y suavizado

local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MiniMapGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Frame del minimapa
local mapFrame = Instance.new("Frame")
mapFrame.Size = UDim2.new(0, 150, 0, 150) -- más pequeño
mapFrame.Position = UDim2.new(0, 20, 0, 200)
mapFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mapFrame.BorderSizePixel = 0
mapFrame.BackgroundTransparency = 0.3
mapFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 20)
uiCorner.Parent = mapFrame

-- Jugador local (triángulo verde)
local playerIcon = Instance.new("Frame")
playerIcon.Size = UDim2.new(0, 14, 0, 14)
playerIcon.AnchorPoint = Vector2.new(0.5, 0.5)
playerIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
playerIcon.BackgroundTransparency = 1
playerIcon.Parent = mapFrame

local triangle = Instance.new("ImageLabel")
triangle.Size = UDim2.new(1, 0, 1, 0)
triangle.BackgroundTransparency = 1
triangle.Image = "rbxassetid://14590309638" -- un triángulo simple
triangle.ImageColor3 = Color3.fromRGB(0, 255, 0)
triangle.AnchorPoint = Vector2.new(0.5, 0.5)
triangle.Position = UDim2.new(0.5, 0, 0.5, 0)
triangle.Parent = playerIcon

-- Carpeta para íconos de jugadores
local dotsFolder = Instance.new("Folder")
dotsFolder.Name = "Dots"
dotsFolder.Parent = mapFrame

-- Función para crear puntitos rojos
local function createDot(player)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.Position = UDim2.new(0.5, 0, 0.5, 0)
    dot.BorderSizePixel = 0
    dot.Parent = dotsFolder
    return dot
end

-- Diccionario de jugadores
local playerDots = {}

-- Suavizado de posiciones
local function lerp(a, b, t)
    return a + (b - a) * t
end

-- Actualización (optimizada cada 0.1s)
task.spawn(function()
    while task.wait(0.1) do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            continue
        end

        -- Rotar triángulo según cámara
        triangle.Rotation = -Camera.CFrame.Rotation:ToEulerAnglesYXZ()

        local root = LocalPlayer.Character.HumanoidRootPart.Position

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local dot = playerDots[player]
                if not dot then
                    dot = createDot(player)
                    playerDots[player] = dot
                end

                local pos = player.Character.HumanoidRootPart.Position
                local relative = (pos - root) / 5 -- escala (ajústalo si quieres más zoom o menos)
                local targetX = 0.5 + relative.X / 150
                local targetY = 0.5 + relative.Z / 150

                -- Suavizado de movimiento
                local currentPos = dot.Position
                dot.Position = UDim2.new(
                    lerp(currentPos.X.Scale, targetX, 0.3),
                    0,
                    lerp(currentPos.Y.Scale, targetY, 0.3),
                    0
                )
            end
        end
    end
end)
