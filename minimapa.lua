-- minimap.lua
-- Minimapa optimizado, draggable, con triángulo central que rota,
-- dots para jugadores cercanos y suavizado (lerp).
-- Uso personal en cliente. No molestar a otros jugadores.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local GUI_NAME = "Alex_Minimap_v2"

-- CONFIG: ajusta a tu gusto
local MAP_SIZE = 150             -- ancho/alto del minimapa (px)
local MAP_RANGE = 120            -- rango en studs que muestra el minimapa (desde el centro hasta el borde)
local DOT_SIZE = 6               -- tamaño puntos rojos (px)
local PLAYER_ICON_SIZE = 14      -- tamaño icono jugador (px)
local updateRate = 0.08          -- tiempo entre actualizaciones (s). Más alto = menos consumo
local smoothFactor = 0.28        -- lerp factor (0..1) para suavizado de movimiento (mayor = más rápido)

-- Limpia instancia previa
if game.CoreGui:FindFirstChild(GUI_NAME) then
    pcall(function() game.CoreGui[GUI_NAME]:Destroy() end)
end
if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
    if LocalPlayer.PlayerGui:FindFirstChild(GUI_NAME) then
        pcall(function() LocalPlayer.PlayerGui[GUI_NAME]:Destroy() end)
    end
end

-- ScreenGui (parent seguro: PlayerGui si existe, si no CoreGui)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
if LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui") then
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
else
    screenGui.Parent = game.CoreGui
end

-- Frame del minimapa (draggable manual)
local mapFrame = Instance.new("Frame")
mapFrame.Name = "MiniMap"
mapFrame.Size = UDim2.new(0, MAP_SIZE, 0, MAP_SIZE)
mapFrame.Position = UDim2.new(0, 20, 0, 80)
mapFrame.Active = true
mapFrame.BorderSizePixel = 0
mapFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
mapFrame.BackgroundTransparency = 0.12
mapFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 16)
uiCorner.Parent = mapFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(0, 200, 150)
uiStroke.Parent = mapFrame

-- Contenedor para dots (players)
local dotsFolder = Instance.new("Folder")
dotsFolder.Name = "Dots"
dotsFolder.Parent = mapFrame

-- Icono central (jugador) - usamos ImageLabel para triángulo
local playerIcon = Instance.new("Frame")
playerIcon.Size = UDim2.new(0, PLAYER_ICON_SIZE, 0, PLAYER_ICON_SIZE)
playerIcon.AnchorPoint = Vector2.new(0.5, 0.5)
playerIcon.Position = UDim2.new(0.5, 0.5, 0.5, 0) -- centro
playerIcon.BackgroundTransparency = 1
playerIcon.Parent = mapFrame

local tri = Instance.new("ImageLabel")
tri.Size = UDim2.new(1, 0, 1, 0)
tri.AnchorPoint = Vector2.new(0.5, 0.5)
tri.Position = UDim2.new(0.5, 0, 0.5, 0)
tri.BackgroundTransparency = 1
-- Imagen triangular ligera (si no carga, se verá vacío; puedes cambiar por otro asset)
tri.Image = "rbxassetid://14590309638" 
tri.ImageColor3 = Color3.fromRGB(0, 255, 120)
tri.Rotation = 0
tri.Parent = playerIcon

-- Diccionarios de datos
local playerDots = {}    -- player => {frame = Frame, targetPos = Vector2}
local visiblePlayers = {} -- track de players vistos

-- util: lerp
local function lerp(a, b, t)
    return a + (b - a) * t
end

-- util: clamp in pixels
local function clampPixel(x, y, half)
    -- clamp inside square, or keep inside circle if you want circle
    x = math.clamp(x, -half, half)
    y = math.clamp(y, -half, half)
    return x, y
end

-- Crear dot para jugador
local function createDotFor(player)
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, DOT_SIZE, 0, DOT_SIZE)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    dot.BorderSizePixel = 0
    dot.Position = UDim2.new(0.5, 0.5) -- centro inicial
    dot.Parent = dotsFolder
    return {frame = dot, target = Vector2.new(MAP_SIZE/2, MAP_SIZE/2)}
end

-- Remove dot when player leaves
Players.PlayerRemoving:Connect(function(plr)
    if playerDots[plr] then
        pcall(function() playerDots[plr].frame:Destroy() end)
        playerDots[plr] = nil
    end
end)

-- Draggable (so puedas mover el mapa)
do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        mapFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    mapFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mapFrame.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

-- Función principal de actualización (optimizada)
local half = MAP_SIZE / 2
local studsPerPixel = MAP_RANGE / half -- studs that correspond to half map (adjusted below)

-- Nota: convertimos posiciones a pixeles: px = half + (dx / MAP_RANGE) * half
-- Si player beyond MAP_RANGE -> ocultamos (o lo clamp a borde)

task.spawn(function()
    while true do
        local waitTime = updateRate
        task.wait(waitTime)

        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            -- si no estás con character, saltar esta ronda
            continue
        end

        local myRoot = LocalPlayer.Character.HumanoidRootPart
        local myPos = myRoot.Position
        local camLook = Camera and Camera.CFrame and Camera.CFrame.LookVector or Vector3.new(0,0,-1)

        -- Rotar triángulo según la cámara (para que apunte hacia donde miras)
        -- Convertir lookVector a ángulo en grados: usamos X,Z
        local yaw = math.deg(math.atan2(-camLook.X, -camLook.Z)) -- ajustado para que 0 deg sea "arriba"
        tri.Rotation = yaw

        -- Recorremos players
        local players = Players:GetPlayers()
        local seen = {}

        for _, plr in ipairs(players) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                local dx = hrp.Position.X - myPos.X
                local dz = hrp.Position.Z - myPos.Z
                local dist = math.sqrt(dx*dx + dz*dz)

                -- Si está fuera del MAP_RANGE, lo ocultamos
                if dist > MAP_RANGE then
                    if playerDots[plr] and playerDots[plr].frame then
                        playerDots[plr].frame.Visible = false
                    end
                else
                    -- calcular pos en pixeles relativo al centro
                    -- proyectamos dx,dz a pixels: px = half + (dx / MAP_RANGE) * half
                    local px = half + (dx / MAP_RANGE) * half
                    local py = half + (-dz / MAP_RANGE) * half -- invertimos z para que adelante sea arriba

                    -- clamp dentro del cuadrado del minimapa
                    local cx, cy = clampPixel(px - half, py - half, half) -- relative to center
                    local finalX = half + cx
                    local finalY = half + cy

                    if not playerDots[plr] then
                        playerDots[plr] = createDotFor(plr)
                        -- inicializamos la posición "target" en pixels
                        playerDots[plr].target = Vector2.new(finalX, finalY)
                        playerDots[plr].frame.Position = UDim2.new(0, finalX, 0, finalY)
                    else
                        playerDots[plr].frame.Visible = true
                        -- suavizado: interpolamos la posición actual hacia la target en pixeles
                        local cur = playerDots[plr].frame.Position
                        -- cur.X.Offset y cur.Y.Offset son los pixels actuales
                        local newX = lerp(cur.X.Offset, finalX, smoothFactor)
                        local newY = lerp(cur.Y.Offset, finalY, smoothFactor)
                        playerDots[plr].frame.Position = UDim2.new(0, newX, 0, newY)
                    end
                    seen[plr] = true
                end
            end
        end

        -- Ocultar/limpiar dots de players que ya no están cerca o se fueron
        for plr, data in pairs(playerDots) do
            if not seen[plr] then
                if data.frame then
                    data.frame.Visible = false
                end
            end
        end
    end
end)

-- Exponer cleanup por si quieres eliminar el minimapa
_G.AlexMinimap_Cleanup = function()
    pcall(function() screenGui:Destroy() end)
    playerDots = {}
    print("[AlexMinimap] Cleanup ejecutado.")
end

print("[AlexMinimap] Cargado. Ejecuta _G.AlexMinimap_Cleanup() para quitarlo.")
