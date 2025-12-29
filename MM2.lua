--// MM2 Aura ESP + Toggle Móvil (FIXED)
--// by k2#9922

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// Tabla de auras
local auras = {}

--// Detectar rol en tiempo real
local function getRole(player)
    local char = player.Character
    if not char then return "Innocent" end
    local knife = char:FindFirstChild("Knife") or char:FindFirstChild("KnifeMesh")
    local gun = char:FindFirstChild("Gun") or char:FindFirstChild("RevolverMesh")
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

--// Actualizar colores cada frame
RunService.RenderStepped:Connect(function()
    for plr, _ in pairs(auras) do updateAura(plr) end
end)

--// UI Toggle móvil (botón funcional)
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0,90,0,90)
Button.Position = UDim2.new(0.5,-45,0.9,0)
Button.BackgroundColor3 = Color3.new(1,1,1)
Button.BackgroundTransparency = 0.3
Button.BorderSizePixel = 0
Button.Text = "Aura\nON"
Button.TextColor3 = Color3.new(0,0,0)
Button.Font = Enum.Font.GothamBold
Button.TextScaled = true
Button.Active = true
Button.Draggable = true
Button.Parent = ScreenGui

local enabled = true
Button.MouseButton1Click:Connect(function()
    enabled = not enabled
    Button.Text = enabled and "Aura\nON" or "Aura\nOFF"
    for _,h in pairs(game.CoreGui:GetChildren()) do
        if h:IsA("Highlight") then h.Enabled = enabled end
    end
end)

