-- nds_mobile_hub.lua | Hub completo Natural Disaster Survival
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local SG = game:GetService("StarterGui")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")

---------- UTILIDADES ----------
local function crearSound(id)
	local s = Instance.new("Sound", pg)
	s.SoundId = "rbxassetid://" .. id
	s.Volume = 0.6
	return s
end

local function crearBody(parent, class)
	local b = Instance.new(class, parent)
	b.MaxForce = Vector3.new(1e6, 1e6, 1e6)
	return b
end

---------- GUI ----------
local gui = Instance.new("ScreenGui")
gui.Name = "NDSHub"
gui.ResetOnSpawn = false
gui.Parent = pg

-- Marco principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 340)
frame.Position = UDim2.new(0.5, -110, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui

-- Título
local titulo = Instance.new("TextLabel")
titulo.Size = UDim2.new(1, 0, 0, 30)
titulo.Position = UDim2.fromScale(0, 0)
titulo.BackgroundTransparency = 1
titulo.Text = "NDS  Hub"
titulo.TextColor3 = Color3.new(1, 1, 1)
titulo.TextScaled = true
titulo.Font = Enum.Font.GothamBold
titulo.Parent = frame

-- Botón ocultar
local hideBtn = Instance.new("TextButton")
hideBtn.Size = UDim2.new(0, 25, 0, 25)
hideBtn.Position = UDim2.new(1, -27, 0, 2)
hideBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
hideBtn.Text = "–"
hideBtn.TextColor3 = Color3.new(1, 1, 1)
hideBtn.TextScaled = true
hideBtn.Font = Enum.Font.SourceSansBold
hideBtn.Parent = frame

-- Panel de switches
local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -10, 1, -65)
list.Position = UDim2.new(0, 5, 0, 35)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 3
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Parent = frame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 5)
uiList.Parent = list

---------- FUNCIONES ----------
local estados = {} -- guarda estados

-- 1) Alerta instantánea
local function alertaIns(t)
	if t then
		estados.alertaCon = SG.DescendantAdded:Connect(function(d)
			if d:IsA("TextLabel") and d.Text ~= "" then
				local raw = string.lower(d.Text)
				for eng, txt in pairs({
					Fire = "🔥 FUEGO – refugio CERRADO",
					Tornado = "🌪 TORNADO – esquina INTERIOR",
					Tsunami = "🌊 TSUNAMI – SUBE alto",
					Earthquake = "🌍 TERREMOTO – NO entres",
					Flood = "💧 INUNDACIÓN – SUBE",
					Lightning = "⚡ TORMENTA – dentro, sin metales",
					Sandstorm = "🌫 ARENA – dentro / muro",
					Meteor = "☄ METEOROS – dentro, techo FUERTE",
					Blizzard = "🌨 VENTISCA – dentro",
					Volcano = "🌋 VOLCÁN – dentro, lejos LAVA"
				}) do
					if raw:find(string.lower(eng)) then
						crearSound(4590657391):Play()
						local aviso = Instance.new("TextLabel")
						aviso.Size = UDim2.new(0.9, 0, 0.08, 0)
						aviso.Position = UDim2.new(0.05, 0, 0.05, 0)
						aviso.BackgroundTransparency = 0.3
						aviso.BackgroundColor3 = Color3.new(0, 0, 0)
						aviso.Text = txt
						aviso.TextColor3 = Color3.new(1, 1, 1)
						aviso.TextScaled = true
						aviso.Font = Enum.Font.GothamBold
						aviso.Parent = gui
						game:GetService("Debris"):AddItem(aviso, 5)
						break
					end
				end
			end
		end)
	else
		if estados.alertaCon then estados.alertaCon:Disconnect() end
	end
end

-- 2) No-Fall Parachute
local function noFall(t)
	estados.noFall = t
	if t then
		estados.noFallCon = lp.CharacterAdded:Connect(function(char)
			local root = char:WaitForChild("HumanoidRootPart")
			local hum = char:WaitForChild("Humanoid")
			local con; con = game:GetService("RunService").Heartbeat:Connect(function()
				if not estados.noFall then con:Disconnect() return end
				if hum:GetState() == Enum.HumanoidStateType.Freefall and root.Velocity.Y < -50 then
					local bv = Instance.new("BodyVelocity", root)
					bv.MaxForce = Vector3.new(0, 1e6, 0)
					bv.Velocity = Vector3.yAxis * -20
					game:GetService("Debris"):AddItem(bv, 0.5)
				end
			end)
		end)
	else
		if estados.noFallCon then estados.noFallCon:Disconnect() end
	end
end

-- 3) Speed Slider
local function speedCtrl(t)
	estados.speed = t and 30 or 16
	local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
	if hum then hum.WalkSpeed = estados.speed end
	if t then
		estados.speedCon = lp.CharacterAdded:Connect(function(char)
			char:WaitForChild("Humanoid").WalkSpeed = estados.speed
		end)
	else
		if estados.speedCon then estados.speedCon:Disconnect() end
		local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 16 end
	end
end

-- 4) ESP Players
local function espPlayers(t)
	if t then
		estados.espCon = lp.CharacterAdded:Connect(function(char)
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= lp and p.Character then
					local head = p.Character:FindFirstChild("Head")
					if head then
						local bill = Instance.new("BillboardGui", head)
						bill.Size = UDim2.new(0, 200, 0, 50)
						bill.StudsOffset = Vector3.yAxis * 3
						local txt = Instance.new("TextLabel", bill)
						txt.Size = UDim2.fromScale(1, 1)
						txt.BackgroundTransparency = 1
						txt.Text = p.Name
						txt.TextColor3 = Color3.new(1, 1, 1)
						txt.TextScaled = true
					end
				end
			end
		end)
	else
		if estados.espCon then estados.espCon:Disconnect() end
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				for _, b in ipairs(p.Character:GetDescendants()) do
					if b:IsA("BillboardGui") then b:Destroy() end
				end
			end
		end
	end
end

-- 5) Tornado Anti-Pull
local function antiTornado(t)
	estados.antiTor = t
	if t then
		estados.torCon = lp.CharacterAdded:Connect(function(char)
			local root = char:WaitForChild("HumanoidRootPart")
			local bv = crearBody(root, "BodyVelocity")
			local con; con = RS.Heartbeat:Connect(function()
				if not estados.antiTor then con:Disconnect() bv:Destroy() return end
				bv.Velocity = Vector3.zero
			end)
		end)
	else
		if estados.torCon then estados.torCon:Disconnect() end
		local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
		if root then for _, b in ipairs(root:GetChildren()) do if b:IsA("BodyVelocity") then b:Destroy() end end end
	end
end

-- 6) Auto-Shelter TP (teleport a edificio seguro)
local refugios = { -- aprox
	Fire = CFrame.new(0, 5, 0),       -- ejemplo centro
	Tornado = CFrame.new(50, 5, 50),
	Tsunami = CFrame.new(0, 30, 0),
	Earthquake = CFrame.new(-50, 5, -50),
	Flood = CFrame.new(0, 20, 0),
	Lightning = CFrame.new(0, 5, 0),
	Sandstorm = CFrame.new(0, 5, 0),
	Meteor = CFrame.new(0, 5, 0),
	Blizzard = CFrame.new(0, 5, 0),
	Volcano = CFrame.new(0, 5, 0),
}
local function autoShelter()
	-- lee desastre actual
	for _, d in ipairs(SG:GetDescendants()) do
		if d:IsA("TextLabel") and d.Text ~= "" then
			local raw = string.lower(d.Text)
			for eng, cf in pairs(refugios) do
				if raw:find(string.lower(eng)) then
					local root = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
					if root then root.CFrame = cf end
					crearSound(138186576):Play()
					break
				end
			end
		end
	end
end

---------- CONSTRUIR SWITCHES ----------
local function crearSwitch(nombre, y, fn)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -10, 0, 40)
	btn.Position = UDim2.new(0, 5, 0, y)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.Text = "  " .. nombre .. "  (OFF)"
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.TextScaled = true
	btn.Font = Enum.Font.Gotham
	btn.Parent = list

	local on = false
	btn.MouseButton1Click:Connect(function()
		on = not on
		btn.BackgroundColor3 = on and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(60, 60, 60)
		btn.Text = "  " .. nombre .. "  (" .. (on and "ON" or "OFF") .. ")"
		fn(on)
	end)
end

crearSwitch("Alerta Desastre", 0, alertaIns)
crearSwitch("No-Fall Parachute", 45, noFall)
crearSwitch("Speed x1.8", 90, speedCtrl)
crearSwitch("ESP Jugadores", 135, espPlayers)
crearSwitch("Anti-Tornado", 180, antiTornado)

-- Botón rápido TP refugio
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(1, -10, 0, 40)
tpBtn.Position = UDim2.new(0, 5, 225, 0)
tpBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
tpBtn.Text = "TP REFUGIO"
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.TextScaled = true
tpBtn.Font = Enum.Font.GothamBold
tpBtn.Parent = list
tpBtn.MouseButton1Click:Connect(autoShelter)

---------- OCULTAR / MOSTRAR ----------
local oculto = false
hideBtn.MouseButton1Click:Connect(function()
	oculto = not oculto
	frame.Visible = not oculto
	hideBtn.Text = oculto and "+" or "–"
end)

print("NDS Mobile Hub cargado – arrastra y activa lo que necesites.")
