local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/creator-26/-creaciones/refs/heads/main/librerya%20tokkatk.txt"))()

local Window = Library.new({
    Title = "ML-Hub",
    Keybind = Enum.KeyCode.RightShift,
    Accent = Color3.fromRGB(45, 160, 230)
})

local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local Workspace = game:GetService('Workspace')

-- -------------------- INFO TAB: Tiempo y ping -------------------------
local infoTab = Window:NewTab({Title="Info"})
local infoSection = infoTab:NewSection({Title="Network Info"})
local timeLabel = infoSection:NewTitle("Tiempo: 00:00:00")
local pingLabel = infoSection:NewTitle("Ping: 0 ms")
local fpsLabel = infoSection:NewTitle("FPS: 0") -- Nuevo campo FPS

local startTime = tick()
local lastUpdate = tick()
local frames = 0
local currentFps = 0

-- Calcula y actualiza FPS continuamente
game:GetService("RunService").RenderStepped:Connect(function()
    frames = frames + 1
    local now = tick()
    if now - lastUpdate >= 1 then
        currentFps = frames
        fpsLabel.Set("FPS: " .. tostring(currentFps))
        frames = 0
        lastUpdate = now
    end
end)

task.spawn(function()
    while true do
        local t = tick() - startTime
        local hours = math.floor(t/3600)
        local mins = math.floor((t%3600)/60)
        local secs = math.floor(t%60)
        timeLabel.Set("Tiempo: " .. string.format("%02d:%02d:%02d", hours, mins, secs))
        local LocalPlayer = Players.LocalPlayer
        local networkPing = math.floor((game:FindFirstChild("Stats") and game.Stats.Network and game.Stats.Network.ServerStatsItem and game.Stats.Network.ServerStatsItem["Data Ping"] and game.Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) or math.random(60,110))
        pingLabel.Set("Ping: " .. tostring(networkPing).." ms")
        task.wait(1)
    end
end)
-------
local Players = game:GetService("Players")

-- Stats Section
local statsSection = infoTab:NewSection({
    Title = "Stats",
    Position = "Right"
})

-- Formato corto
local function shortNumber(n)
    n = tonumber(n)
    if not n then return "0" end
    if n >= 1e15 then
        return string.format("%.2fQ", n / 1e15)
    elseif n >= 1e12 then
        return string.format("%.2fT", n / 1e12)
    elseif n >= 1e9 then
        return string.format("%.2fB", n / 1e9)
    elseif n >= 1e6 then
        return string.format("%.2fM", n / 1e6)
    else
        return tostring(n)
    end
end

local function getPlayerNames()
    local names = {}
    for _,p in ipairs(Players:GetPlayers()) do
        table.insert(names, p.Name)
    end
    return names
end

local selectedPlayer = Players.LocalPlayer.Name
local lastNames = getPlayerNames()

-- Prepara el Dropdown (show only names, no numbers)
local playerDropdown = statsSection:NewDropdown({
    Title = "Jugador",
    Values = lastNames,
    Default = selectedPlayer,
    Callback = function(val)
        selectedPlayer = val
    end
})

local strengthLabel = statsSection:NewTitle("Fuerza: ...")
local durabilityLabel = statsSection:NewTitle("Durabilidad: ...")
local rebirthsLabel = statsSection:NewTitle("Renacimientos: ...")
local killsLabel = statsSection:NewTitle("Kills: ...")

-- Actualiza la lista de nombres en tiempo real
local function updatePlayerList()
    local actualNames = getPlayerNames()
    lastNames = actualNames
    playerDropdown.SetValues(actualNames)
    -- Ajusta el seleccionado si se fue
    if not table.find(actualNames, selectedPlayer) and #actualNames > 0 then
        selectedPlayer = actualNames[1]
        playerDropdown.Set(selectedPlayer)
    end
end

Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

-- Refresca stats del jugador seleccionado
task.spawn(function()
    while true do
        local player = Players:FindFirstChild(selectedPlayer)
        if player then
            local leaderstats = player:FindFirstChild("leaderstats")
            if leaderstats then
                strengthLabel.Set("Fuerza: " .. shortNumber((leaderstats:FindFirstChild("Strength") and leaderstats.Strength.Value) or 0))
                rebirthsLabel.Set("Renacimientos: " .. tostring((leaderstats:FindFirstChild("Rebirths") and leaderstats.Rebirths.Value) or 0))
                killsLabel.Set("Kills: " .. tostring((leaderstats:FindFirstChild("Kills") and leaderstats.Kills.Value) or 0))
            else
                strengthLabel.Set("Fuerza: N/A")
                rebirthsLabel.Set("Renacimientos: N/A")
                killsLabel.Set("Kills: N/A")
            end
            durabilityLabel.Set("Durabilidad: " .. shortNumber((player:FindFirstChild("Durability") and player.Durability.Value) or 0))
        else
            strengthLabel.Set("Fuerza: N/A")
            durabilityLabel.Set("Durabilidad: N/A")
            rebirthsLabel.Set("Renacimientos: N/A")
            killsLabel.Set("Kills: N/A")
        end
        task.wait(1)
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
    Description = "Optimiza FPS y reduce efectos al máximo.",
    Callback = function()
        -- Simplifica materiales y elimina reflejos
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
                v.CastShadow = false
            end
            if v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            end
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") or v:IsA("Beam") then
                v.Enabled = false
            end
            if v:IsA("Explosion") or v:IsA("Sound") then
                v:Destroy()
            end
            if v:IsA("SurfaceAppearance") or v:IsA("Highlight") or v:IsA("Shimmer") then
                v:Destroy()
            end
            if v:IsA("MeshPart") then
                v.TextureID = ""
            end
            if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                v.Enabled = false
            end
        end

        -- Lighting settings súper bajos
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = 1
        Lighting.FogEnd = 1e10
        Lighting.GlobalShadows = false
        Lighting.ExposureCompensation = 0
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.ClockTime = 14
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        -- Elimina efectos de Lighting
        for _, e in ipairs(Lighting:GetChildren()) do
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") or e:IsA("Atmosphere") then
                e:Destroy()
            end
        end

        -- Reduce Textures de Terrain (si el juego usa Terrain)
        if Workspace:FindFirstChildOfClass("Terrain") then
            Workspace.Terrain.WaterWaveSize = 0
            Workspace.Terrain.WaterWaveSpeed = 0
            Workspace.Terrain.WaterReflectance = 0
            Workspace.Terrain.WaterTransparency = 0
        end

        -- Intenta deshabilitar efectos especiales extra
        if game:GetService("StarterGui"):FindFirstChild("Blur") then
            game:GetService("StarterGui").Blur:Destroy()
        end
    end
})

--Auto Egg 30 min
-- Variable de estado global por si otro script también la usa
getgenv().autoEatProteinEggEnabled = false

local function eatProteinEggNew()
    local player = game.Players.LocalPlayer
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character or player.CharacterAdded:Wait()

    if not backpack then
        warn("[AutoEgg] No se encontró Backpack.")
        return
    end
    local egg = backpack:FindFirstChild("Protein Egg")
        or (character and character:FindFirstChild("Protein Egg"))
    if egg then
        egg.Parent = character
        pcall(function()
            egg:Activate()
        end)
        print("[AutoEgg] Protein Egg consumido.")
    else
        warn("[AutoEgg] No se encontró Protein Egg en Backpack ni en Character.")
    end
end

-- Proceso autosostenido cada 30 minutos
task.spawn(function()
    while true do
        if getgenv().autoEatProteinEggEnabled then
            eatProteinEggNew()
            task.wait(1800) -- 30 minutos
        else
            task.wait(1)
        end
    end
end)

-- El toggle en el menú izquierdo
mainSection:NewToggle({
    Title = "Auto Protein Egg 30 Min",
    Default = false,
    Callback = function(state)
        getgenv().autoEatProteinEggEnabled = state
        print(state and "[AutoEgg] Activado." or "[AutoEgg] Desactivado.")
    end
})
    


mainSection:NewToggle({
    Title = "Anti Knockback",
    Default = false,
    Callback = function(state)
        local player = Players.LocalPlayer
        local character = Workspace:FindFirstChild(player.Name)
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
                task.wait(0.04)
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
                task.wait(0.02)
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
-- Esto va junto con tus secciones en el script principal

-- Creamos la sección derecha, si aún no existe
local miscSection = mainTab:NewSection({
    Title = "Misc",
    Position = "Right" -- Hace que salga en la columna derecha
})

-- Agregamos el toggle de Auto Fortune Wheel/Auto Spin
miscSection:NewToggle({
    Title = "Auto Spin",
    Default = false,
    Callback = function(state)
        getgenv().autoFortuneWheelActive = state
        if state then
            local function openFortuneWheel()
                while getgenv().autoFortuneWheelActive do
                    local args = {
                        [1] = "openFortuneWheel",
                        [2] = game:GetService("ReplicatedStorage"):WaitForChild("fortuneWheelChances"):WaitForChild("Fortune Wheel")
                    }
                    game:GetService("ReplicatedStorage"):WaitForChild("rEvents"):WaitForChild("openFortuneWheelRemote"):InvokeServer(unpack(args))
                    task.wait() -- No uses wait(0), usa task.wait()
                end
            end
            task.spawn(openFortuneWheel) -- Usa task.spawn que es mejor que coroutine.wrap
        else
            getgenv().autoFortuneWheelActive = false
        end
    end
})
-- Nueva pestaña
local tpTab = Window:NewTab({Title = "TP portals"})

-- Nueva sección columna izquierda
local tpSection = tpTab:NewSection({
    Title = "Teleport portals",
    Position = "Left"
})

tpSection:NewToggle({
    Title = "TP muscle King",
    Default = false,
    Callback = function(state)
        if state then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(-8752.46, 30.90, -5860.09)
            end
            -- El toggle se apaga solo después de teletransportar (opcional)
            task.wait(0.2)
            -- quita el check automáticamente (esto solo oculta visualmente el toggle)
            pcall(function() tpSection["TP muscle King"].Value(false) end)
        end
    end
})
-- Sección derecha en TP portals
local tpSectionRight = tpTab:NewSection({
    Title = "Teleport portals",
    Position = "Right"
})

tpSectionRight:NewToggle({
    Title = "TP isla secreta",
    Default = false,
    Callback = function(state)
        if state then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = CFrame.new(1948.75, 1.86, 6178.24)
            end
            task.wait(0.2)
            pcall(function() tpSectionRight["TP isla secreta"].Value(false) end)
        end
    end
})
