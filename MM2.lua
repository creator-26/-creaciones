--// MM2 Aura ESP + Speed Hack + Toggle Hub (FIXED & IMPROVED)
--// by k2#9922 (modified for immediate role detection, square draggable hub, speed toggle)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// Tabla de auras
local auras = {}

--// Detectar rol en tiempo real (check backpack y character para detectar inmediatamente después de inicio de ronda)
local function getRole(player)
    local char = player.Character
    if not char then return "Innocent" end
    local backpack = player:FindFirstChild("Backpack")
    local knife = (char:FindFirstChild("Knife") or (backpack and backpack:FindFirstChild("Knife")))
    local gun = (char:FindFirstChild("Gun") or (backpack and backpack:FindFirstChild("Gun")))
    if knife then return "Murderer" end
    if gun then return "Sheriff" end
    return "Innocent"
end

--// Actualizar color del aura
local function updateAura(player)
    local highlight = auras[player]
    if not highlight then return end
    local role = getRole(player)
    local color = role == "Murderer" and Color3.fromRGB(255,50,50) or
                  role == "Sheriff" and Color3.fromRGB(50,150,255) or
                  Color3.fromRGB(255,255,255)
    highlight.FillColor = color
    highlight.FillTransparency = 0.35   -- mucho más visible
    highlight.OutlineTransparency = 1
end

--// Crear aura
local function createAura(player)
    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name.."_Aura"
    highlight.Parent = game.CoreGui
    highlight.Adornee = player.Character or player.CharacterAdded:Wait()
    auras[player] = highlight
    updateAura(player)

    player.CharacterAdded:Connect(function(char)
        highlight.Adornee = char
        updateAura(player)
    end)
end

--// Limpiar al salir
local function removeAura(player)
    if auras[player] then
        auras[player]:Destroy()
        auras[player] = nil
    end
end

--// Conectar jugadores
Players.PlayerAdded:Connect(createAura)
Players.PlayerRemoving:Connect(removeAura)
for _,p in pairs(Players:GetPlayers()) do if p~=localPlayer then createAura(p) end end

--// Actualizar colores cada frame (para detección inmediata al inicio de ronda)
RunService.RenderStepped:Connect(function()
    for plr, _ in pairs(auras) do updateAura(plr) end
end)

--// Función para aplicar speed hack
local speedEnabled = false
local defaultSpeed = 16
local boostedSpeed = 28  -- Ajusta este valor para más rápido (ej: 50 para muy rápido)

local function applySpeed()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        local humanoid = localPlayer.Character.Humanoid
        humanoid.WalkSpeed = speedEnabled and boostedSpeed or defaultSpeed
    end
end

--// Reaplicar speed al respawn
localPlayer.CharacterAdded:Connect(applySpeed)

--// UI Hub cuadrado draggable (no scrollable por ahora, ya que hay pocos botones; se puede agregar si agregas más features)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Hub = Instance.new("Frame")
Hub.Size = UDim2.new(0, 150, 0, 150)  -- Cuadrado no tan grande
Hub.Position = UDim2.new(0.5, -75, 0.8, 0)  -- Centrado abajo
Hub.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
Hub.BackgroundTransparency = 0.3
Hub.BorderSizePixel = 0
Hub.Active = true
Hub.Draggable = true  -- Desplazable (draggable)
Hub.Parent = ScreenGui

--// Etiqueta título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0.2, 0)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "MM2xANA"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Hub

--// Botón Aura
local AuraButton = Instance.new("TextButton")
AuraButton.Size = UDim2.new(0.8, 0, 0.2, 0)
AuraButton.Position = UDim2.new(0.1, 0, 0.3, 0)
AuraButton.BackgroundColor3 = Color3.new(1,1,1)
AuraButton.BackgroundTransparency = 0.5
AuraButton.Text = "Aura ON"
AuraButton.TextColor3 = Color3.new(0,0,0)
AuraButton.Font = Enum.Font.GothamBold
AuraButton.TextScaled = true
AuraButton.Parent = Hub

local auraEnabled = true
AuraButton.MouseButton1Click:Connect(function()
    auraEnabled = not auraEnabled
    AuraButton.Text = auraEnabled and "Aura ON" or "Aura OFF"
    for _, h in pairs(game.CoreGui:GetChildren()) do
        if h:IsA("Highlight") then h.Enabled = auraEnabled end
    end
end)

--// Botón Speed con Slider
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.8, 0, 0.15, 0)
SpeedLabel.Position = UDim2.new(0.1, 0, 0.45, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed: 16"
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextScaled = true
SpeedLabel.Parent = Hub

local SpeedSlider = Instance.new("TextButton")
SpeedSlider.Size = UDim2.new(0.8, 0, 0.15, 0)
SpeedSlider.Position = UDim2.new(0.1, 0, 0.6, 0)
SpeedSlider.BackgroundColor3 = Color3.new(0.4,0.4,0.4)
SpeedSlider.Text = "Ajustar Speed (16-28)"
SpeedSlider.TextColor3 = Color3.new(1,1,1)
SpeedSlider.Font = Enum.Font.Gotham
SpeedSlider.TextScaled = true
SpeedSlider.Parent = Hub

local currentSpeed = 16

local function updateSpeed()
    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
        localPlayer.Character.Humanoid.WalkSpeed = currentSpeed
    end
    SpeedLabel.Text = "Speed: " .. currentSpeed
    SpeedButton.Text = currentSpeed > 16 and "Speed ON" or "Speed OFF"
end

SpeedSlider.MouseButton1Click:Connect(function()
    currentSpeed = currentSpeed + 4
    if currentSpeed > 28 then currentSpeed = 16 end
    updateSpeed()
end)

SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    currentSpeed = speedEnabled and 28 or 16  -- Valor por defecto cuando activas
    updateSpeed()
end)
--// Si quieres hacerlo scrollable, agrega un ScrollingFrame dentro de Hub
--// Por ejemplo:
--// local Scroll = Instance.new("ScrollingFrame", Hub)
--// Scroll.Size = UDim2.new(1,0,0.8,0)
--// Scroll.Position = UDim2.new(0,0,0.2,0)
--// Luego mueve los botones dentro de Scroll y ajusta CanvasSize si agregas más.
