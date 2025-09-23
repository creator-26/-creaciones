-- ▶️ Clon local que te sigue y salta (solo tú lo ves)
-- Úsalo con loadstring(...) o péga en un LocalScript en StarterPlayerScripts.
-- El script intenta 3 métodos y te muestra cuál funciona (console).

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- CONFIG
local FOLLOW_OFFSET = Vector3.new(2, 0, 2) -- posición relativa al jugador
local FOLLOW_RATE = 0.12                   -- intervalo de seguimiento
local JUMP_MIMIC = true                    -- si imita saltos

-- estado
local clonEnabled = false
local clonModel = nil
local mimicConn = nil
local methodUsed = nil

-- GUI botón
local function makeButton()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CloneToggleGui"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 36)
    btn.Position = UDim2.new(0, 12, 0, 120)
    btn.Text = "Clon: OFF"
    btn.BackgroundColor3 = Color3.fromRGB(200,50,50)
    btn.TextColor3 = Color3.fromRGB(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.AutoButtonColor = true
    btn.Parent = screenGui
    btn.Active = true
    btn.Draggable = true

    return btn
end

local button = makeButton()

-- helper limpiar clon
local function destroyClone()
    if mimicConn then
        mimicConn:Disconnect()
        mimicConn = nil
    end
    if clonModel and clonModel.Parent then
        pcall(function() clonModel:Destroy() end)
    end
    clonModel = nil
    methodUsed = nil
end

-- MÉTODO A: clonar Character (más fiel) ---------------------------------
local function tryMethodCloneCharacter()
    local char = LocalPlayer.Character
    if not char then return false, "no character" end
    local ok, clone = pcall(function() return char:Clone() end)
    if not ok or not clone then return false, "clone fail" end

    -- eliminar scripts locales/servidor del clon para evitar conflictos
    for _, v in ipairs(clone:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            pcall(function() v:Destroy() end)
        end
    end

    -- renombrar y positionar
    clone.Name = LocalPlayer.Name .. "_LocalClone"
    -- intentar poner en workspace y mover un poco
    clone.Parent = workspace
    local root = clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("Torso") or clone:FindFirstChild("UpperTorso")
    local myRoot = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
    if root and myRoot then
        root.CFrame = myRoot.CFrame * CFrame.new(FOLLOW_OFFSET)
    end

    return true, clone
end

-- MÉTODO B: crear modelo y aplicar HumanoidDescription -------------------
local function tryMethodHumanoidDescription()
    local success, desc = pcall(function()
        return Players:GetHumanoidDescriptionFromUserId(LocalPlayer.UserId)
    end)
    if not success or not desc then return false, "desc fail" end

    -- crear modelo limpio
    local model = Instance.new("Model")
    model.Name = LocalPlayer.Name .. "_LocalClone"
    model.Parent = workspace

    local hrp = Instance.new("Part")
    hrp.Name = "HumanoidRootPart"
    hrp.Size = Vector3.new(2,2,1)
    hrp.Anchored = false
    hrp.CanCollide = true
    local myRoot = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
    if myRoot then
        hrp.CFrame = myRoot.CFrame * CFrame.new(FOLLOW_OFFSET)
    else
        hrp.CFrame = CFrame.new(0,5,0)
    end
    hrp.Parent = model

    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = model

    -- intentar aplicar description (puede fallar en algunos entornos)
    local ok, err = pcall(function() humanoid:ApplyDescription(desc) end)
    if not ok then
        -- cleanup y fail
        pcall(function() model:Destroy() end)
        return false, "applydesc fail: "..tostring(err)
    end

    return true, model
end

-- MÉTODO C: clon visual simple (partes básicas) --------------------------
local function tryMethodVisualClone()
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local pos = (myRoot and myRoot.Position) and myRoot.Position + FOLLOW_OFFSET or Vector3.new(0,5,0)

    local mdl = Instance.new("Model")
    mdl.Name = LocalPlayer.Name .. "_LocalCloneVisual"
    mdl.Parent = workspace

    local torso = Instance.new("Part")
    torso.Name = "Torso"
    torso.Size = Vector3.new(2,2,1)
    torso.CFrame = CFrame.new(pos)
    torso.Anchored = false
    torso.CanCollide = false
    torso.Parent = mdl

    local head = Instance.new("Part")
    head.Name = "Head"
    head.Size = Vector3.new(1,1,1)
    head.CFrame = torso.CFrame * CFrame.new(0,1.5,0)
    head.Parent = mdl
    head.Anchored = false
    head.CanCollide = false

    local humanoid = Instance.new("Humanoid")
    humanoid.Parent = mdl

    return true, mdl
end

-- función para crear clon probando métodos
local function crearCloneConBackups()
    destroyClone()
    -- intentar A
    local ok, res = tryMethodCloneCharacter()
    if ok then
        methodUsed = "clone_character"
        clonModel = res
        warn("[Clon] Método A (clonar character) OK")
        return true
    else
        warn("[Clon] Método A falló:", res)
    end

    -- intentar B
    local ok2, res2 = tryMethodHumanoidDescription()
    if ok2 then
        methodUsed = "humanoid_description"
        clonModel = res2
        warn("[Clon] Método B (HumanoidDescription) OK")
        return true
    else
        warn("[Clon] Método B falló:", res2)
    end

    -- intentar C
    local ok3, res3 = tryMethodVisualClone()
    if ok3 then
        methodUsed = "visual_simple"
        clonModel = res3
        warn("[Clon] Método C (visual simple) OK")
        return true
    else
        warn("[Clon] Método C falló:", res3)
    end

    return false
end

-- función que hace que el clon siga y salte
local function startMimic()
    if not clonModel then return end
    local char = LocalPlayer.Character
    if not char then return end

    local humanoidPlayer = char:FindFirstChildOfClass("Humanoid")
    local playerRoot = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not playerRoot then return end

    -- obtener clon humanoid/root
    local cloneHum = clonModel:FindFirstChildOfClass("Humanoid")
    local cloneRoot = clonModel:FindFirstChild("HumanoidRootPart") or clonModel:FindFirstChild("Torso") or clonModel:FindFirstChild("UpperTorso")

    if not cloneRoot or not cloneHum then
        -- si no hay humanoid, no podemos imitar bien; igual intentar mover la raíz
        mimicConn = RunService.Heartbeat:Connect(function()
            if not clonModel or not clonModel.Parent then return end
            local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if myRoot and cloneRoot then
                local targetCFrame = myRoot.CFrame * CFrame.new(FOLLOW_OFFSET)
                cloneRoot.CFrame = cloneRoot.CFrame:Lerp(targetCFrame, 0.28)
            end
        end)
        return
    end

    -- si tenemos humanoid, usar MoveTo y Jump mimic
    mimicConn = RunService.Heartbeat:Connect(function()
        if not clonModel or not clonModel.Parent then
            mimicConn:Disconnect()
            return
        end
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myRoot and cloneHum and cloneRoot then
            -- seguir
            local targetPos = myRoot.Position + FOLLOW_OFFSET
            -- usar MoveTo con suavizado
            pcall(function() cloneHum:MoveTo(targetPos) end)

            -- imitar salto: si el jugador humanoid está jumping, activar Jump en clon
            if JUMP_MIMIC and humanoidPlayer and humanoidPlayer.Jump then
                cloneHum.Jump = true
            end
        end
    end)
end

-- Activar/Desactivar clon
local function toggleClone()
    if clonEnabled then
        clonEnabled = false
        destroyClone()
        button.Text = "Clon: OFF"
        button.BackgroundColor3 = Color3.fromRGB(200,50,50)
        print("[Clon] Desactivado")
        return
    end

    clonEnabled = true
    button.Text = "Clon: ON"
    button.BackgroundColor3 = Color3.fromRGB(50,200,50)
    print("[Clon] Intentando crear clon...")

    local ok = crearCloneConBackups()
    if not ok then
        warn("[Clon] No se pudo crear clon con ningún método.")
        clonEnabled = false
        button.Text = "Clon: OFF"
        button.BackgroundColor3 = Color3.fromRGB(200,50,50)
        return
    end

    -- empezar a imitar
    startMimic()
    print("[Clon] Activado. Método usado:", methodUsed)
end

-- conectar botón
button.MouseButton1Click:Connect(toggleClone)

-- si reaparece el character, reactivar automáticamente (opcional)
LocalPlayer.CharacterAdded:Connect(function()
    if clonEnabled then
        -- esperar un poco a que cargue el character
        task.wait(0.8)
        -- re-crear clon
        destroyClone()
        local ok = crearCloneConBackups()
        if ok then
            startMimic()
        end
    end
end)

-- info inicial
print("[Clon] Script cargado. Pulsa el botón para crear/activar tu clon (local).")
