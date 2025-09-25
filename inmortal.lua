-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StealthImmortalGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 20, 0, 200)
button.Text = "STEALTH GOD: OFF"
button.BackgroundColor3 = Color3.fromRGB(80, 80, 80) -- Gris discreto
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 14
button.Parent = screenGui
button.Active = true
button.Draggable = true

-- 🔥 MÉTODO STEALTH (INDETECTABLE)
local stealthMode = false
local normalHealth = 100

local function activateStealthGod()
    if not stealthMode then return end
    
    local character = LocalPlayer.Character
    if not character then
        character = LocalPlayer.CharacterAdded:Wait()
    end
    
    local humanoid = character:WaitForChild("Humanoid")
    
    -- 🔥 TÉCNICA 1: MANTENER VALORES NORMALES (NO INFINITOS)
    humanoid.MaxHealth = 100
    humanoid.Health = 100
    normalHealth = 100
    
    -- 🔥 TÉCNICA 2: CURACIÓN RÁPIDA EN LUGAR DE INMORTALIDAD
    RunService.Heartbeat:Connect(function()
        if not stealthMode or not character.Parent then return end
        
        -- Si recibe daño, curar rápidamente (no instantáneamente)
        if humanoid.Health < normalHealth then
            wait(0.3) -- Pequeño delay para parecer natural
            humanoid.Health = normalHealth
        end
        
        -- Prevenir muerte sin ser obvio
        if humanoid.Health <= 10 then
            humanoid.Health = 50 -- No revivir completo, solo salvar de la muerte
        end
    end)
    
    -- 🔥 TÉCNICA 3: PROTECCIÓN DISCRETA CONTRA CAÍDA
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if rootPart then
        RunService.Stepped:Connect(function()
            if not stealthMode then return end
            
            -- Si cae muy bajo, teletransportar discretamente
            if rootPart.Position.Y < -200 then
                -- Buscar una posición segura cerca
                local safeCFrame = CFrame.new(0, 50, 0)
                rootPart.CFrame = safeCFrame
            end
        end)
    end
    
    -- 🔥 TÉCNICA 4: SIMULAR COMPORTAMIENTO NORMAL
    humanoid.Died:Connect(function()
        if stealthMode then
            wait(3) -- Esperar tiempo normal de respawn
            -- Reactivar protección en nuevo character
            if stealthMode then
                activateStealthGod()
            end
        end
    end)
end

local function deactivateStealthGod()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.MaxHealth = 100
        character.Humanoid.Health = 100
    end
end

button.MouseButton1Click:Connect(function()
    stealthMode = not stealthMode
    
    if stealthMode then
        button.Text = "STEALTH GOD: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 120, 0) -- Verde oscuro (discreto)
        activateStealthGod()
        
        -- Reconectar silenciosamente
        LocalPlayer.CharacterAdded:Connect(function()
            wait(2) -- Esperar normal
            if stealthMode then
                activateStealthGod()
            end
        end)
        
        print("🕵️ MODO STEALTH ACTIVADO - Eres casi inmortal pero discreto")
    else
        button.Text = "STEALTH GOD: OFF"
        button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        deactivateStealthGod()
        print("❌ MODO STEALTH DESACTIVADO")
    end
end)

-- 🔥 TÉCNICA 5: PROTECCIÓN SILENCIOSA DEL ENTORNO
wait(3)

local function makeEnvironmentSafe()
    if not stealthMode then return end
    
    -- Desactivar zonas de muerte SILENCIOSAMENTE
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("Part") and (
            part.Name:lower():find("kill") or 
            part.Name:lower():find("instant") or
            part.Name:lower():find("lava")
        ) then
            -- No destruir, solo hacer intocable temporalmente
            part.CanTouch = false
        end
    end
end

-- Aplicar protección ambiental cada 30 segundos (discreto)
while true do
    if stealthMode then
        makeEnvironmentSafe()
    end
    wait(30)
end
