-- 🟢 Elvis_hub
-- 📌 LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Marco principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 220)
frame.Position = UDim2.new(1, -160, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Botón ocultar/mostrar
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 30)
toggleButton.Position = UDim2.new(0, 15, 0, -35)
toggleButton.Text = "Mostrar/Ocultar Hub"
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Parent = screenGui

-- Estado visible
local hubVisible = true
toggleButton.MouseButton1Click:Connect(function()
    hubVisible = not hubVisible
    frame.Visible = hubVisible
end)

-- Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Elvis_hub"
title.TextColor3 = Color3.fromRGB(0, 255, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.Parent = frame

-------------------------------------------------
-- Invisible (flotar arriba)
-------------------------------------------------
local invisibleBtn = Instance.new("TextButton")
invisibleBtn.Size = UDim2.new(0, 120, 0, 30)
invisibleBtn.Position = UDim2.new(0, 15, 0, 40)
invisibleBtn.Text = "Invisible: OFF"
invisibleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
invisibleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
invisibleBtn.Parent = frame

local invisibleOn = false
invisibleBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        if not invisibleOn then
            char:MoveTo(Vector3.new(0,1000,0)) -- flotar arriba
            invisibleOn = true
            invisibleBtn.Text = "Invisible: ON"
            invisibleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            char:MoveTo(Vector3.new(0,10,0)) -- volver abajo
            invisibleOn = false
            invisibleBtn.Text = "Invisible: OFF"
            invisibleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        end
    end
end)

-------------------------------------------------
-- Infinite Jump
-------------------------------------------------
local jumpBtn = Instance.new("TextButton")
jumpBtn.Size = UDim2.new(0, 120, 0, 30)
jumpBtn.Position = UDim2.new(0, 15, 0, 80)
jumpBtn.Text = "Infinite Jump: OFF"
jumpBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
jumpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBtn.Parent = frame

local infiniteJump = false
jumpBtn.MouseButton1Click:Connect(function()
    infiniteJump = not infiniteJump
    if infiniteJump then
        jumpBtn.Text = "Infinite Jump: ON"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    else
        jumpBtn.Text = "Infinite Jump: OFF"
        jumpBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

-------------------------------------------------
-- Teleport con cuadro de texto
-------------------------------------------------
local tpBox = Instance.new("TextBox")
tpBox.Size = UDim2.new(0, 120, 0, 30)
tpBox.Position = UDim2.new(0, 15, 0, 120)
tpBox.PlaceholderText = "Usuario..."
tpBox.TextColor3 = Color3.fromRGB(0, 0, 0)
tpBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
tpBox.Parent = frame

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0, 120, 0, 30)
tpBtn.Position = UDim2.new(0, 15, 0, 160)
tpBtn.Text = "Teleport"
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Parent = frame

tpBtn.MouseButton1Click:Connect(function()
    local targetName = tpBox.Text
    if targetName ~= "" then
        local targetPlayer = Players:FindFirstChild(targetName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local targetPos = targetPlayer.Character.HumanoidRootPart.Position
            local offset = Vector3.new(3, 0, 3) -- pasos al costado
            LocalPlayer.Character:MoveTo(targetPos + offset)
        end
    end
end)
