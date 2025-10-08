-- superglide_v3.lua | Mobile wing-suit (botón 100% visible)
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local lp = Players.LocalPlayer

-- Esperar a que el PlayerGui exista
local pg = lp:WaitForChild("PlayerGui")
local gui = Instance.new("ScreenGui")
gui.Name = "GlideGui"
gui.ResetOnSpawn = false
gui.Parent = pg

-- Botón
local btn = Instance.new("TextButton")
btn.Name = "GlideBtn"
btn.Size = UDim2.fromOffset(70,70)
btn.Position = UDim2.new(0.75,0,0.5,0)
btn.BackgroundColor3 = Color3.fromRGB(25, 118, 210)
btn.BackgroundTransparency = 0.3
btn.Text = "GLIDE"
btn.TextColor3 = Color3.new(1,1,1)
btn.TextScaled = true
btn.Parent = gui

-- Lógica del personaje
local char, root, hum
local function setupChar()
    char = lp.Character or lp.CharacterAdded:Wait()
    root = char:WaitForChild("HumanoidRootPart")
    hum = char:WaitForChild("Humanoid")
end
setupChar()
lp.CharacterAdded:Connect(setupChar)

-- Glide
local gliding = false
local bodyV, bodyG
local cam = workspace.CurrentCamera

local function toggleGlide()
    gliding = not gliding
    btn.BackgroundColor3 = gliding and Color3.fromRGB(76, 175, 80) or Color3.fromRGB(25, 118, 210)
    if not gliding and bodyV then
        bodyV:Destroy(); bodyV = nil
        bodyG:Destroy(); bodyG = nil
    end
end
btn.MouseButton1Click:Connect(toggleGlide)

RS.Heartbeat:Connect(function()
    if not gliding or not root then return end
    if hum:GetState() ~= Enum.HumanoidStateType.Freefall then
        if bodyV then bodyV:Destroy(); bodyV = nil end
        if bodyG then bodyG:Destroy(); bodyG = nil end
        return
    end
    if not bodyV then
        bodyV = Instance.new("BodyVelocity", root)
        bodyV.MaxForce = Vector3.new(1e6, 0, 1e6)
        bodyG = Instance.new("BodyGyro", root)
        bodyG.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
    end
    local look = cam.CFrame.LookVector * Vector3.new(1,0,1)
    local right = cam.CFrame.RightVector
    local move = UIS:GetMovementVector()
    local hor = look * -move.Y * 55 + right * move.X * 55
    bodyV.Velocity = hor + Vector3.yAxis * root.Velocity.Y
    bodyG.CFrame = CFrame.lookAlong(root.Position, look, Vector3.yAxis)
end)

print("Super-Glide v3 cargado. Botón en pantalla.")
