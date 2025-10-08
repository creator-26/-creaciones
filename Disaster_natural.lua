-- nds_alert_v3.lua | Alerta EN CUANTO aparezca el desastre
local SG = game:GetService("StarterGui")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

-- 1) Crear GUI PROPIO primero (obligatorio en móvil)
local gui = Instance.new("ScreenGui")
gui.Name = "AlertGui"
gui.ResetOnSpawn = false
gui.Parent = pg

local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(0.9, 0, 0.08, 0)
lbl.Position = UDim2.new(0.05, 0, 0.05, 0)
lbl.BackgroundTransparency = 1
lbl.Text = ""
lbl.TextColor3 = Color3.new(1, 1, 1)
lbl.TextScaled = true
lbl.Font = Enum.Font.GothamBold
lbl.Parent = gui

local sound = Instance.new("Sound", gui)
sound.SoundId = "rbxassetid://4590657391"
sound.Volume = 0.7

-- 2) Tabla rápida
local spanish = {
	Fire = "🔥 FUEGO – refugio CERRADO",
	Tornado = "🌪 TORNADO – esquina INTERIOR",
	Tsunami = "🌊 TSUNAMI – SUBE alto",
	Earthquake = "🌍 TERREMOTO – NO entres",
	Flood = "💧 INUNDACIÓN – SUBE",
	Lightning = "⚡ TORMENTA – dentro, sin metales",
	Sandstorm = "🌫 ARENA – dentro / muro",
	Meteor = "☄ METEOROS – dentro, techo FUERTE",
	Blizzard = "🌨 VENTISCA – dentro",
	Volcano = "🌋 VOLCÁN – dentro, lejos LAVA",
}

-- 3) Escanea CUALQUIER TextLabel que cambie
local function scan(lab)
	lab.Changed:Connect(function()
		local t = lab.Text
		if t == "" then return end
		for eng, txt in pairs(spanish) do
			if string.lower(t):find(string.lower(eng)) then
				lbl.Text = txt
				sound:Play()
				-- parpadeo rápido
				for i = 1, 6 do
					lbl.TextColor3 = i % 2 == 0 and Color3.new(1, 1, 1) or Color3.new(1, 0.9, 0)
					task.wait(0.12)
				end
				break
			end
		end
	end)
end

-- 4) Conectar lo que YA existe y lo que venga
for _, sc in ipairs(SG:GetDescendants()) do
	if sc:IsA("TextLabel") then scan(sc) end
end
SG.DescendantAdded:Connect(function(d)
	if d:IsA("TextLabel") then scan(d) end
end)

print("NDS alert v3 activado – esperando cartel.")
