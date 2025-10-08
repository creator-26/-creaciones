-- superglide.lua | Mobile Super-Glide
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")
local cam = workspace.CurrentCamera

local gliding = false
local bodyV, bodyG -- referencias BodyVelocity / BodyGyro

-- UI BOTÓN
local btn = Instance.new("TextButton")
btn.Name = "GlideBtn"
btn.Size = UDim2.fromOffset(70,70)
btn.Position = UDim2.new(0.85,0,0.5,0)
btn.BackgroundColor3 = Color3.fromRGB(25, 118, 210)
btn.BackgroundTransparency = 0.3
btn.Text = "GLIDE"
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.Parent = lp:WaitForChild("PlayerGui"):FindFirstChildOfClass("ScreenGui") or Instance.new("ScreenGui", lp.PlayerGui)

-- Toggle
local function toggleGlide()
    gliding = not gliding
    btn.BackgroundColor3 = gliding and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(25, 118, 210)
    if not gliding and bodyV then
        bodyV:Destroy(); bodyV = nil
        bodyG:Destroy(); bodyG = nil
    end
end
btn.MouseButton1Click:Connect(toggleGlide)

-- Lógica de vuelo
RS.Heartbeat:Connect(function()
    if not gliding then return end
    -- Solo activar en caída libre
    if hum:GetState() ~= Enum.HumanoidStateType.Freefall then
        if bodyV then bodyV:Destroy(); bodyV = nil end
        if bodyG then bodyG:Destroy(); bodyG = nil end
        return
    end
    -- Crear cuerpos una sola vez
    if not bodyV then
        bodyV = Instance.new("BodyVelocity", root)
        bodyV.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bodyG = Instance.new("BodyGyro", root)
        bodyG.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    end
    -- Dirección: hacia donde mira la cámara, pero sin componente Y (conservamos altura)
    local look = cam.CFrame.LookVector * Vector3.new(1,0,1)
    local right = cam.CFrame.RightVector
    -- Entrada del joystick virtual
    local move = UIS:GetMovementVector()
    local vel = look * -move.Y * 60 + right * move.X * 60
    -- Caída suave (anti-gravedad parcial)
    bodyV.Velocity = vel + Vector3.yAxis * -workspace.Gravity * 0.22
    -- Orientación plana
    bodyG.CFrame = CFrame.lookAlong(root.Position, look, Vector3.yAxis)
end)

print("Super-Glide cargado. Toca GLIDE en caída libre para planar.")
