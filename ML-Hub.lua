-- ML-Hub personalizado VisualHub
local VisualHub = loadstring(game:HttpGet("https://raw.githubusercontent.com/creator-26/-creaciones/refs/heads/main/VisualHub.lua"))()
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace = game:GetService('Workspace')

local gui = VisualHub:Create("ML-Hub")
local y = 50

-- Lock Position
VisualHub:AddSwitch(gui, "Lock Position", function(state)
    getgenv().lockPosition = state
    if state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        getgenv().lockedPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        if getgenv().lockConn then getgenv().lockConn:Disconnect() end
        getgenv().lockConn = game:GetService("RunService").Heartbeat:Connect(function()
            if LocalPlayer.Character and getgenv().lockPosition and getgenv().lockedPos then
                LocalPlayer.Character.HumanoidRootPart.CFrame = getgenv().lockedPos
            end
        end)
    elseif getgenv().lockConn then
        getgenv().lockConn:Disconnect()
        getgenv().lockConn = nil
    end
end, y)
y = y + 27

-- Anti AFK
local btn = VisualHub:AddButton(gui, "Anti AFK", function()
    if getgenv().afkConn then getgenv().afkConn:Disconnect() end
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local vu = game:GetService("VirtualUser")
    local vim = game:GetService("VirtualInputManager")
    getgenv().afkConn = LocalPlayer.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
        if vim and vim.SendKeyEvent then
            vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        end
    end)
end, y)
btn.Size = UDim2.new(0, 150, 0, 30)
btn.Position = UDim2.new(0, 15, 0, y)

-- Cuadro informativo a la derecha
local infoFrame = Instance.new("Frame", btn.Parent)
infoFrame.Size = UDim2.new(0, 67, 0, 34)
infoFrame.Position = UDim2.new(0, 180, 0, y) -- ajusta 180 según posición de btn
infoFrame.BackgroundColor3 = Color3.fromRGB(32,32,44)
infoFrame.BorderSizePixel = 1

local timeLabel = Instance.new("TextLabel", infoFrame)
timeLabel.Size = UDim2.new(1,0,0,16)
timeLabel.Position = UDim2.new(0,0,0,1)
timeLabel.Text = "00:00:00"
timeLabel.TextSize = 11
timeLabel.TextColor3 = Color3.fromRGB(190,250,190)
timeLabel.BackgroundTransparency = 1
timeLabel.Font = Enum.Font.Gotham

local pingLabel = Instance.new("TextLabel", infoFrame)
pingLabel.Size = UDim2.new(1,0,0,15)
pingLabel.Position = UDim2.new(0,0,0,18)
pingLabel.Text = "0 ms"
pingLabel.TextSize = 11
pingLabel.TextColor3 = Color3.fromRGB(160,210,255)
pingLabel.BackgroundTransparency = 1
pingLabel.Font = Enum.Font.Gotham

-- Cada segundo: actualiza hora y ping
local startTime = tick()
spawn(function()
    while infoFrame.Parent do
        local t = tick() - startTime
        local hours = math.floor(t/3600)
        local mins = math.floor((t%3600)/60)
        local secs = math.floor(t%60)
        timeLabel.Text = string.format("%02d:%02d:%02d", hours, mins, secs)
        -- Roblox ping real: LocalPlayer:GetNetworkPing() solo en algunos exploits,
        -- si no está disponible, simula uno random bajo.
        local networkPing = math.floor((game.Stats and game.Stats.Network and game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) or (math.random(60,110)))
        pingLabel.Text = tostring(networkPing).." ms"
        wait(1)
    end
end)
y = y + 27

-- Antilag
local btn = VisualHub:AddButton(gui, "Antilag ", function()
    -- Cambia todos los materiales a SmoothPlastic y reflectancia a 0
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        end
        if v:IsA("Decal") or v:IsA("Texture") then
            v.Transparency = 1
        end
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
            v.Enabled = false
        end
        if v:IsA("Explosion") then
            v:Destroy()
        end
    end
    -- Desactiva efectos ambientales para aún más rendimiento
    local Lighting = game:GetService("Lighting")
    Lighting.Brightness = 1
    Lighting.FogEnd = 100000
    Lighting.GlobalShadows = false
    Lighting.ExposureCompensation = 0
end, y)
btn.Size = UDim2.new(0, 150, 0, 30)  -- ancho 150, alto 35 (ajusta como prefieras)
btn.Position = UDim2.new(0, 15, 0, y) 
y = y + 27

-- Auto Egg cada 30 minutos
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

VisualHub:AddSwitch(gui, "Auto Eat Protein Egg Every 30 Minutes", function(state)
    getgenv().autoEatProteinEggActive = state
    task.spawn(function()
        while getgenv().autoEatProteinEggActive and LocalPlayer.Character do
            local egg = LocalPlayer.Backpack:FindFirstChild("Protein Egg") 
                or LocalPlayer.Character:FindFirstChild("Protein Egg")
            if egg then
                -- Equipa
                egg.Parent = LocalPlayer.Character
                -- Y dispara el evento que come el huevo
                ReplicatedStorage.muscleEvent:FireServer("rep")
            end
            task.wait(1800)
        end
    end)
end, y)
y = y + 27
-- Anti Knockback
VisualHub:AddSwitch(gui, "Anti Knockback", function(state)
    local player = game.Players.LocalPlayer
    local character = player and game.Workspace:FindFirstChild(player.Name)
    if state then
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            if not rootPart:FindFirstChild("BodyVelocity") then
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(100000, 0, 100000)
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                bodyVelocity.P = 1250
                bodyVelocity.Name = "AntiKnockbackBV"
                bodyVelocity.Parent = rootPart
            end
        end
    else
        if character and character:FindFirstChild("HumanoidRootPart") then
            local rootPart = character.HumanoidRootPart
            local bv = rootPart:FindFirstChild("AntiKnockbackBV")
            if bv then
                bv:Destroy()
            end
        end
    end
end, y)
y = y + 27
-- Auto Equip Punch
VisualHub:AddSwitch(gui, "Auto Equip Punch", function(state)
    getgenv().autoEquipPunch = state
    task.spawn(function()
        while getgenv().autoEquipPunch and LocalPlayer.Character do
            local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or LocalPlayer.Character:FindFirstChild("Punch")
            if punch then
                punch.Parent = LocalPlayer.Character
            end
            wait(0.05)
        end
    end)
end, y)
y = y + 27

-- Unlock Fast Punch
VisualHub:AddSwitch(gui, "Unlock Fast Punch", function(state)
    getgenv().fastPunch = state
    task.spawn(function()
        while getgenv().fastPunch and LocalPlayer.Character do
            local punch = LocalPlayer.Character:FindFirstChild("Punch")
            if punch then
                ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
            end
            task.wait(0.01) -- Más bajo = más velocidad
        end
    end)
end, y)
y = y + 27

-- Auto Rock de 10M
VisualHub:AddSwitch(gui, "Auto Golpear Roca 10M", function(state)
    getgenv().autoRock10M = state
    task.spawn(function()
        while getgenv().autoRock10M and LocalPlayer.Character do
            pcall(function()
                if LocalPlayer.Durability.Value >= 10000000 then
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("LeftHand") and character:FindFirstChild("RightHand") then
                        for _, v in pairs(Workspace.machinesFolder:GetDescendants()) do
                            if v.Name == "neededDurability" and v.Value == 10000000 then
                                local rock = v.Parent:FindFirstChild("Rock")
                                if rock then
                                    firetouchinterest(rock, character.RightHand, 0)
                                    firetouchinterest(rock, character.RightHand, 1)
                                    firetouchinterest(rock, character.LeftHand, 0)
                                    firetouchinterest(rock, character.LeftHand, 1)
                                    -- Equipar puños automático
                                    local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                                    if punch then
                                        punch.Parent = character
                                    end
                                    LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
                                    LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
                                    break
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.01)
        end
    end)
end, y)
y = y + 27

-- Auto Rock de 1M
VisualHub:AddSwitch(gui, "Auto Golpear Roca 1M", function(state)
    getgenv().autoRock1M = state
    task.spawn(function()
        while getgenv().autoRock1M and LocalPlayer.Character do
            pcall(function()
                if LocalPlayer.Durability.Value >= 1000000 then
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("LeftHand") and character:FindFirstChild("RightHand") then
                        for _, v in pairs(Workspace.machinesFolder:GetDescendants()) do
                            if v.Name == "neededDurability" and v.Value == 1000000 then
                                local rock = v.Parent:FindFirstChild("Rock")
                                if rock then
                                    firetouchinterest(rock, character.RightHand, 0)
                                    firetouchinterest(rock, character.RightHand, 1)
                                    firetouchinterest(rock, character.LeftHand, 0)
                                    firetouchinterest(rock, character.LeftHand, 1)
                                    -- Equipar puños automático
                                    local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                                    if punch then
                                        punch.Parent = character
                                    end
                                    LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
                                    LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
                                    break
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.01)
        end
    end)
end, y)
y = y + 27
--roca 5M
VisualHub:AddSwitch(gui, "Auto Golpear Roca 5M", function(state)
    getgenv().autoRock5M = state
    task.spawn(function()
        while getgenv().autoRock5M and LocalPlayer.Character do
            pcall(function()
                if LocalPlayer.Durability.Value >= 5000000 then
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("LeftHand") and character:FindFirstChild("RightHand") then
                        for _, v in pairs(Workspace.machinesFolder:GetDescendants()) do
                            if v.Name == "neededDurability" and v.Value == 5000000 then
                                local rock = v.Parent:FindFirstChild("Rock")
                                if rock then
                                    firetouchinterest(rock, character.RightHand, 0)
                                    firetouchinterest(rock, character.RightHand, 1)
                                    firetouchinterest(rock, character.LeftHand, 0)
                                    firetouchinterest(rock, character.LeftHand, 1)
                                    -- Equipar puños automático
                                    local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                                    if punch then
                                        punch.Parent = character
                                    end
                                    LocalPlayer.muscleEvent:FireServer("punch", "leftHand")
                                    LocalPlayer.muscleEvent:FireServer("punch", "rightHand")
                                    break
                                end
                            end
                        end
                    end
                end
            end)
            task.wait(0.01)
        end
    end)
end, y)
y = y + 27
--Auto Pushups 
VisualHub:AddSwitch(gui, "Auto Pushups", function(state)
    getgenv().autoPushups = state
    task.spawn(function()
        while getgenv().autoPushups do
            -- Intentar equipar Pushups
            local char = LocalPlayer.Character
            local push = char and char:FindFirstChild("Pushups") or LocalPlayer.Backpack:FindFirstChild("Pushups")
            if push and push.Parent ~= char then
                push.Parent = char
            end
            -- Solo spamear "rep" si la herramienta está equipada
            if char and char:FindFirstChild("Pushups") then
                LocalPlayer.muscleEvent:FireServer("rep")
            end
            task.wait(0.01) -- Puedes bajar a 0.08 o 0.05 para más rapidez
        end
    end)
end, y)
y = y + 27
-- El menú muestra todo bien, cada switch aparece y puedes reordenar a gusto.
