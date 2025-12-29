--// MM2 Aura ESP + Hub cuadrado + Speed slider (MÓVIL)
--// by k2#9922

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

--// Auras (igual que antes)
local auras = {}
local function getRole(player)
	local char = player.Character
	if not char then return "Innocent" end
	local knife = char:FindFirstChild("Knife") or char:FindFirstChild("KnifeMesh")
	local gun = char:FindFirstChild("Gun") or char:FindFirstChild("RevolverMesh")
	if knife then return "Murderer" end
	if gun then return "Sheriff" end
	return "Innocent"
end
local function updateAura(player)
	local h = auras[player]
	if h then
		local role = getRole(player)
		h.FillColor = role=="Murderer" and Color3.fromRGB(255,50,50) or
		              role=="Sheriff" and Color3.fromRGB(50,150,255) or
		              Color3.fromRGB(255,255,255)
		h.FillTransparency = 0.35
	end
end
local function createAura(player)
	local hl = Instance.new("Highlight", game.CoreGui)
	hl.Name = player.Name.."_Aura"
	hl.Adornee = player.Character or player.CharacterAdded:Wait()
	auras[player] = hl
	updateAura(player)
	player.CharacterAdded:Connect(function(c)
		hl.Adornee = c
		updateAura(c)
	end)
end
local function removeAura(player) if auras[player] then auras[player]:Destroy(); auras[player]=nil end end
Players.PlayerAdded:Connect(createAura)
Players.PlayerRemoving:Connect(removeAura)
for _,p in pairs(Players:GetPlayers()) do if p~=localPlayer then createAura(p) end end
RunService.RenderStepped:Connect(function() for pl,_ in pairs(auras) do updateAura(pl) end end)

--// UI: Hub cuadrado
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local Hub = Instance.new("Frame")
Hub.Size = UDim2.new(0,180,0,220)
Hub.Position = UDim2.new(0.5,-90,05,-90,0.5,-110)
Hub.BackgroundColor3 = Color3.new(0.05,0.05,0.05)
Hub.BackgroundTransparency = 0.25
Hub.BorderSizePixel = 0
Hub.Active = true
Hub.Draggable = true
Hub.Parent = ScreenGui

--// Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,0)
Title.BackgroundTransparency = 1
Title.Text = "MM2 Hub"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextScaled = true
Title.Parent = Hub

--// Botón Aura
local AuraBtn = Instance.new("TextButton")
AuraBtn.Size = UDim2.new(0,150,0,40)
AuraBtn.Position = UDim2.new(0.5,-75,0,40)
AuraBtn.BackgroundColor3 = Color3.new(1,1,1)
AuraBtn.BackgroundTransparency = 0.3
AuraBtn.Text = "Aura: ON"
AuraBtn.TextColor3 = Color3.new(0,0,0)
AuraBtn.Font = Enum.Font.GothamBold
AuraBtn.TextScaled = true
AuraBtn.Parent = Hub

--// Texto Speed
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0,150,0,25)
SpeedLabel.Position = UDim2.new(0.5,-75,0,95)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed"
SpeedLabel.TextColor3 = Color3.new(1,1,1)
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextScaled = true
SpeedLabel.Parent = Hub

--// Slider Speed
local Slider = Instance.new("Frame")
Slider.Size = UDim2.new(0,150,0,20)
Slider.Position = UDim2.new(0.5,-75,0,125)
Slider.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
Slider.BorderSizePixel = 0
Slider.Parent = Hub

local Fill = Instance.new("Frame")
Fill.Size = UDim2.new(0.5,0,1,0)
Fill.BackgroundColor3 = Color3.fromRGB(0,150,255)
Fill.BorderSizePixel = 0
Fill.Parent = Slider

local Thumb = Instance.new("TextButton")
Thumb.Size = UDim2.new(0,15,0,30)
Thumb.Position = UDim2.new(0.5,-7,0.5,-15)
Thumb.BackgroundColor3 = Color3.new(1,1,1)
Thumb.Text = ""
Thumb.Parent = Slider

--// Lógica slider
local speedVal = 16
local dragging = false
local function updateSpeed(x)
	local abs = Slider.AbsolutePosition.X
	local size = Slider.AbsoluteSize.X
	local percent = math.clamp((x-abs)/size,0,1)
	Fill.Size = UDim2.new(percent,0,1,0)
	Thumb.Position = UDim2.new(percent,-7,0.5,-15)
	speedVal = 16 + percent*84   -- 16-100
	if humanoid then humanoid.WalkSpeed = speedVal end
end
Thumb.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end end)
UserInputService.TouchEnded:Connect(function() dragging=false end)
UserInputService.InputChanged:Connect(function(i)
	if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
		updateSpeed(i.Position.X)
	end
end)

--// Toggle Aura
local auraEnabled = true
AuraBtn.MouseButton1Click:Connect(function()
	auraEnabled = not auraEnabled
	AuraBtn.Text = auraEnabled and "Aura: ON" or "Aura: OFF"
	for _,h in pairs(game.CoreGui:GetChildren()) do
		if h:IsA("Highlight") then h.Enabled = auraEnabled end
	end
end)

--// Aplicar speed al respawn
localPlayer.CharacterAdded:Connect(function(char)
	humanoid = char:WaitForChild("Humanoid")
	humanoid.WalkSpeed = speedVal
end)
