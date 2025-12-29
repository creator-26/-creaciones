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
local boostedSpeed = 32  -- Ajusta este valor para más rápido (ej: 50 para muy rápido)

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
Title.Text = "MM2 Hub"
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

--// Botón Speed
local SpeedButton = Instance.new("TextButton")
SpeedButton.Size = UDim2.new(0.8, 0, 0.2, 0)
SpeedButton.Position = UDim2.new(0.1, 0, 0.6, 0)
SpeedButton.BackgroundColor3 = Color3.new(1,1,1)
SpeedButton.BackgroundTransparency = 0.5
SpeedButton.Text = "Speed OFF"
SpeedButton.TextColor3 = Color3.new(0,0,0)
SpeedButton.Font = Enum.Font.GothamBold
SpeedButton.TextScaled = true
SpeedButton.Parent = Hub

SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    SpeedButton.Text = speedEnabled and "Speed ON" or "Speed OFF"
    applySpeed()
end)

--// Si quieres hacerlo scrollable, agrega un ScrollingFrame dentro de Hub
--// Por ejemplo:
--// local Scroll = Instance.new("ScrollingFrame", Hub)
--// Scroll.Size = UDim2.new(1,0,0.8,0)
--// Scroll.Position = UDim2.new(0,0,0.2,0)
--// Luego mueve los botones dentro de Scroll y ajusta CanvasSize si agregas más.
