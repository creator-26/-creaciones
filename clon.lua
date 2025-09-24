local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- BORRA cualquier clon anterior
if workspace:FindFirstChild("ClonDummy") then
    workspace.ClonDummy:Destroy()
end

-- Crear clon simple
local dummy = Character:Clone()
dummy.Name = "ClonDummy"
dummy.Parent = workspace

-- Forzar que tenga PrimaryPart
local hrp = dummy:FindFirstChild("HumanoidRootPart")
if hrp then
    dummy.PrimaryPart = hrp
    -- Posición al frente tuyo
    local frente = HumanoidRootPart.CFrame.LookVector * 6
    hrp.CFrame = HumanoidRootPart.CFrame + frente
end

-- Evitar que se caiga
for _, part in ipairs(dummy:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Anchored = true
    end
end
