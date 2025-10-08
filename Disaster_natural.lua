-- nds_predict.lua | Predicción NDS (mobile)
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PredictGui"
gui.ResetOnSpawn = false
gui.Parent = pg

local fr = Instance.new("Frame")
fr.Size = UDim2.new(0, 260, 0, 90)
fr.Position = UDim2.new(0.5, -130, 0.05, 0)
fr.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
fr.BackgroundTransparency = 0.2
fr.BorderSizePixel = 0
fr.Parent = gui

local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.fromScale(1, 1)
lbl.BackgroundTransparency = 1
lbl.Text = "Esperando mapa..."
lbl.TextColor3 = Color3.new(1, 1, 1)
lbl.TextScaled = true
lbl.Font = Enum.Font.GothamBold
lbl.Parent = fr

-- Sonido de alerta
local sound = Instance.new("Sound", gui)
sound.SoundId = "rbxassetid://4590657391" -- corto 'alert'
sound.Volume = 0.6

-- Tabla colores / nombres
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
local spanish = {
	Fire = "🔥 Fuego",
	Tornado = "🌪 Tornado",
	Tsunami = "🌊 Tsunami",
	Earthquake = "🌍 Terremoto",
	Flood = "💧 Inundación",
	Lightning = "⚡ Tormenta",
	Sandstorm = "🌫 Tormenta de arena",
	Meteor = "☄ Meteoritos",
	Blizzard = "🌨 Ventisca",
	Volcano = "🌋 Volcán",
}

-- Leer Disaster
local function readDisaster()
	local map = RS:FindFirstChild("Map")
	if not map then return end
	local dis = map:FindFirstChild("Disaster")
	if dis and dis:IsA("StringValue") and dis.Value ~= "" then
		local v = dis.Value
		local esp = spanish[v] or v
		lbl.Text = "Próximo: " .. esp
		fr.BackgroundColor3 = colors[v] or Color3.new(1, 1, 1)
		sound:Play()
	end
end

-- Conectar cambios
local map = RS:WaitForChild("Map", 5)
if map then
	local dis = map:FindFirstChild("Disaster")
	if dis then
		dis.Changed:Connect(readDisaster)
		readDisaster() -- inicial
	else
		-- Si aún no existe, esperar
		map.ChildAdded:Connect(function(c)
			if c.Name == "Disaster" and c:IsA("StringValue") then
				c.Changed:Connect(readDisaster)
				readDisaster()
			end
		end)
	end
else
	lbl.Text = "Map no encontrado"
end

print("NDS Predict activado – aviso antes del anuncio.")
