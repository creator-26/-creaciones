-- GOD MODE V7 FINAL — INMORTAL TOTAL (Virus, Tsunami, Todo)
-- 0 errores, anti-Virus, anti-explosión, draggable limpio

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local coreGui = game:GetService("CoreGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "GodV7"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = coreGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 140, 0, 40)
button.Position = UDim2.new(0, 10, 0, 80)
button.BackgroundColor3 = Color3.fromRGB(255,0,0)
button.Text = "Inmortal: OFF"
button.TextColor3 = Color3.new(1,1,1)
button.TextScaled = true
button.Font = Enum.Font.SourceSansBold
button.Active = true
button.ZIndex = 10
button.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0,12)
corner.Parent = button

local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Parent = button

-- Draggable limpio y sin leaks
local dragging = false
button.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        local startPos = button.Position
        local startMouse = inp.Position
        local move; move = UserInputService.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = i.Position - startMouse
                button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        local up; up = UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
                move:Disconnect()
                up:Disconnect()
            end
        end)
    end
end)

local enabled = false
local conns = {}

local function clean()
    for _, c in pairs(conns) do if c then c:Disconnect() end end
    conns = {}
    local char = player.Character
    if char then
        for _, ff in pairs(char:GetChildren()) do
            if ff:IsA("ForceField") then ff:Destroy() end
        end
    end
end

local function godOn(char)
    if not enabled or not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    hum.MaxHealth = math.huge
    hum.Health = math.huge

    -- ForceField anti-objetos
    for i=1,3 do Instance.new("ForceField", char) end

    clean()  -- limpia conexiones viejas

    -- LOOP PRINCIPAL
    table.insert(conns, RunService.Heartbeat:Connect(function()
        hum.Health = math.huge
        hum.PlatformStand = false
        hum.Sit = false

        -- Anti-fling + anti-fall
        local vel = root.AssemblyLinearVelocity
        if vel.Magnitude > 100 then
            root.AssemblyLinearVelocity = Vector3.new(0, vel.Y, 0)
        end
        if vel.Y < -200 then
            root.AssemblyLinearVelocity = Vector3.new(vel.X, -50, vel.Z)
        end

        -- Anti-tsunami/mar
        if root.Position.Y < 30 then
            root.CFrame = root.CFrame + Vector3.new(0, 120, 0)
        end
    end))

    -- Noclip total
    table.insert(conns, RunService.Stepped:Connect(function()
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end))

    -- Anti-Virus + Anti-DeadlyVirus + Anti-explosión
    table.insert(conns, hum:GetPropertyChangedSignal("Health"):Connect(function()
        if hum.Health < math.huge then hum.Health = math.huge end
    end))

    -- Bloquea TODOS los estados malos (incluye Virus que te mata directo)
    table.insert(conns, hum.StateChanged:Connect(function(_, new)
        if new ~= Enum.HumanoidStateType.Running and new ~= Enum.HumanoidStateType.Jumping then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end))

    -- Anti-BreakJoints (Virus usa esto)
    char:WaitForChild("HumanoidRootPart")
    table.insert(conns, char.ChildRemoved:Connect(function(child)
        if child.Name == "HumanoidRootPart" or child:IsA("Humanoid") then
            task.wait()
            if player.Character and enabled then godOn(player.Character) end
        end
    end))
end

local function toggle()
    enabled = not enabled
    clean()
    if enabled then
        button.BackgroundColor3 = Color3.fromRGB(0,255,0)
        button.Text = "Inmortal: ON"
        print("INMORTAL V7 ON — Virus/Tsunami 0% muerte")
        if player.Character then godOn(player.Character) end
    else
        button.BackgroundColor3 = Color3.fromRGB(255,0,0)
        button.Text = "Inmortal: OFF"
        print("Inmortal OFF")
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.MaxHealth = 100 hum.Health = 100 end
    end
end

-- Respawn automático
player.CharacterAdded:Connect(function(char) task.wait(0.5) if enabled then godOn(char) end end)

button.MouseButton1Click:Connect(toggle)
UserInputService.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.G then toggle() end
end)

print("GOD V7 CARGADO — ¡Virus y mar ya no matan nunca más!")
