local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Borrar clon anterior si existiera
if workspace:FindFirstChild("ClonDummy") then
    workspace.ClonDummy:Destroy()
end

-- Crear un rig R15 vacío
local dummy = Instance.new("Model")
dummy.Name = "ClonDummy"

local humanoid = Instance.new("Humanoid")
humanoid.RigType = Enum.HumanoidRigType.R15
humanoid.Parent = dummy

local hrp = Instance.new("Part")
hrp.Name = "HumanoidRootPart"
hrp.Size = Vector3.new(2,2,1)
hrp.Anchored = false
hrp.CanCollide = false
hrp.Position = HumanoidRootPart.Position + HumanoidRootPart.CFrame.LookVector * 6
hrp.Parent = dummy
dummy.PrimaryPart = hrp

-- Obtener tu apariencia
local success, description = pcall(function()
    return Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
end)

if success and description then
    humanoid:ApplyDescription(description)
end

dummy.Parent = workspace

-- Anclar todas las partes del clon
for _, part in ipairs(dummy:GetDescendants()) do
    if part:IsA("BasePart") then
        part.Anchored = true
    end
end
