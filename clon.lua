local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Borrar clon anterior si existe
if workspace:FindFirstChild("ClonDummy") then
    workspace.ClonDummy:Destroy()
end

-- Clonar el Character completo
local dummy = Character:Clone()
dummy.Name = "ClonDummy"

-- Posicionarlo al frente
local hrp = dummy:FindFirstChild("HumanoidRootPart")
if hrp then
    local frente = HumanoidRootPart.CFrame.LookVector * 6
    hrp.CFrame = HumanoidRootPart.CFrame + frente
end

-- Evitar que el clon se mueva
for _, obj in pairs(dummy:GetDescendants()) do
    if obj:IsA("BasePart") then
        obj.Anchored = true
        obj.CanCollide = false
    elseif obj:IsA("LocalScript") or obj:IsA("Script") then
        obj:Destroy()
    end
end

-- Ajustar humanoid para que quede “muerto/quieto”
local hum = dummy:FindFirstChildOfClass("Humanoid")
if hum then
    hum.PlatformStand = true
    hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
end

dummy.Parent = workspace
