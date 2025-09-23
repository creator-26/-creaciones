-- 🤖 Clon igual a ti, ON/OFF con botón
-- LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local clone = nil
local auraEnabled = false

-- 🟢 Botón
local gui = Instance.new("ScreenGui")
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 80, 0, 30)
button.Position = UDim2.new(0, 100, 0, 100)
button.Text = "Clon: OFF"
button.BackgroundColor3 = Color3.fromRGB(200,0,0)
button.Parent = gui

-- 📌 Función para crear el clon
local function createClone()
	if clone then clone:Destroy() clone = nil end
	if not LocalPlayer.Character then return end

	-- copiamos la descripción directamente de tu humanoid
	local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	if not humanoid then return end
	local desc = humanoid:GetAppliedDescription()

	local char = Instance.new("Model")
	char.Name = LocalPlayer.Name .. "_Clon"

	-- humanoid + HRP
	local hum = Instance.new("Humanoid")
	hum.Parent = char

	local hrp = Instance.new("Part")
	hrp.Name = "HumanoidRootPart"
	hrp.Size = Vector3.new(2,2,1)
	hrp.Anchored = false
	hrp.CanCollide = false
	hrp.Transparency = 1
	hrp.Parent = char

	char.PrimaryPart = hrp
	char.Parent = workspace

	-- aplicamos la descripción copiada de tu personaje
	hum:ApplyDescription(desc)

	clone = char
end

-- 📌 Hacer que el clon te siga
RunService.Heartbeat:Connect(function()
	if clone and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		local myRoot = LocalPlayer.Character.HumanoidRootPart
		local cRoot = clone:FindFirstChild("HumanoidRootPart")
		if cRoot then
			local pos = myRoot.Position + myRoot.CFrame.LookVector * -5 -- detrás tuyo
			cRoot.CFrame = CFrame.new(pos, myRoot.Position)
		end
	end
end)

-- 📌 ON / OFF
button.MouseButton1Click:Connect(function()
	auraEnabled = not auraEnabled
	if auraEnabled then
		button.Text = "Clon: ON"
		button.BackgroundColor3 = Color3.fromRGB(0,200,0)
		createClone()
	else
		button.Text = "Clon: OFF"
		button.BackgroundColor3 = Color3.fromRGB(200,0,0)
		if clone then clone:Destroy() clone = nil end
	end
end)
