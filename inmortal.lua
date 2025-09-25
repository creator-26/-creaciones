-- Servicios
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- GUI que NO desaparece
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RealImmortalGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 150, 0, 50)
button.Position = UDim2.new(0, 20, 0, 200)
button.Text = "INMORTAL: OFF"
button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.SourceSansBold
button.TextSize = 16
button.Parent = screenGui
button.Active = true
button.Draggable = true

-- 🔥 MÉTODO REAL DE INMORTALIDAD
local immortal = false

local function makeImmortal()
    if not immortal then return end
    
    local character = LocalPlayer.Character
    if not character then
        character = LocalPlayer.CharacterAdded:Wait()
    end
    
    local humanoid = character:WaitForChild("Humanoid")
    
    -- 🔥 TÉCNICA 1: ELIMINAR EL HUMANOIDE COMPLETAMENTE
    -- Sin humanoid = no puedes morir
    wait(1)
    
    -- Crear un humanoide falso
    local fakeHumanoid = humanoid:Clone()
    humanoid:Destroy()
    fakeHumanoid.Parent = character
    
    -- Configurar humanoide falso
    fakeHumanoid.MaxHealth = 0
    fakeHumanoid.Health = 0
    fakeHumanoid.BreakJointsOnDeath = false
    
    -- 🔥 TÉCNICA 2: HACER TODAS LAS PARTES INTOCABLES
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanTouch = false
            part.CanCollide = false
            part.Massless = true
        end
    end
    
    -- 🔥 TÉCNICA 3: ANULAR TODAS LAS CONEXIONES DE DAÑO
    for _, script in ipairs(character:GetDescendants()) do
        if script:IsA("Script") or script:IsA("LocalScript") then
            if script.Name:lower():find("damage") or script.Name:lower():find("health") then
                script.Disabled = true
            end
        end
    end
    
    -- 🔥 TÉCNICA 4: PROTECCIÓN CONSTANTE EXTREMA
    RunService.Heartbeat:Connect(function()
        if not immortal or not character.Parent then return end
        
        -- Mantener partes intocables
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanTouch = false
            end
        end
        
        -- Prevenir caída
        local root = character:FindFirstChild("HumanoidRootPart")
        if root and root.Position.Y < -100 then
            root.CFrame = CFrame.new(0, 50, 0)
        end
    end)
end

button.MouseButton1Click:Connect(function()
    immortal = not immortal
    
    if immortal then
        button.Text = "INMORTAL: ON"
        button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        makeImmortal()
        
        -- Reconectar al respawn
        LocalPlayer.CharacterAdded:Connect(function()
            if immortal then
                makeImmortal()
            end
        end)
    else
        button.Text = "INMORTAL: OFF"
        button.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        -- Restaurar character normal
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.MaxHealth = 100
                humanoid.Health = 100
            end
        end
    end
end)

print("🔥 MÉTODO REAL DE INMORTALIDAD ACTIVADO")
