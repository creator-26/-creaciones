-- 🌌 Aura Toggle Script (solo visible para ti)
-- ✅ Botón ON/OFF
-- ✅ Draggable
-- ✅ Auras azules en jugadores

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local GUI_NAME = "AuraToggleUI"

-- 🧹 Limpiar si ya existe
if game.CoreGui:FindFirstChild(GUI_NAME) then
    game.CoreGui[GUI_NAME]:Destroy()
end

-- 🖼️ Crear GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = GUI_NAME
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = game:GetService("CoreGui")

-- 🔘 Botón draggable
local button = Instance.new("TextButton")
button.Size = UDim2.new(0, 80, 0, 30)
button.Position = UDim2.new(0, 200, 0, 100)
button.BackgroundColor3 = Color3.fromRGB(200, 60, 60) -- rojo = OFF
button.TextColor3 = Color3.new(1, 1, 1)
button.Text = "Aura OFF"
button.Font = Enum.Font.SourceSansBold
button.TextSize = 18
button.Parent = screenGui
button.Active = true

-- 🔄 Draggable
local UserInputService = game:GetService("UserInputService")
do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        button.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = button.Position
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

-- ✨ Aura lógica
local enabled = false
local auras = {}

local function createAura(character)
    if not character or auras[character] then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp then
        local aura = Instance.new("SelectionSphere")
        aura.Adornee = hrp
        aura.Color3 = Color3.fromRGB(60, 150, 255) -- azul
        aura.Transparency = 0.5
        aura.Parent = hrp
        auras[character] = aura
    end
end

local function removeAura(character)
    if auras[character] then
        auras[character]:Destroy()
        auras[character] = nil
    end
end

local function toggleAuras(state)
    if state then
        -- activar
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                createAura(plr.Character)
            end
            plr.CharacterAdded:Connect(function(char)
                if enabled then createAura(char) end
            end)
        end
    else
        -- desactivar
        for char, aura in pairs(auras) do
            removeAura(char)
        end
    end
end

-- 🔘 Botón ON/OFF
button.MouseButton1Click:Connect(function()
    enabled = not enabled
    if enabled then
        button.Text = "Aura ON"
        button.BackgroundColor3 = Color3.fromRGB(60, 200, 60) -- verde
    else
        button.Text = "Aura OFF"
        button.BackgroundColor3 = Color3.fromRGB(200, 60, 60) -- rojo
    end
    toggleAuras(enabled)
end)
