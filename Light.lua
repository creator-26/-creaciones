-- Linterna universal (ejecutor / script hub)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local backpack = player:WaitForChild("Backpack")

-- ID de tu linterna
local FLASHLIGHT_ID = 5699144447

-- Carga o clona la linterna al Backpack
local flashlightTool
local ok, model = pcall(function()
    return game:GetObjects("rbxassetid://"..FLASHLIGHT_ID)[1]
end)

if ok and model then
    if not model:IsA("Tool") then
        local tool = Instance.new("Tool")
        tool.Name = "Flashlight"
        tool.RequiresHandle = true

        local handle = Instance.new("Part")
        handle.Name = "Handle"
        handle.Size = Vector3.new(0.4,0.8,0.4)
        handle.CanCollide = false
        handle.Anchored = false
        handle.Parent = tool

        model.Parent = handle
        model:SetPrimaryPartCFrame(handle.CFrame)

        flashlightTool = tool
    else
        flashlightTool = model
        flashlightTool.Name = "Flashlight"
    end

    flashlightTool.Parent = backpack
else
    warn("No se pudo cargar la linterna, usando un cubo simple.")
    flashlightTool = Instance.new("Tool")
    flashlightTool.Name = "Flashlight"
    flashlightTool.RequiresHandle = true

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.4,0.8,0.4)
    handle.CanCollide = false
    handle.Anchored = false
    handle.Parent = flashlightTool

    flashlightTool.Parent = backpack
end

-- Luz
local light = handle:FindFirstChildWhichIsA("PointLight")

if not light then
    light = Instance.new("PointLight")  -- luz esférica, tipo lámpara
    light.Brightness = 5     -- puedes subir/bajar
    light.Range = 40    -- cerca del centro, no tan lejos
    light.Enabled = false
    light.Parent = handle
end

local on = false
local function setLight(state)
    on = state
    light.Enabled = on
end

-- Al equipar la lámpara, se enciende
flashlightTool.Equipped:Connect(function()
    setLight(true)
end)

-- Al guardarla, se apaga
flashlightTool.Unequipped:Connect(function()
    setLight(false)
end)

-- No usamos Activated; la lámpara no cambia con click
flashlightTool.Activated:Connect(function() end)
