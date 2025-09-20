-- fps_counter_exploit.lua
-- Contador de FPS para ejecutar desde un exploit (inyección en cliente).
-- Hecho para uso personal en tu cliente. No uses esto para molestar a otros.
-- Toggle: RightShift para mostrar/ocultar. Evita crear duplicados si ya existe.

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- ID único para el GUI para evitar duplicados
local GUI_NAME = "AlexFPS_Overlay_v1"

-- Si ya existe, elimínalo (esto ayuda cuando recargas el script)
if game.CoreGui:FindFirstChild(GUI_NAME) then
    game.CoreGui[GUI_NAME]:Destroy()
end

-- Crear ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.Parent = game.CoreGui

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 130, 0, 48)
frame.Position = UDim2.new(0, 10, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
frame.BackgroundTransparency = 0.15
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

-- Label de FPS
local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -10, 1, -10)
fpsLabel.Position = UDim2.new(0, 8, 0, 3)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Font = Enum.Font.GothamBold
fpsLabel.TextSize = 20
fpsLabel.Text = "FPS: ..."
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Parent = frame

-- Small info text (optional)
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -10, 0, 16)
infoLabel.Position = UDim2.new(0, 8, 1, -22)
infoLabel.BackgroundTransparency = 1
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 12
infoLabel.Text = "Toggle: RightShift"
infoLabel.TextColor3 = Color3.fromRGB(200,200,200)
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = frame

-- Variables de FPS
local lastTime = tick()
local frames = 0
local fps = 0
local visible = true

-- --- Inicio: código de arrastrar (péguelo después de crear 'frame' y los labels) ---
local dragging = false
local dragInput, dragStart, startPos
local UIS = game:GetService("UserInputService")

local function update(input)
    local delta = input.Position - dragStart
    frame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        dragInput = input
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
-- --- Fin: código de arrastrar ---
-- Conexiones (para poder desconectar si es necesario)
local connections = {}

table.insert(connections, RunService.RenderStepped:Connect(function()
    frames = frames + 1
    local now = tick()
    if now - lastTime >= 1 then
        fps = frames
        frames = 0
        lastTime = now
        fpsLabel.Text = "FPS: " .. tostring(fps)

        -- Color dinámico
        if fps >= 50 then
            fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 0) -- verde
        elseif fps >= 30 then
            fpsLabel.TextColor3 = Color3.fromRGB(255, 200, 0) -- amarillo
        else
            fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- rojo
        end
    end
end))

-- Toggle con RightShift
table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        visible = not visible
        frame.Visible = visible
    end
end))

-- Función para limpiar todo si quieres eliminar el GUI desde el script
local function cleanup()
    for _,c in pairs(connections) do
        if c.Disconnect then
            pcall(function() c:Disconnect() end)
        end
    end
    if screenGui and screenGui.Parent then
        pcall(function() screenGui:Destroy() end)
    end
end

-- Exponer cleanup por si lo quieres llamar manualmente desde consola:
_G.AlexFPS_Cleanup = cleanup

-- Mensaje opcional en output (no molesta en pantalla)
print("[AlexFPS] Contador cargado. Toggle: RightShift. Para eliminar: _G.AlexFPS_Cleanup()")
