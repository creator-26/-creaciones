local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local clon = nil
local clonActivo = false

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local spawnButton = Instance.new("TextButton")
spawnButton.Size = UDim2.new(0, 120, 0, 40)
spawnButton.Position = UDim2.new(0, 10, 0, 200)
spawnButton.Text = "Clon OFF"
spawnButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
spawnButton.Parent = ScreenGui

local swapButton = Instance.new("TextButton")
swapButton.Size = UDim2.new(0, 120, 0, 40)
swapButton.Position = UDim2.new(0, 10, 0, 250)
swapButton.Text = "Intercambiar"
swapButton.BackgroundColor3 = Color3.fromRGB(200, 200, 100)
swapButton.Parent = ScreenGui

-- Crear NPC real usando el ID que encontraste
local function crearNPCRreal()
    local success, npcModel = pcall(function()
        return game:GetObjects('rbxassetid://4446576906')[1]
    end)
    
    if success and npcModel then
        print("✅ NPC cargado correctamente!")
        
        -- Configurar el NPC
        npcModel.Name = "MiClonNPC"
        
        -- Posicionar frente al jugador
        local frente = HumanoidRootPart.CFrame.LookVector * 6
        local posicion = HumanoidRootPart.Position + frente
        
        -- Mover todo el modelo
        if npcModel:FindFirstChild("HumanoidRootPart") then
            npcModel.HumanoidRootPart.CFrame = CFrame.new(posicion)
        else
            -- Si no tiene root part, mover el modelo completo
            npcModel:PivotTo(CFrame.new(posicion))
        end
        
        -- Asegurar que no sea dañino
        local humanoid = npcModel:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = 0  -- Que no se mueva
        end
        
        npcModel.Parent = workspace
        return npcModel
        
    else
        print("❌ Error cargando NPC, usando dummy de respaldo")
        return crearDummyRespaldo()
    end
end

-- Función de respaldo por si falla el ID
local function crearDummyRespaldo()
    local dummy = Instance.new("Model")
    dummy.Name = "ClonRespaldo"
    
    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = dummy
    
    local root = Instance.new("Part")
    root.Name = "HumanoidRootPart"
    root.Size = Vector3.new(2, 2, 1)
    root.Position = HumanoidRootPart.Position + (HumanoidRootPart.CFrame.LookVector * 6)
    root.Anchored = false
    root.BrickColor = BrickColor.new("Bright green")
    root.Parent = dummy
    dummy.PrimaryPart = root
    
    dummy.Parent = workspace
    return dummy
end

-- ON/OFF Clon
spawnButton.MouseButton1Click:Connect(function()
    if clonActivo then
        -- Apagar clon
        if clon and clon.Parent then 
            clon:Destroy() 
        end
        clon = nil
        clonActivo = false
        spawnButton.Text = "Clon OFF"
        spawnButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
    else
        -- Encender clon con NPC real
        clon = crearNPCRreal()
        clonActivo = true
        spawnButton.Text = "Clon ON"
        spawnButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
        
        -- Verificar qué se cargó
        if clon.Name == "MiClonNPC" then
            print("🎮 NPC real cargado!")
        else
            print("⚙️ Usando dummy de respaldo")
        end
    end
end)

-- Intercambiar posiciones
swapButton.MouseButton1Click:Connect(function()
    if clon then
        local playerPos = HumanoidRootPart.CFrame
        
        -- Buscar la root part del NPC
        local clonRoot = clon:FindFirstChild("HumanoidRootPart") or clon.PrimaryPart
        
        if clonRoot then
            HumanoidRootPart.CFrame = clonRoot.CFrame
            clonRoot.CFrame = playerPos
            print("🔄 Posiciones intercambiadas!")
        end
    end
end)

print("✅ Script de clon mejorado listo!")
