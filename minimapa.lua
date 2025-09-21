-- minimap_exploit.lua
-- Minimapa básico con jugador y puntos de otros players
-- Para uso personal en tu cliente, no molestar a otros jugadores :)

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Nombre único
local GUI_NAME = "Alex_Minimap_v1"

-- Eliminar duplicados
if game.CoreGui:FindFirstChild(GUI_NAME) then
    game.CoreGui[GUI_NAME]:Destroy()
end

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.Parent = game.CoreGui
screenGui.ResetOnSpawn = false

-- Minimapa principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 200)
frame.Position = UDim2.new(0, 20, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

-- Bordes redondeados
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = frame

-- Tu jugador (triángulo)
local playerIcon = Instance.new("Frame")
playerIcon.Size = UDim2.new(0, 12, 0, 12)
playerIcon.Position = UDim2.new(0.5, -6, 0.5, -6)
playerIcon.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
playerIcon.Parent = frame

-- Convertir cuadrado en triángulo (clip path simulado con ImageLabel)
local icon = Instance.new("ImageLabel")
icon.Size = UDim2.new(1, 0, 1, 0)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://7072717697" -- icono de triangulito (puedes cambiar)
icon.Parent = playerIcon

-- Crear contenedor de jugadores
local playersFolder = Instance.new("Folder")
playersFolder.Name = "PlayersDots"
playersFolder.Parent = frame

-- Función para actualizar puntos de jugadores
local function updatePlayers()
    playersFolder:ClearAllChildren()

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            local dot = Instance.new("Frame")
            dot.Size = UDim2.new(0, 6, 0, 6)
            dot.AnchorPoint = Vector2.new(0.5, 0.5)
            dot.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            dot.Parent = playersFolder

            -- Posición relativa simplificada
            local relative = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position) / 5
            local x = math.clamp(relative.X + 100, 0, 200)
            local y = math.clamp(-relative.Z + 100, 0, 200)
            dot.Position = UDim2.new(0, x, 0, y)
        end
    end
end

-- Actualizar en cada frame
RunService.RenderStepped:Connect(updatePlayers)