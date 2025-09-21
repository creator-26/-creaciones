-- 🔥 Alex_Minimap Mejorado 🔥
-- Triángulo central SIEMPRE visible, rota con la cámara.
-- Optimizado + draggable + suavizado.

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local GUI_NAME = "Alex_Minimap_v3"

-- CONFIG
local MAP_SIZE = 140
local MAP_RANGE = 120
local DOT_SIZE = 6
local updateRate = 0.08
local smoothFactor = 0.25

-- cleanup anterior
if game.CoreGui:FindFirstChild(GUI_NAME) then
    game.CoreGui[GUI_NAME]:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Marco minimapa
local mapFrame = Instance.new("Frame")
mapFrame.Size = UDim2.new(0, MAP_SIZE, 0, MAP_SIZE)
mapFrame.Position = UDim2.new(0, 30, 0, 90)
mapFrame.Active = true
mapFrame.BackgroundColor3 = Color3.fromRGB(22,22,22)
mapFrame.BackgroundTransparency = 0.1
mapFrame.BorderSizePixel = 0
mapFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 16)
uiCorner.Parent = mapFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Thickness = 2
uiStroke.Color = Color3.fromRGB(0, 255, 120)
uiStroke.Parent = mapFrame

local dotsFolder = Instance.new("Folder")
dotsFolder.Parent = mapFrame

-- 🚩 Tu triángulo central
local tri = Instance.new("ImageLabel")
tri.Size = UDim2.new(0, 18, 0, 18)
tri.AnchorPoint = Vector2.new(0.5, 0.5)
tri.Position = UDim2.new(0.5, 0, 0.5, 0) -- centro exacto
tri.BackgroundTransparency = 1
tri.Image = "rbxassetid://14590309638" -- cambia si quieres otro
tri.ImageColor3 = Color3.fromRGB(0, 255, 120)
tri.Parent = mapFrame

-- draggable
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

-- Dots
local playerDots = {}
local half = MAP_SIZE / 2

local function lerp(a, b, t)
    return a + (b - a) * t
end

local function createDot()
    local dot = Instance.new("Frame")
    dot.Size = UDim2.new(0, DOT_SIZE, 0, DOT_SIZE)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    dot.BorderSizePixel = 0
    dot.Position = UDim2.new(0.5, 0.5)
    dot.Parent = dotsFolder
    return dot
end

-- loop
task.spawn(function()
    while task.wait(updateRate) do
        if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            continue
        end
        local myRoot = LocalPlayer.Character.HumanoidRootPart
        local myPos = myRoot.Position
        local look = Camera.CFrame.LookVector
        tri.Rotation = math.deg(math.atan2(-look.X, -look.Z))

        local seen = {}
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local hrp = plr.Character.HumanoidRootPart
                local dx, dz = hrp.Position.X - myPos.X, hrp.Position.Z - myPos.Z
                local dist = math.sqrt(dx*dx + dz*dz)
                if dist < MAP_RANGE then
                    local px = half + (dx / MAP_RANGE) * half
                    local py = half + (-dz / MAP_RANGE) * half
                    if not playerDots[plr] then
                        playerDots[plr] = createDot()
                    end
                    local cur = playerDots[plr].Position
                    local newX = lerp(cur.X.Offset, px, smoothFactor)
                    local newY = lerp(cur.Y.Offset, py, smoothFactor)
                    playerDots[plr].Position = UDim2.new(0, newX, 0, newY)
                    playerDots[plr].Visible = true
                    seen[plr] = true
                end
            end
        end
        for plr, dot in pairs(playerDots) do
            if not seen[plr] then dot.Visible = false end
        end
    end
end)
