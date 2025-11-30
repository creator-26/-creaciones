-- Mobile Shift Lock genérico
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ==== GUI BOTÓN ====
local gui = Instance.new("ScreenGui")
gui.Name = "MobileShiftLockGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = player:WaitForChild("PlayerGui")

local button = Instance.new("ImageButton")
button.Name = "ShiftLockButton"
button.Size = UDim2.new(0, 35, 0, 35)
button.Position = UDim2.new(1, -50, 1, -50) -- esquina inferior derecha
button.AnchorPoint = Vector2.new(1,1)
button.BackgroundTransparency = 1
button.Image = "rbxasset://textures/ui/mouseLock_off.png" -- icono muy parecido al de Roblox
button.Parent = gui

-- ==== LÓGICA SHIFT LOCK ====
local shiftLocked = false
local cameraOffset = Vector3.new(2, 0, 0) -- como el offset del shift lock original [web:102]

local function updateButtonIcon()
    if shiftLocked then
        button.Image = "rbxasset://textures/ui/mouseLock_on.png"
    else
        button.Image = "rbxasset://textures/ui/mouseLock_off.png"
    end
end

local function setShiftLock(state)
    shiftLocked = state
    updateButtonIcon()
end

button.MouseButton1Click:Connect(function()
    setShiftLock(not shiftLocked)
end)

-- Actualiza cámara y orientación del personaje
RunService.RenderStepped:Connect(function()
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not (char and humanoid and root) then return end

    if shiftLocked then
        -- cámara ligeramente al lado del personaje
        local camCF = CFrame.new(root.Position)
        camCF = CFrame.new(root.Position) * CFrame.Angles(0, camera.CFrame.Y - root.CFrame.Y, 0)
        camera.CFrame = camera.CFrame + camera.CFrame:VectorToWorldSpace(cameraOffset)

        -- hace que el jugador mire donde mira la cámara
        local lookVector = camera.CFrame.LookVector
        local yOnly = Vector3.new(lookVector.X, 0, lookVector.Z)
        if yOnly.Magnitude > 0 then
            root.CFrame = CFrame.new(root.Position, root.Position + yOnly)
        end
    end
end)
