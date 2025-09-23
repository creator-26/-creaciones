-- 🤖 Clon con tu misma ropa/cuerpo
-- 📌 LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🟩 Botón
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local boton = Instance.new("TextButton", gui)
boton.Size = UDim2.new(0, 100, 0, 40)
boton.Position = UDim2.new(0, 20, 0, 200)
boton.Text = "Clon OFF"
boton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
boton.TextColor3 = Color3.new(1,1,1)
boton.TextScaled = true
boton.Draggable = true

local clonActivo = false
local clonObj = nil

local function crearClon()
    if clonObj then clonObj:Destroy() end

    local desc = Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
    local clon = Instance.new("Model")
    clon.Name = "MiClon"
    clon.Parent = workspace

    -- crear humanoid + rig R15
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = clon
    humanoid.Name = "Humanoid"

    local rootPart = Instance.new("Part")
    rootPart.Name = "HumanoidRootPart"
    rootPart.Size = Vector3.new(2,2,1)
    rootPart.Anchored = false
    rootPart.CanCollide = true
    rootPart.Position = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and 
        LocalPlayer.Character.HumanoidRootPart.Position + Vector3.new(3,0,0) or Vector3.new(0,5,0)
    rootPart.Parent = clon

    humanoid:ApplyDescription(desc)

    clonObj = clon
end

boton.MouseButton1Click:Connect(function()
    clonActivo = not clonActivo
    if clonActivo then
        boton.Text = "Clon ON"
        boton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        crearClon()
    else
        boton.Text = "Clon OFF"
        boton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if clonObj then clonObj:Destroy() end
    end
end)
