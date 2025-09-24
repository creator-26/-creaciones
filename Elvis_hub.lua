-- GUI principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Position = UDim2.new(0.75,0,0.1,0) -- esquina derecha arriba
Frame.Size = UDim2.new(0,150,0,200)
Frame.BackgroundColor3 = Color3.fromRGB(0,255,127)
Frame.Visible = true

-- Botón de mostrar/ocultar
local ToggleButton = Instance.new("TextButton")
ToggleButton.Parent = ScreenGui
ToggleButton.Size = UDim2.new(0,60,0,30)
ToggleButton.Position = UDim2.new(0.9,0,0,10)
ToggleButton.Text = "Elvis_Hub"
ToggleButton.BackgroundColor3 = Color3.fromRGB(255,0,0)

ToggleButton.MouseButton1Click:Connect(function()
    Frame.Visible = not Frame.Visible
end)

-- Invisible botón
local InvisibleBtn = Instance.new("TextButton")
InvisibleBtn.Parent = Frame
InvisibleBtn.Size = UDim2.new(1,0,0,40)
InvisibleBtn.Position = UDim2.new(0,0,0,0)
InvisibleBtn.Text = "Invisible OFF"
InvisibleBtn.BackgroundColor3 = Color3.fromRGB(135,206,235)

local invisible = false
InvisibleBtn.MouseButton1Click:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char then
        invisible = not invisible
        if invisible then
            for _,part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 1
                end
            end
            InvisibleBtn.Text = "Invisible ON"
        else
            for _,part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Transparency = 0
                end
            end
            InvisibleBtn.Text = "Invisible OFF"
        end
    end
end)

-- Infinite Jump botón
local InfJumpBtn = Instance.new("TextButton")
InfJumpBtn.Parent = Frame
InfJumpBtn.Size = UDim2.new(1,0,0,40)
InfJumpBtn.Position = UDim2.new(0,0,0,40)
InfJumpBtn.Text = "Infinite Jump OFF"
InfJumpBtn.BackgroundColor3 = Color3.fromRGB(255,255,0)

local infjump = false
InfJumpBtn.MouseButton1Click:Connect(function()
    infjump = not infjump
    if infjump then
        InfJumpBtn.Text = "Infinite Jump ON"
    else
        InfJumpBtn.Text = "Infinite Jump OFF"
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if infjump then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- TP caja de texto
local TPBox = Instance.new("TextBox")
TPBox.Parent = Frame
TPBox.Size = UDim2.new(1,0,0,40)
TPBox.Position = UDim2.new(0,0,0,80)
TPBox.PlaceholderText = "Usuario para TP"
TPBox.BackgroundColor3 = Color3.fromRGB(173,216,230)

TPBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local target = game.Players:FindFirstChild(TPBox.Text)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(2,0,0))
        end
    end
end)
