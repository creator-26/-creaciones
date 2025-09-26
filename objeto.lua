local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local alfombra = nil
local alfombraActiva = false
local velocidad = 50  -- Velocidad de vuelo

-- GUI para la alfombra
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local alfombraButton = Instance.new("TextButton")
alfombraButton.Size = UDim2.new(0, 120, 0, 40)
alfombraButton.Position = UDim2.new(0, 10, 0, 300)  -- Debajo de los otros botones
alfombraButton.Text = "Alfombra OFF"
alfombraButton.BackgroundColor3 = Color3.fromRGB(150, 75, 75)
alfombraButton.Parent = ScreenGui

-- Cargar el modelo de la alfombra
local function crearAlfombra()
    local success, modeloAlfombra = pcall(function()
        return game:GetObjects('rbxassetid://11721073288')[1]
    end)
    
    if success and modeloAlfombra then
        print("✅ Alfombra cargada correctamente!")
        
        modeloAlfombra.Name = "AlfombraMagica"
        
        -- Posicionar bajo los pies del jugador
        local posicion = HumanoidRootPart.Position - Vector3.new(0, 3, 0)
        modeloAlfombra:PivotTo(CFrame.new(posicion))
        
        -- Hacerla física pero anclada inicialmente
        local partes = modeloAlfombra:GetDescendants()
        for _, parte in ipairs(partes) do
            if parte:IsA("BasePart") then
                parte.Anchored = true  -- Anclada para que no se caiga
                parte.CanCollide = true
            end
        end
        
        modeloAlfombra.Parent = workspace
        return modeloAlfombra
    else
        print("❌ Error cargando alfombra: " .. tostring(modeloAlfombra))
        return crearAlfombraBasica()
    end
end

-- Alfombra básica de respaldo
local function crearAlfombraBasica()
    local alfombra = Instance.new("Part")
    alfombra.Name = "AlfombraBasica"
    alfombra.Size = Vector3.new(10, 0.2, 6)  -- Forma de alfombra
    alfombra.Position = HumanoidRootPart.Position - Vector3.new(0, 3, 0)
    alfombra.BrickColor = BrickColor.new("Red")
    alfombra.Material = Enum.Material.Fabric
    alfombra.Anchored = true
    alfombra.CanCollide = true
    alfombra.Parent = workspace
    
    return alfombra
end

-- Sistema de vuelo con la alfombra
local function activarVuelo()
    if not alfombra then return end
    
    -- Sentar al jugador en la alfombra
    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Sit = true
    end
    
    -- Conectar controles de vuelo
    local UIS = game:GetService("UserInputService")
    local conexiones = {}
    
    local function volar(input)
        if alfombra and alfombraActiva then
            local direccion = Vector3.new(0, 0, 0)
            
            -- Controles WASD + Space/Shift
            if input.KeyCode == Enum.KeyCode.W then
                direccion = HumanoidRootPart.CFrame.LookVector
            elseif input.KeyCode == Enum.KeyCode.S then
                direccion = -HumanoidRootPart.CFrame.LookVector
            elseif input.KeyCode == Enum.KeyCode.A then
                direccion = -HumanoidRootPart.CFrame.RightVector
            elseif input.KeyCode == Enum.KeyCode.D then
                direccion = HumanoidRootPart.CFrame.RightVector
            elseif input.KeyCode == Enum.KeyCode.Space then
                direccion = Vector3.new(0, 1, 0)  -- Subir
            elseif input.KeyCode == Enum.KeyCode.LeftShift then
                direccion = Vector3.new(0, -1, 0)  -- Bajar
            end
            
            -- Mover alfombra y jugador
            if direccion.Magnitude > 0 then
                local nuevaPosicion = alfombra.PrimaryPart.Position + (direccion * velocidad * 0.1)
                alfombra:PivotTo(CFrame.new(nuevaPosicion))
                HumanoidRootPart.CFrame = CFrame.new(nuevaPosicion + Vector3.new(0, 3, 0))
            end
        end
    end
    
    -- Conexión de teclado
    table.insert(conexiones, UIS.InputBegan:Connect(volar))
    
    return conexiones
end

-- ON/OFF Alfombra
alfombraButton.MouseButton1Click:Connect(function()
    if alfombraActiva then
        -- Apagar alfombra
        if alfombra and alfombra.Parent then 
            alfombra:Destroy() 
        end
        alfombra = nil
        alfombraActiva = false
        alfombraButton.Text = "Alfombra OFF"
        alfombraButton.BackgroundColor3 = Color3.fromRGB(150, 75, 75)
        
        -- Levantar al jugador
        local humanoid = Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Sit = false
        end
        
    else
        -- Encender alfombra
        alfombra = crearAlfombra()
        alfombraActiva = true
        alfombraButton.Text = "Alfombra ON"
        alfombraButton.BackgroundColor3 = Color3.fromRGB(75, 150, 75)
        
        -- Activar sistema de vuelo
        local conexionesVuelo = activarVuelo()
        
        print("🧞‍♂️ ¡Alfombra mágica activada!")
        print("Controles: WASD - Movimiento, Space - Subir, Shift - Bajar")
    end
end)

print("✅ Script de alfombra mágica listo!")
