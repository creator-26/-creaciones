-- Lámpara universal (ejecutor / script hub)
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- ID de tu lámpara
local LAMP_ID = 5699144447

-- Carga o clona la lámpara al Backpack
local lampTool
local ok, model = pcall(function()
    return game:GetObjects("rbxassetid://"..LAMP_ID)[1]
end)

if ok and model then
    if not model:IsA("Tool") then
        local tool = Instance.new("Tool")
        tool.Name = "Lamp"
        tool.RequiresHandle = true

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.4, 0.8, 0.4)
        handle.CanCollide = false
        handle.Anchored = false
        handle.Parent = tool

        model.Parent = handle
        if model.PrimaryPart then
            model:SetPrimaryPartCFrame(handle.CFrame)
        end

        lampTool = tool
    else
        lampTool = model
        lampTool.Name = "Lamp"
    end

    lampTool.Parent = backpack
else
    warn("No se pudo cargar la lámpara, usando un cubo simple.")
    lampTool = Instance.new("Tool")
    lampTool.Name = "Lamp"
    lampTool.RequiresHandle = true

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.4, 0.8, 0.4)
    handle.CanCollide = false
    handle.Anchored = false
    handle.Parent = lampTool

    lampTool.Parent = backpack
end

-- ================== LUZ DE LA LÁMPARA ==================

-- Asegúrate de tener Handle (si no existe, lo creamos)
local handle = lampTool:FindFirstChild("Handle")
if not handle then
    handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.4, 0.8, 0.4)
    handle.CanCollide = false
    handle.Anchored = false
    handle.Parent = lampTool
end

-- Busca la luz ORIGINAL del modelo en todo el Tool
local light = lampTool:FindFirstChildWhichIsA("PointLight", true)
    or lampTool:FindFirstChildWhichIsA("SpotLight", true)

-- Si la luz está dentro del modelo, no la destruimos; solo la usamos.
if not light then
    -- Si el modelo NO tenía luz, creamos una PointLight de respaldo
    light = Instance.new("PointLight")
    light.Parent = handle
end

-- Ajustes de lámpara (aquí controlas brillo y rango)
light.Brightness = 6    -- sube/baja a tu gusto
light.Range = 45        -- cuánto ilumina alrededor
light.Enabled = false   -- empieza apagada

-- ================== ENCENDER / APAGAR ==================

local on = false
local function setLight(state)
    on = state
    light.Enabled = on
end

-- Al equipar la lámpara en la mano, se enciende
lampTool.Equipped:Connect(function()
    setLight(true)
end)

-- Al guardarla, se apaga
lampTool.Unequipped:Connect(function()
    setLight(false)
end)

-- No queremos modo linterna al hacer click
lampTool.Activated:Connect(function()
    -- vacío a propósito
end)
