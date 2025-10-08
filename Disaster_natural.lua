-- nds_instant_alert.lua | Lo más temprano posible
local SG = game:GetService("StarterGui")
local lp = game:GetService("Players").LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

local gui = Instance.new("ScreenGui")
gui.Name = "NDSAlert"
gui.ResetOnSpawn = false
gui.Parent = pg

local lbl = Instance.new("TextLabel")
lbl.Size = UDim2.new(1, 0, 0.12, 0)
lbl.Position = UDim2.new(0, 0, 0.05, 0)
lbl.BackgroundTransparency = 1
lbl.Text = ""
lbl.TextColor3 = Color3.new(1, 1, 1)
lbl.TextScaled = true
lbl.Font = Enum.Font.GothamBold
lbl.Parent = gui

local sound = Instance.new("Sound", gui)
sound.SoundId = "rbxassetid://4590657391"
sound.Volume = 0.7

local spanish = {
	Fire = "🔥 FUEGO – Busca refugio cerrado",
	Tornado = "🌪 TORNADO – Esquina interior sin ventanas",
	Tsunami = "🌊 TSUNAMI – Sube alto (techo o montaña)",
	Earthquake = "🌍 TERREMOTO – No te metas dentro",
	Flood = "💧 INUNDACIÓN – Sube a plataforma alta",
	Lightning = "⚡ TORMENTA – Dentro, lejos de metales",
	Sandstorm = "🌫 ARENA – Dentro o detrás de pared",
	Meteor = "☄ METEOROS – Dentro, lejos de techos de madera",
	Blizzard = "🌨 VENTISCA – Dentro, abrígate",
	Volcano = "🌋 VOLCÁN – Dentro, lejos de lava",
}

-- Escanea cualquier TextLabel que aparezca
local function scan(label)
	label:GetPropertyChangedSignal("Text"):Connect(function()
		local raw = string.lower(label.Text)
		for eng, txt in pairs(spanish) do
			if string.find(raw, string.lower(eng)) then
				lbl.Text = txt
				sound:Play()
				-- Parpadeo rápido
				for i = 1, 6 do
					lbl.TextColor3 = i % 2 == 0 and Color3.new(1, 1, 1) or Color3.new(1, 0.8, 0)
					task.wait(0.15)
				end
				break
			end
		end
	end)
end

SG.DescendantAdded:Connect(function(d)
	if d:IsA("TextLabel") and d.Text ~= "" then
		scan(d)
	end
end)

print("NDS Instant Alert listo – aviso en cuanto aparezca el cartel.")
