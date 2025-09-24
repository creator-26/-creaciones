-- 📌 Elvis Hub (básico)
-- LocalScript

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")

-- 🖼️ GUI principal
local screenGui = Instance.new("ScreenGui", game.CoreGui)
screenGui.Name = "ElvisHub"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 180, 0, 160)
mainFrame.Position = UDim2.new(0, 20, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 120)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- 🔽 Botón ocultar/mostrar
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 20, 0, 20)
toggleButton.Position = UDim2.new(1, -25, 0, 5)
toggleButton.Text = "▼"
toggleButton.TextScaled = true
toggleButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
toggleButton.Parent = mainFrame

-- 📛 Título
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -30, 0, 30)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "Elvis_hub"
title.TextScaled = true
title.TextColor3 = Color3.new(0,0,0)
title.BackgroundTransparency = 1
title.Parent = mainFrame

-- Función crear botón
local function makeButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Position = UDim2.new(0, 5, 0, posY)
    btn.Text = text
    btn.TextScaled = true
    btn.TextColor3 = Color3.new(0,0,0)
    btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    btn.BorderSizePixel = 2
    btn.BorderColor3 = Color3.fromRGB(0,255,120)
    btn.Parent = mainFrame
    return btn
end

-- 🔘 Botones
local invisibleBtn = makeButton("Invisible On/Off", 35)
local jumpBtn = makeButton("Infinite Jump On/Off", 70)
local tpBox = Instance.new("TextBox")
tpBox.Size = UDim2.new(1, -10, 0, 30)
tpBox.Position = UDim2.new(0, 5, 0, 105)
tpBox.PlaceholderText = "TP: Escribir Usuario"
tpBox.TextScaled = true
tpBox.TextColor3 = Color3.new(0,0,0)
tpBox.BackgroundColor3 = Color3.fromRGB(255,255,255)
tpBox.BorderSizePixel = 2
tpBox.BorderColor3 = Color3.fromRGB(0,255,120)
tpBox.Parent = mainFrame

-- =============================
-- ⚡ FUNCIONES
-- =============================

-- Invisible
local invisible = false
invisibleBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char then
        invisible = not invisible
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.Transparency = invisible and 1 or 0
            end
        end
    end
end)

-- Infinite Jump
local infJump = false
jumpBtn.MouseButton1Click:Connect(function()
    infJump = not infJump
end)

UserInputService.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character:FindFirstChild("Humanoid"):ChangeState("Jumping")
    end
end)

-- Teleport
tpBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local targetName = tpBox.Text
        local target = Players:FindFirstChild(targetName)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
            end
        end
    end
end)

-- Mostrar/ocultar
local hidden = false
toggleButton.MouseButton1Click:Connect(function()
    hidden = not hidden
    for _, child in ipairs(mainFrame:GetChildren()) do
        if child ~= toggleButton and child ~= title then
            child.Visible = not hidden
        end
    end
    toggleButton.Text = hidden and "▲" or "▼"
end)