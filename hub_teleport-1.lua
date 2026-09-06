--[[
    HUB HORIZONTAL - TELEPORT
    Coordenadas destino: X: -4911, Y: 125, Z: 4939
    Instrucciones: Ejecutar como LocalScript (o pegar en tu ejecutor).
]]

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Elimina un hub anterior si existe (evita duplicados al re-ejecutar)
local oldGui = playerGui:FindFirstChild("HubTeleportGui")
if oldGui then oldGui:Destroy() end

-- ==== ScreenGui ====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HubTeleportGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ==== Frame principal (horizontal) ====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 60)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -30)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(80, 80, 90)
stroke.Thickness = 1.5
stroke.Parent = mainFrame

-- ==== Layout horizontal interno ====
local listLayout = Instance.new("UIListLayout")
listLayout.FillDirection = Enum.FillDirection.Horizontal
listLayout.VerticalAlignment = Enum.VerticalAlignment.Center
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = mainFrame

local padding = Instance.new("UIPadding")
padding.PaddingLeft = UDim.new(0, 12)
padding.PaddingRight = UDim.new(0, 36) -- espacio para el botón X
padding.Parent = mainFrame

-- ==== Botón Teleport Nueva Isla ====
local teleportBtn = Instance.new("TextButton")
teleportBtn.Name = "TeleportButton"
teleportBtn.Size = UDim2.new(0, 200, 0, 40)
teleportBtn.BackgroundColor3 = Color3.fromRGB(55, 120, 235)
teleportBtn.Text = "Teleport Nueva Isla"
teleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportBtn.Font = Enum.Font.GothamBold
teleportBtn.TextScaled = true
teleportBtn.AutoButtonColor = true
teleportBtn.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 8)
teleportCorner.Parent = teleportBtn

-- Padding interno del texto del botón
local btnPadding = Instance.new("UIPadding")
btnPadding.PaddingLeft = UDim.new(0, 8)
btnPadding.PaddingRight = UDim.new(0, 8)
btnPadding.Parent = teleportBtn

-- ==== Botón cerrar (X) en la esquina derecha ====
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -32, 0.5, -13)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.ZIndex = 5
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

-- ==== Botón flotante para reabrir el hub ====
local reopenBtn = Instance.new("TextButton")
reopenBtn.Name = "ReopenButton"
reopenBtn.Size = UDim2.new(0, 50, 0, 50)
reopenBtn.Position = UDim2.new(0.5, -25, 0.5, -25)
reopenBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
reopenBtn.Text = "TP"
reopenBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
reopenBtn.Font = Enum.Font.GothamBold
reopenBtn.TextScaled = true
reopenBtn.Visible = false
reopenBtn.Active = true
reopenBtn.Parent = screenGui

local reopenCorner = Instance.new("UICorner")
reopenCorner.CornerRadius = UDim.new(1, 0)
reopenCorner.Parent = reopenBtn

-- ==== Función arrastrar (drag) genérica con soporte táctil y mouse ====
local function makeDraggable(frame)
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

makeDraggable(mainFrame)
makeDraggable(reopenBtn)

-- ==== Lógica de cerrar / reabrir ====
closeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    reopenBtn.Visible = true
end)

reopenBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    reopenBtn.Visible = false
end)

-- ==== Lógica de teleport ====
local TARGET_POSITION = Vector3.new(-4911, 125, 4939)

teleportBtn.MouseButton1Click:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    hrp.CFrame = CFrame.new(TARGET_POSITION)
end)
