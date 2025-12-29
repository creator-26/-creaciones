--// MM2 Aura ESP + Toggle Móvil
--// by k2#9922

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local camera = workspace.CurrentCamera

--// Roles
local function getRole(player)
    local char = player.Character or player.CharacterAdded:Wait()
    local knife = char:FindFirstChild("Knife") or char:FindFirstChild("KnifeMesh")
    local gun = char:FindFirstChild("Gun") or char:FindFirstChild("RevolverMesh")
    if knife then return "Murderer" end
    if gun then return "Sheriff" end
    return "Innocent"
end

--// Crear auras
local auras = {}
local function createAura(player)
    local role = getRole(player)
    local color = role == "Murderer" and Color3.fromRGB(255,0,0) or
                  role == "Sheriff" and Color3.fromRGB(0,150,255) or
                  Color3.fromRGB(255,255,255)

    local highlight = Instance.new("Highlight")
    highlight.Name = player.Name.."_Aura"
    highlight.FillColor = color
    highlight.FillTransparency = 0.75
    highlight.OutlineTransparency = 1
    highlight.Parent = game.CoreGui
    highlight.Adornee = player.Character or player.CharacterAdded:Wait()
    auras[player] = highlight

    player.CharacterAdded:Connect(function(char)
        highlight.Adornee = char
    end)
end

--// Limpiar al salir
local function removeAura(player)
    if auras[player] then
        auras[player]:Destroy()
        auras[player] = nil
    end
end

Players.PlayerAdded:Connect(createAura)
Players.PlayerRemoving:Connect(removeAura)
for _,p in pairs(Players:GetPlayers()) do if p~=localPlayer then createAura(p) end end

--// UI Toggle móvil
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0,80,0,80)
Frame.Position = UDim2.new(0.5,0,0.9,0)
Frame.BackgroundColor3 = Color3.new(1,1,1)
Frame.BackgroundTransparency = 0.3
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local Text = Instance.new("TextLabel")
Text.Size = UDim2.new(1,0,1,0)
Text.Text = "Aura\nON"
Text.TextColor3 = Color3.new(0,0,0)
Text.BackgroundTransparency = 1
Text.Font = Enum.Font.GothamBold
Text.TextScaled = true
Text.Parent = Frame

local enabled = true
Frame.MouseButton1Click:Connect(function()
    enabled = not enabled
    Text.Text = enabled and "Aura\nON" or "Aura\nOFF"
    for _,h in pairs(game.CoreGui:GetChildren()) do
        if h:IsA("Highlight") then h.Enabled = enabled end
    end
end)
