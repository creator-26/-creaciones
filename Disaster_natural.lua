-- nds_disaster_reader.lua | Mobile NDS Disaster HUD
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

-- GUI propia
local gui = Instance.new("ScreenGui")
gui.Name = "DisasterHUD"
gui.ResetOnSpawn = false
gui.Parent = pg

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 70)
frame.Position = UDim2.new(0.5, -110, 0.9, -35)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Parent = gui

local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.fromScale(1, 1)
lbl.BackgroundTransparency = 1
lbl.Text = "Esperando desastre..."
lbl.TextColor3 = Color3.new(1, 1, 1)
lbl.TextScaled = true
lbl.Font = Enum.Font.GothamBold
lbl.Parent = frame

-- Colores por tipo
local colors = {
	Fire = Color3.fromRGB(255, 80, 80),
	Tornado = Color3.fromRGB(255, 200, 50),
	Tsunami = Color3.fromRGB(50, 150, 255),
	Earthquake = Color3.fromRGB(150, 100, 50),
	Flood = Color3.fromRGB(50, 200, 255),
	Lightning = Color3.fromRGB(200, 150, 255),
	Sandstorm = Color3.fromRGB(200, 180, 120),
	Meteor = Color3.fromRGB(180, 100, 255),
	Blizzard = Color3.fromRGB(200, 220, 255),
	Volcano = Color3.fromRGB(255, 100, 0),
}

-- Traducciones rápidas
local spanish = {
	Fire = "Fuego",
	Tornado = "Tornado",
	Tsunami = "Tsunami",
	Earthquake = "Terremoto",
	Flood = "Inundación",
	Lightning = "Tormenta",
	Sandstorm = "Tormenta de arena",
	Meteor = "Lluvia de meteoritos",
	Blizzard = "Ventisca",
	Volcano = "Volcán",
}

-- Leer valor que pone el servidor
local disaster = RS:WaitForChild("Disaster", 5) -- StringValue
if disaster then
	disaster.Changed:Connect(function(v)
		local esp = spanish[v] or v
		lbl.Text = "Próximo: " .. esp
		frame.BackgroundColor3 = colors[v] or Color3.new(1, 1, 1)
	end)
	-- inicial
	local v = disaster.Value
	if v ~= "" then
		lbl.Text = "Próximo: " .. (spanish[v] or v)
		frame.BackgroundColor3 = colors[v] or Color3.new(1, 1, 1)
	end
end

-- Backup: leer el Message oficial (por si el valor tarda)
local function checkMessage(msg)
	for eng, esp in pairs(spanish) do
		if string.find(string.lower(msg), string.lower(eng)) then
			lbl.Text = "Próximo: " .. esp
			frame.BackgroundColor3 = colors[eng] or Color3.new(1, 1, 1)
			break
		end
	end
end

-- Escuchar mensajes del servidor
local starterGui = game:GetService("StarterGui")
local msgConn
msgConn = starterGui.ChildAdded:Connect(function(child)
	if child:IsA("Message") then
		checkMessage(child.Text)
		task.wait(5)
		msgConn:Disconnect()
	end
end)

print("NDS Disaster HUD activado – mira el botón inferior.")
