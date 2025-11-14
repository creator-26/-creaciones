local Library = loadfile("librerya-tokkatk.txt")()

local Window = Library.new({
    Title = "ML-Hub Premium",
    Keybind = Enum.KeyCode.RightShift,
    Accent = Color3.fromRGB(45, 160, 230)
})

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace = game:GetService('Workspace')

-- -------------------- INFO TAB: Tiempo y ping -------------------------
local infoTab = Window:NewTab({Title="Info"})
local infoSection = infoTab:NewSection({Title="Status"})
local timeLabel = infoSection:NewLabel({Title="Tiempo: 00:00:00"})
local pingLabel = infoSection:NewLabel({Title="Ping: 0 ms"})

local startTime = tick()
spawn(function()
    while true do
        local t = tick() - startTime
        local hours = math.floor(t/3600)
        local mins = math.floor((t%3600)/60)
        local secs = math.floor(t%60)
        timeLabel:Set("Tiempo: " .. string.format("%02d:%02d:%02d", hours, mins, secs))
        local LocalPlayer = game:GetService('Players').LocalPlayer
        local networkPing = math.floor((game.Stats and game.Stats.Network and game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) or (math.random(60,110)))
        pingLabel:Set("Ping: " .. tostring(networkPing).." ms")
        wait(1)
    end
end)

-- -------------------- FARM TAB --------------------------
local mainTab = Window:NewTab({Title = "Farm y Utilidades"})
local mainSection = mainTab:NewSection({Title = "Autos & Resistencia"})

mainSection:NewToggle({
    Title = "Lock Position",
    Default = false,
    Callback = function(state)
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
    end
})

mainSection:NewButton({
    Title = "Anti AFK",
    Description = "Evita el kick por inactividad.",
    Callback = function()
        if getgenv().afkConn then pcall(function() getgenv().afkConn:Disconnect() end) end
        local vu = game:GetService("VirtualUser")
        getgenv().afkConn = LocalPlayer.Idled:Connect(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
        if not getgenv().antiAFKKeepAliveLoop then
            getgenv().antiAFKKeepAliveLoop = true
            task.spawn(function()
                while getgenv().antiAFKKeepAliveLoop do
                    pcall(function()
                        vu:CaptureController()
                        vu:ClickButton2(Vector2.new())
                    end)
                    task.wait(300)
                end
            end)
        end
    end
})

mainSection:NewButton({
    Title = "Antilag",
    Description = "Maximiza tu FPS y elimina efectos visuales.",
    Callback = function()
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
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = 1
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.ExposureCompensation = 0
    end
})

mainSection:NewToggle({
    Title = "Auto Eat Protein Egg 30 Min",
    Default = false,
    Callback = function(state)
        getgenv().autoEatProteinEggActive = state
        task.spawn(function()
            while getgenv().autoEatProteinEggActive and LocalPlayer.Character do
                local eggAte = false
                for retry = 1, 25 do
                    local egg = LocalPlayer.Backpack:FindFirstChild("Protein Egg") 
                        or LocalPlayer.Character:FindFirstChild("Protein Egg")
                    if egg then
                        egg.Parent = LocalPlayer.Character
                        ReplicatedStorage.muscleEvent:FireServer("rep")
                        eggAte = true
                        break
                    end
                    task.wait(2)
                end
                if eggAte then
                    for i = 1, 1800 do
                        if not getgenv().autoEatProteinEggActive then return end
                        task.wait(1)
                    end
                else
                    task.wait(10)
                end
            end
        end)
    end
})

mainSection:NewToggle({
    Title = "Anti Knockback",
    Default = false,
    Callback = function(state)
        local player = game.Players.LocalPlayer
        local character = player and Workspace:FindFirstChild(player.Name)
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
                if bv then bv:Destroy() end
            end
        end
    end
})

mainSection:NewToggle({
    Title = "Auto Equip Punch",
    Default = false,
    Callback = function(state)
        getgenv().autoEquipPunch = state
        task.spawn(function()
            while getgenv().autoEquipPunch and LocalPlayer.Character do
                local punch = LocalPlayer.Backpack:FindFirstChild("Punch") or LocalPlayer.Character:FindFirstChild("Punch")
                if punch then punch.Parent = LocalPlayer.Character end
                wait(0.05)
            end
        end)
    end
})

mainSection:NewToggle({
    Title = "Unlock Fast Punch",
    Default = false,
    Callback = function(state)
        getgenv().fastPunch = state
        task.spawn(function()
            while getgenv().fastPunch and LocalPlayer.Character do
                local punch = LocalPlayer.Character:FindFirstChild("Punch")
                if punch then
                    ReplicatedStorage.muscleEvent:FireServer("punch", "rightHand")
                    ReplicatedStorage.muscleEvent:FireServer("punch", "leftHand")
                end
                task.wait(0.01)
            end
        end)
    end
})

mainSection:NewToggle({
    Title = "Auto Golpear Roca 10M",
    Default = false,
    Callback = function(state)
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
                                        local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                                        if punch then punch.Parent = character end
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
    end
})

mainSection:NewToggle({
    Title = "Auto Golpear Roca 1M",
    Default = false,
    Callback = function(state)
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
                                        local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                                        if punch then punch.Parent = character end
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
    end
})

mainSection:NewToggle({
    Title = "Auto Golpear Roca 5M",
    Default = false,
    Callback = function(state)
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
                                        local punch = LocalPlayer.Backpack:FindFirstChild("Punch")
                                        if punch then punch.Parent = character end
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
    end
})

mainSection:NewToggle({
    Title = "Auto Pushups",
    Default = false,
    Callback = function(state)
        getgenv().autoPushups = state
        task.spawn(function()
            while getgenv().autoPushups do
                local char = LocalPlayer.Character
                local push = char and char:FindFirstChild("Pushups") or LocalPlayer.Backpack:FindFirstChild("Pushups")
                if push and push.Parent ~= char then push.Parent = char end
                if char and char:FindFirstChild("Pushups") then
                    LocalPlayer.muscleEvent:FireServer("rep")
                end
                task.wait(0.01)
            end
        end)
    end
})
