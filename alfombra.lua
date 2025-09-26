local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

local alfombra = nil
local alfombraActiva = false
local velocidad = 50
local conexionesVuelo = {}

-- GUI para la alfombra
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local alfombraButton = Instance.new("TextButton")
alfombraButton.Size = UDim2.new(0, 120, 0, 40)
alfombraButton.Position = UDim2.new(0, 10, 0, 300)
alfombraButton.Text = "Alfombra OFF"
alfombraButton.BackgroundColor3 = Color3.fromRGB(150, 75, 75)
alfombraButton.Parent = ScreenGui

-- Función para diagnosticar el asset
local function diagnosticarAsset(id)
    print("🔍 Diagnosticando ID: " .. id)
    
    -- Intentar como objeto completo
    local success1, resultado1 = pcall(function()
        return game:GetObjects('rbxassetid://'..id)[1]
    end)
    
    if success1 and resultado1 then
        print("✅ ES UN OBJETO/MODELO COMPLETO")
        print("Tipo: " .. resultado1.ClassName)
        print("Nombre: " .. resultado1.Name)
        return resultado1
    end
    
    -- Intentar como malla
    local success2, resultado2 = pcall(function()
        local part = Instance.new("Part")
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshId = "rbxassetid://"..id
        mesh.Parent = part
        return "Es una malla"
    end)
    
    if success2 then
        print("✅ ES UNA MALLA (Mesh)")
        return "mesh"
    end
    
    -- Intentar como textura
    local success3, resultado3 = pcall(function()
        local part = Instance.new("Part")
        local decal = Instance.new("Decal")
        decal.Texture = "rbxassetid://"..id
        decal.Parent = part
        return "Es una textura"
    end)
    
    if success3 then
        print("✅ ES UNA TEXTURA (Decal)")
        return "texture"
    end
    
    print("❌ No se pudo identificar el tipo de asset")
    return nil
end

-- Cargar la alfombra con el nuevo ID
local function crearAlfombra()
    print("🎯 Cargando alfombra con ID: 13547631593")
    
    local success, modeloAlfombra = pcall(function()
        return game:GetObjects('rbxassetid://13547631593')[1]
    end)
    
    if success and modeloAlfombra then
        print("✅ ¡ALFOMBRA CARGADA EXITOSAMENTE!")
        print("Nombre del modelo: " .. modeloAlfombra.Name)
        print("Tipo: " .. modeloAlfombra.ClassName)
        
        modeloAlfombra.Name = "AlfombraMagicaPro"
        
        -- Posicionar bajo los pies del jugador
        local posicion = HumanoidRootPart.Position - Vector3.new(0, 4, 0)
        
        -- Configurar todas las partes
        local partes = modeloAlfombra:GetDescendants()
        for _, parte in ipairs(partes) do
            if parte:IsA("BasePart") then
                parte.Anchored = true
                parte.CanCollide = true
                parte.CFrame = CFrame.new(posicion) * parte.CFrame - parte.Position
            end
        end
        
        -- Si es un Model, asegurar primary part
        if modeloAlfombra:IsA("Model") and not modeloAlfombra.PrimaryPart then
            local primeraParte = modeloAlfombra:FindFirstChildOfClass("BasePart")
            if primeraParte then
                modeloAlfombra.PrimaryPart = primeraParte
            end
        end
        
        modeloAlfombra.Parent = workspace
        
        -- Añadir efectos mágicos
        local efecto = Instance.new("Sparkles")
        efecto.SparkleColor = Color3.new(0, 1, 1)  -- Cian
        if modeloAlfombra.PrimaryPart then
            efecto.Parent = modeloAlfombra.PrimaryPart
        else
            efecto.Parent = modeloAlfombra
        end
        
        return modeloAlfombra
        
    else
        print("❌ Error cargando alfombra: " .. tostring(modeloAlfombra))
        print("🔄 Creando alfombra de respaldo...")
        return crearAlfombraRespaldo()
    end
end

-- Alfombra de respaldo mejorada
local function crearAlfombraRespaldo()
    local alfombra = Instance.new("Part")
    alfombra.Name = "AlfombraBasicaPro"
    alfombra.Size = Vector3.new(10, 0.2, 6)
    alfombra.Position = HumanoidRootPart.Position - Vector3.new(0, 4, 0)
    alfombra.BrickColor = BrickColor.new("Deep blue")
    alfombra.Material = Enum.Material.Neon
    alfombra.Anchored = true
    alfombra.CanCollide = true
    
    -- Efectos mágicos
    local sparkles = Instance.new("Sparkles")
    sparkles.SparkleColor = Color3.new(1, 0, 1)  -- Magenta
    sparkles.Parent = alfombra
    
    local pointLight = Instance.new("PointLight")
    pointLight.Brightness = 2
    pointLight.Color = Color3.new(0, 1, 1)
    pointLight.Parent = alfombra
    
    alfombra.Parent = workspace
    return alfombra
end

-- Sistema de vuelo mejorado
local function activarVuelo()
    if not alfombra then return end
    
    -- Sentar al jugador
    local humanoid = Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.Sit = true
        wait(0.5)
    end
    
    -- Obtener la parte principal de la alfombra
    local parteAlfombra = alfombra
    if alfombra:IsA("Model") and alfombra.PrimaryPart then
        parteAlfombra = alfombra.PrimaryPart
    end
    
    -- Controles de vuelo
    local UIS = game:GetService("UserInputService")
    
    local function volar(input, gameProcessed)
        if gameProcessed then return end
        if not alfombraActiva or not parteAlfombra then return end
        
        local direccion = Vector3.new(0, 0, 0)
        
        if input.KeyCode == Enum.KeyCode.W then
            direccion = HumanoidRootPart.CFrame.LookVector
        elseif input.KeyCode == Enum.KeyCode.S then
            direccion = -HumanoidRootPart.CFrame.LookVector
        elseif input.KeyCode == Enum.KeyCode.A then
            direccion = -HumanoidRootPart.CFrame.RightVector
        elseif input.KeyCode == Enum.KeyCode.D then
            direccion = HumanoidRootPart.CFrame.RightVector
        elseif input.KeyCode == Enum.KeyCode.Space then
            direccion = Vector3.new(0, 1, 0)
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            direccion = Vector3.new(0, -1, 0)
        end
        
        if direccion.Magnitude > 0 then
            local incremento = direccion * velocidad * 0.02
            local nuevaPos = parteAlfombra.Position + incremento
            
            -- Mover alfombra
            if alfombra:IsA("Model") then
                alfombra:PivotTo(CFrame.new(nuevaPos))
            else
                parteAlfombra.Position = nuevaPos
            end
            
            -- Mover jugador con la alfombra
            HumanoidRootPart.CFrame = CFrame.new(nuevaPos + Vector3.new(0, 3, 0))
        end
    end
    
    -- Conexión de teclado
    local conexion = UIS.InputBegan:Connect(volar)
    table.insert(conexionesVuelo, conexion)
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
        
        -- Desconectar controles
        for _, conexion in ipairs(conexionesVuelo) do
            conexion:Disconnect()
        end
        conexionesVuelo = {}
        
        alfombraButton.Text = "Alfombra OFF"
        alfombraButton.BackgroundColor3 = Color3.fromRGB(150, 75, 75)
        
        -- Levantar al jugador
        local humanoid = Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.Sit = false
        end
        
        print("🔴 Alfombra desactivada")
        
    else
        -- Primero diagnosticar
        diagnosticarAsset(13547631593)
        
        -- Encender alfombra
        alfombra = crearAlfombra()
        alfombraActiva = true
        alfombraButton.Text = "Alfombra ON"
        alfombraButton.BackgroundColor3 = Color3.fromRGB(75, 150, 75)
        
        -- Activar vuelo después de un momento
        wait(0.5)
        activarVuelo()
        
        print("🟢 Alfombra mágica ACTIVADA!")
        print("🎮 Controles: WASD - Movimiento, Space - Subir, Shift - Bajar")
    end
end)

print("✅ Script de alfombra mágica LISTO con ID 13547631593")
print("🔍 El diagnóstico te dirá qué tipo de asset es")
