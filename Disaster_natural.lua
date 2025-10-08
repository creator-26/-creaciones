-- nds_true_predict.lua | Lee el desastre ANTES del anuncio visible
local SG = game:GetService("StarterGui")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

-- GUI propia
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
lbl.Text = "Buscando desastre..."
lbl.TextColor3 = Color3.new(1, 1, 1)
lbl.TextScaled = true
lbl.Font = Enum.Font.GothamBold
lbl.Parent = fr

-- Sonido
local sound = Instance.new("Sound", gui)
sound.SoundId = "rbxassetid://4590657391"
sound.Volume = 0.6

-- Tabla
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

-- Escanea cuando aparezca el label del servidor
local function scan(label)
	label.Changed:Connect(function()
		local raw = string.lower(label.Text)
		for eng, esp in pairs(spanish) do
			if string.find(raw, string.lower(eng)) then
				lbl.Text = "Próximo: " .. esp
				fr.BackgroundColor3 = colors[eng] or Color3.new(1, 1, 1)
				sound:Play()
				break
			end
		end
	end)
end

-- Detecta cuando el servidor cree la GUI del desastre
SG.ChildAdded:Connect(function(sc)
	local lbl = sc:FindFirstChildOfClass("TextLabel") or sc:FindFirstChild("DisasterLabel") or sc:FindFirstChild("Disaster")
	if lbl and lbl:IsA("TextLabel") then
		scan(lbl)
	end
end)

-- Por si ya existe (mapa reiniciado)
for _, sc in ipairs(SG:GetChildren()) do
	local lbl = sc:FindFirstChildOfClass("TextLabel") or sc:FindFirstChild("DisasterLabel") or sc:FindFirstChild("Disaster")
	if lbl and lbl:IsA("TextLabel") then scan(lbl) end
end

print("NDS True Predict activado – aviso ANTES del cartel.")
