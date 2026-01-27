local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Character
local HumanoidRootPart

local clon = nil
local clonActivo = false

-- ========= MANEJO DE RESPAWN (MEJORA) =========
local function setupCharacter(char)
	Character = char
	HumanoidRootPart = char:WaitForChild("HumanoidRootPart")
end

setupCharacter(LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait())

-- ⚠️ IMPORTANTE: NO destruimos el clon al morir
LocalPlayer.CharacterAdded:Connect(function(char)
	setupCharacter(char)
end)

-- ========= GUI (MISMO DISEÑO) =========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(0, 120, 0, 40)
spawnButton.Position = UDim2.new(0, 10, 0, 200)
spawnButton.Text = "Clon OFF"
spawnButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
spawnButton.Parent = ScreenGui

local swapButton = Instance.new("TextButton")
swapButton.Size = UDim2.new(0, 120, 0, 40)
swapButton.Position = UDim2.new(0, 10, 0, 250)
swapButton.Text = "Intercambiar"
swapButton.BackgroundColor3 = Color3.fromRGB(200, 200, 100)
swapButton.Parent = ScreenGui

-- ========= DUMMY ORIGINAL (MISMO, PERO ESTABLE) =========
local function crearDummyRespaldo()
	local dummy = Instance.new("Model")
	dummy.Name = "ClonRespaldo"

	local humanoid = Instance.new("Humanoid")
	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.Parent = dummy

	local root = Instance.new("Part")
	root.Name = "HumanoidRootPart"
	root.Size = Vector3.new(2, 2, 1)
	root.Position = HumanoidRootPart.Position + (HumanoidRootPart.CFrame.LookVector * 6)
	root.Anchored = true -- 🔥 CLAVE: ya no se mueve
	root.BrickColor = BrickColor.new("Bright green")
	root.Parent = dummy

	dummy.PrimaryPart = root
	dummy.Parent = workspace

	return dummy
end

-- ========= NPC REAL (IGUAL AL TUYO) =========
local function crearNPCRreal()
	local success, npcModel = pcall(function()
		return game:GetObjects("rbxassetid://4446576906")[1]
	end)

	if success and npcModel then
		npcModel.Name = "MiClonNPC"

		local frente = HumanoidRootPart.CFrame.LookVector * 6
		local posicion = HumanoidRootPart.Position + frente

		if npcModel:FindFirstChild("HumanoidRootPart") then
			npcModel.HumanoidRootPart.Anchored = true -- estabilidad
			npcModel.HumanoidRootPart.CFrame = CFrame.new(posicion)
		else
			npcModel:PivotTo(CFrame.new(posicion))
		end

		local humanoid = npcModel:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = 0
			humanoid.JumpPower = 0
		end

		npcModel.Parent = workspace
		return npcModel
	else
		return crearDummyRespaldo()
	end
end

-- ========= BOTÓN ON / OFF =========
spawnButton.MouseButton1Click:Connect(function()
	if clonActivo then
		if clon and clon.Parent then
			clon:Destroy()
		end
		clon = nil
		clonActivo = false
		spawnButton.Text = "Clon OFF"
		spawnButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
	else
		clon = crearNPCRreal()
		clonActivo = true
		spawnButton.Text = "Clon ON"
		spawnButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
	end
end)

-- ========= INTERCAMBIAR POSICIONES =========
swapButton.MouseButton1Click:Connect(function()
	if not clon or not HumanoidRootPart then return end

	local clonRoot = clon:FindFirstChild("HumanoidRootPart") or clon.PrimaryPart
	if not clonRoot then return end

	local temp = HumanoidRootPart.CFrame
	HumanoidRootPart.CFrame = clonRoot.CFrame
	clonRoot.CFrame = temp
end)

print("✅ Dummy estable y persistente aplicado")
