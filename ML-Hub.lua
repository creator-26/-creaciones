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
y = y + 30

-- Anti AFK
local btn = VisualHub:AddButton(gui, "Anti AFK", function()
    -- Desconecta Anti AFK previo si existe
    if getgenv().afkConn then getgenv().afkConn:Disconnect() end
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local vu = game:GetService("VirtualUser")
    -- Opción móvil/enhanced: VirtualInputManager
    local vim = game:GetService("VirtualInputManager")
    getgenv().afkConn = LocalPlayer.Idled:Connect(function()
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
        if vim and vim.SendKeyEvent then
            vim:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        end
    end)
end, y)
btn.Size = UDim2.new(0, 150, 0, 30)  -- ancho 150, alto 35 (ajusta como prefieras)
btn.Position = UDim2.new(0, 15, 0, y) -- opcional, para mantener alineado
y = y + 30


-- Antilag
local btn = VisualHub:AddButton(gui, "Antilag (Doca)", function()
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
y = y + 30

-- Auto Egg cada 30 minutos
VisualHub:AddSwitch(gui, "Auto Protein Egg 30 min", function(state)
    getgenv().autoEatProteinEgg30 = state
    task.spawn(function()
        while getgenv().autoEatProteinEgg30 and LocalPlayer.Character do
            local egg = LocalPlayer.Backpack:FindFirstChild("Protein Egg") or LocalPlayer.Character:FindFirstChild("Protein Egg")
            if egg then
                egg.Parent = LocalPlayer.Character
                ReplicatedStorage.muscleEvent:FireServer("rep")
            end
            task.wait(1800)
        end
    end)
end, y)
y = y + 30

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
y = y + 30
-- Auto Equip Punch
VisualHub:AddSwitch(gui, "Auto Equip Punch", function(state)
    getgenv().autoEquipPunch = state
    task.spawn(function()
        while getgenv().autoEquipPunch and LocalPlayer.Character do
            local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or LocalPlayer.Character:FindFirstChild("Punch")
            if punch then
                punch.Parent = LocalPlayer.Character
            end
            wait(0.1)
        end
    end)
end, y)
y = y + 30

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
            task.wait(0.03) -- Más bajo = más velocidad
        end
    end)
end, y)
y = y + 30

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
            task.wait(0.03)
        end
    end)
end, y)
y = y + 30

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
            task.wait(0.03)
        end
    end)
end, y)
y = y + 30
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
            task.wait(0.03)
        end
    end)
end, y)
y = y + 30
-- El menú muestra todo bien, cada switch aparece y puedes reordenar a gusto.
