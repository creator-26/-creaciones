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
frame.Size = UDim2.new(0, 150, 0, 250)
frame.Position = UDim2.new(1, -160, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

-- Botón ocultar/mostrar
local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 120, 0, 30)
toggleButton.Position = UDim2.new(0, 15, 0, 10)
toggleButton.Text = "Mostrar/Ocultar"
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
-- Invisible (de verdad)
-------------------------------------------------
local invisibleBtn = Instance.new("TextButton")
invisibleBtn.Size = UDim2.new(0, 120, 0, 30)
invisibleBtn.Position = UDim2.new(0, 15, 0, 40)
invisibleBtn.Text = "Invisible: OFF"
invisibleBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
invisibleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
invisibleBtn.Parent = frame

local invisibleOn = false

local function setInvisible(char, state)
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            part.Transparency = state and 1 or 0
            part.CanCollide = not state
        elseif part:IsA("Decal") then
            part.Transparency = state and 1 or 0
        end
    end
end

invisibleBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char then
        if not invisibleOn then
            setInvisible(char, true)
            invisibleOn = true
            invisibleBtn.Text = "Invisible: ON"
            invisibleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            setInvisible(char, false)
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
-- Teleport con lista de jugadores
-------------------------------------------------
local showListBtn = Instance.new("TextButton")
showListBtn.Size = UDim2.new(0, 120, 0, 30)
showListBtn.Position = UDim2.new(0, 15, 0, 120)
showListBtn.Text = "TextBox"
showListBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
showListBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
showListBtn.Parent = frame

-- Variable para almacenar el jugador seleccionado
local selectedPlayer = nil

-- Marco para la lista de jugadores
local playerListFrame = Instance.new("Frame")
playerListFrame.Size = UDim2.new(0, 150, 0, 200)
playerListFrame.Position = UDim2.new(1, 10, 0, 0)
playerListFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerListFrame.BorderSizePixel = 0
playerListFrame.Visible = false
playerListFrame.Parent = frame

-- ScrollingFrame para la lista deslizable
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -40)
scrollFrame.Position = UDim2.new(0, 5, 0, 5)
scrollFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = playerListFrame

-- Lista para almacenar botones de jugadores
local playerButtons = {}

-- Función para actualizar la lista de jugadores
local function updatePlayerList()
    -- Limpiar botones anteriores
    for _, button in pairs(playerButtons) do
        button:Destroy()
    end
    playerButtons = {}
    
    -- Crear botones para cada jugador
    local yOffset = 0
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local playerBtn = Instance.new("TextButton")
            playerBtn.Size = UDim2.new(1, -10, 0, 30)
            playerBtn.Position = UDim2.new(0, 5, 0, yOffset)
            playerBtn.Text = player.Name
            playerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            playerBtn.Parent = scrollFrame
            
            playerBtn.MouseButton1Click:Connect(function()
                -- Guardar el jugador seleccionado y mostrar su nombre en el botón
                selectedPlayer = player
                showListBtn.Text = player.Name
                -- Ocultar la lista después de seleccionar
                playerListFrame.Visible = false
            end)
            
            table.insert(playerButtons, playerBtn)
            yOffset = yOffset + 35
        end
    end
    
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, yOffset)
end

-- Botón para mostrar/ocultar lista
showListBtn.MouseButton1Click:Connect(function()
    playerListFrame.Visible = not playerListFrame.Visible
    if playerListFrame.Visible then
        updatePlayerList()
    end
end)

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0, 120, 0, 30)
tpBtn.Position = UDim2.new(0, 15, 0, 160)
tpBtn.Text = "Teleport"
tpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tpBtn.Parent = frame

-- Función de teleport
tpBtn.MouseButton1Click:Connect(function()
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = selectedPlayer.Character.HumanoidRootPart.Position
        local offset = Vector3.new(3, 0, 3) -- pasos al costado
        LocalPlayer.Character:MoveTo(targetPos + offset)
    end
end)

-- Botón Refresh Player list
local refreshBtn = Instance.new("TextButton")
refreshBtn.Size = UDim2.new(0, 120, 0, 30)
refreshBtn.Position = UDim2.new(0, 15, 0, 200)
refreshBtn.Text = "Refresh Player list"
refreshBtn.BackgroundColor3 = Color3.fromRGB(120, 0, 255)
refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
refreshBtn.Parent = frame

refreshBtn.MouseButton1Click:Connect(function()
    if playerListFrame.Visible then
        updatePlayerList()
    end
end)
