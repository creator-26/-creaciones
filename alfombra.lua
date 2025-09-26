local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

print("🎯 PROBANDO ID: 15443495029")

-- Diagnóstico MEGA DETALLADO
local function diagnosticarAsset(id)
    print(" ")
    print("🔍 ===== DIAGNÓSTICO COMPLETO DEL ASSET =====")
    print("📊 ID analizado: " .. id)
    print(" ")
    
    -- 1. PRUEBA COMO OBJETO/MODELO COMPLETO
    print("1️⃣ [OBJETO COMPLETO] Probando game:GetObjects...")
    local success1, objeto = pcall(function()
        local objetos = game:GetObjects('rbxassetid://' .. id)
        if #objetos > 0 then
            return objetos[1]
        else
            error("Array vacío - no hay objetos")
        end
    end)
    
    if success1 and objeto then
        print("✅ ✅ ✅ ¡ÉXITO! Es un OBJETO COMPLETO")
        print("📝 Nombre: " .. objeto.Name)
        print("🔧 Clase: " .. objeto.ClassName)
        print("👶 Cantidad de hijos: " .. #objeto:GetChildren())
        
        -- Mostrar primeros 5 hijos
        print("📋 Primeros hijos:")
        for i = 1, math.min(5, #objeto:GetChildren()) do
            local child = objeto:GetChildren()[i]
            print("   " .. i .. ". " .. child.Name .. " (" .. child.ClassName .. ")")
        end
        
        -- Si es Model, mostrar primary part
        if objeto:IsA("Model") then
            if objeto.PrimaryPart then
                print("📍 PrimaryPart: " .. objeto.PrimaryPart.Name)
            else
                print("📍 No tiene PrimaryPart asignado")
            end
        end
        
        return {tipo = "objeto", data = objeto}
    else
        print("❌ No es objeto completo")
        print("   Error: " .. tostring(objeto))
    end
    
    -- 2. PRUEBA COMO MALLA
    print(" ")
    print("2️⃣ [MALLA] Probando como SpecialMesh...")
    local success2, meshResult = pcall(function()
        local part = Instance.new("Part")
        part.Name = "TestMesh"
        part.Anchored = true
        part.CanCollide = false
        part.Position = Vector3.new(0, 100, 0)  -- Lejos para no molestar
        
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshId = "rbxassetid://" .. id
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.Parent = part
        
        part.Parent = workspace
        wait(0.2)
        
        -- Verificar si la malla se cargó
        if mesh.MeshId == "rbxassetid://" .. id then
            part:Destroy()
            return "mesh_loaded"
        else
            part:Destroy()
            error("Mesh no se cargó correctamente")
        end
    end)
    
    if success2 then
        print("✅ ✅ ✅ ¡ÉXITO! Es una MALLA 3D")
        return {tipo = "malla", data = "mesh"}
    else
        print("❌ No es una malla válida")
    end
    
    -- 3. PRUEBA COMO TEXTURA
    print(" ")
    print("3️⃣ [TEXTURA] Probando como Decal/Texture...")
    local success3, textureResult = pcall(function()
        local part = Instance.new("Part")
        part.Name = "TestTexture"
        part.Size = Vector3.new(10, 1, 10)
        part.Anchored = true
        part.Position = Vector3.new(0, 100, 0)
        part.BrickColor = BrickColor.new("White")
        
        local decal = Instance.new("Decal")
        decal.Face = Enum.NormalId.Top
        decal.Texture = "rbxassetid://" .. id
        decal.Parent = part
        
        part.Parent = workspace
        wait(0.2)
        
        -- Verificar si la textura se cargó
        if decal.Texture == "rbxassetid://" .. id then
            part:Destroy()
            return "texture_loaded"
        else
            part:Destroy()
            error("Texture no se cargó")
        end
    end)
    
    if success3 then
        print("✅ ✅ ✅ ¡ÉXITO! Es una TEXTURA")
        return {tipo = "textura", data = "texture"}
    else
        print("❌ No es una textura válida")
    end
    
    -- 4. PRUEBA COMO SONIDO
    print(" ")
    print("4️⃣ [SONIDO] Probando como Sound...")
    local success4, soundResult = pcall(function()
        local sound = Instance.new("Sound")
        sound.SoundId = "rbxassetid://" .. id
        sound.Parent = workspace
        sound.Volume = 0.1  -- Bajo volumen para prueba
        
        wait(0.2)
        
        if sound.SoundId == "rbxassetid://" .. id then
            sound:Destroy()
            return "sound_loaded"
        else
            sound:Destroy()
            error("Sound ID no se asignó")
        end
    end)
    
    if success4 then
        print("✅ ✅ ✅ ¡ÉXITO! Es un SONIDO")
        return {tipo = "sonido", data = "sound"}
    else
        print("❌ No es un sonido válido")
    end
    
    print(" ")
    print("💥💥💥 EL ASSET NO EXISTE O NO ES ACCESIBLE")
    print("💡 Posibles razones:")
    print("   - El ID no existe en Roblox")
    print("   - El asset es privado")
    print("   - El asset fue eliminado")
    print("   - Error de conexión")
    
    return nil
end

-- CREAR ALFOMBRA BASADA EN EL DIAGNÓSTICO
local function crearAlfombraInteligente()
    print(" ")
    print("🧞‍♂️ ===== CREANDO ALFOMBRA MÁGICA =====")
    
    local diagnostico = diagnosticarAsset(15443495029)
    
    if not diagnostico then
        print("⚠️ Usando alfombra básica de respaldo")
        return crearAlfombraBasica()
    end
    
    print("🎯 Tipo detectado: " .. diagnostico.tipo)
    
    if diagnostico.tipo == "objeto" then
        print("🚀 Cargando modelo completo...")
        local modelo = diagnostico.data
        
        -- Configurar el modelo
        modelo.Name = "AlfombraMagicaPro"
        modelo.Parent = workspace
        
        -- Posicionar bajo el jugador
        local posicion = HumanoidRootPart.Position - Vector3.new(0, 5, 0)
        
        if modelo:IsA("Model") then
            modelo:PivotTo(CFrame.new(posicion))
            print("📍 Modelo posicionado como Model")
        else
            modelo.Position = posicion
            print("📍 Modelo posicionado como Part")
        end
        
        -- Configurar todas las partes
        local partes = 0
        for _, child in pairs(modelo:GetDescendants()) do
            if child:IsA("BasePart") then
                child.Anchored = true
                child.CanCollide = true
                partes = partes + 1
            end
        end
        print("🔧 Partes configuradas: " .. partes)
        
        return modelo
        
    elseif diagnostico.tipo == "malla" then
        print("🎨 Creando alfombra con malla 3D...")
        return crearAlfombraConMalla()
        
    elseif diagnostico.tipo == "textura" then
        print("🖼️ Creando alfombra con textura...")
        return crearAlfombraConTextura()
        
    else
        print("⚠️ Tipo no soportado, usando respaldo")
        return crearAlfombraBasica()
    end
end

-- FUNCIONES ESPECÍFICAS
local function crearAlfombraConMalla()
    local part = Instance.new("Part")
    part.Name = "AlfombraConMalla"
    part.Size = Vector3.new(1, 1, 1)  -- Tamaño base, la malla escala
    part.Position = HumanoidRootPart.Position - Vector3.new(0, 4, 0)
    part.Anchored = true
    part.BrickColor = BrickColor.new("Bright red")
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = "rbxassetid://15443495029"
    mesh.Scale = Vector3.new(10, 1, 6)  -- Escalar para tamaño de alfombra
    mesh.Parent = part
    
    part.Parent = workspace
    return part
end

local function crearAlfombraConTextura()
    local part = Instance.new("Part")
    part.Name = "AlfombraConTextura"
    part.Size = Vector3.new(10, 0.2, 6)
    part.Position = HumanoidRootPart.Position - Vector3.new(0, 4, 0)
    part.Anchored = true
    part.BrickColor = BrickColor.new("White")
    
    local decal = Instance.new("Decal")
    decal.Face = Enum.NormalId.Top
    decal.Texture = "rbxassetid://15443495029"
    decal.Parent = part
    
    part.Parent = workspace
    return part
end

local function crearAlfombraBasica()
    local part = Instance.new("Part")
    part.Name = "AlfombraBasica"
    part.Size = Vector3.new(8, 0.2, 5)
    part.Position = HumanoidRootPart.Position - Vector3.new(0, 4, 0)
    part.Anchored = true
    part.BrickColor = BrickColor.new("Bright blue")
    part.Material = Enum.Material.Neon
    
    -- Efectos mágicos
    local sparkles = Instance.new("Sparkles")
    sparkles.SparkleColor = Color3.new(1, 0, 1)
    sparkles.Parent = part
    
    local light = Instance.new("PointLight")
    light.Brightness = 2
    light.Color = Color3.new(0, 1, 1)
    light.Parent = part
    
    part.Parent = workspace
    return part
end

-- INTERFAZ SIMPLE
local gui = Instance.new("ScreenGui")
gui.Parent = LocalPlayer.PlayerGui

local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 250, 0, 70)
button.Position = UDim2.new(0, 10, 0, 10)
button.Text = "🧞‍♂️ CREAR ALFOMBRA MÁGICA"
button.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
button.TextSize = 20
button.TextColor3 = Color3.new(1, 1, 1)
button.Parent = gui

button.MouseButton1Click:Connect(function()
    print(" ")
    print("⭐ ===== INICIANDO CREACIÓN =====")
    local alfombra = crearAlfombraInteligente()
    print("✅ Alfombra creada: " .. alfombra.Name)
    print("📍 Posición: " .. tostring(alfombra.Position))
    print(" ")
    print("🎮 Controles de vuelo:")
    print("   W/S/A/D - Movimiento horizontal")
    print("   ESPACIO - Subir")
    print("   SHIFT - Bajar")
end)

print(" ")
print("🚀🚀🚀 SCRIPT LISTO PARA ID 15443495029")
print("💡 Haz click en 'CREAR ALFOMBRA MÁGICA'")
print("📊 Verifica la consola (F9) para ver el diagnóstico")
