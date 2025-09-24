local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Eliminar clon anterior si existe
if workspace:FindFirstChild("ClonDummy") then
    workspace.ClonDummy:Destroy()
end

-- Crear nuevo clon vacío
local dummy = Instance.new("Model")
dummy.Name = "ClonDummy"

-- Crear un humanoid
local humanoid = Instance.new("Humanoid")
humanoid.Parent = dummy

-- Crear HRP
local hrp = Instance.new("Part")
hrp.Name = "HumanoidRootPart"
hrp.Size = Vector3.new(2,2,1)
hrp.Anchored = false
hrp.CanCollide = false
hrp.Position = HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * 6
hrp.Parent = dummy
dummy.PrimaryPart = hrp

-- Clonar la apariencia del jugador
local description = Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
humanoid:ApplyDescription(description)

dummy.Parent = workspace

-- Anclar todo para que no se caiga
for _, part in ipairs(dummy:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Anchored = true
    end
end
