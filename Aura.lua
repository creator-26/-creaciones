-- 🌌 Aura Azul Solo Visible para Ti
-- 📌 Pon este LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local auraEnabled = true -- por defecto activado

-- función para aplicar aura
local function applyAura(character)
    if not character or not auraEnabled then return end
    if character:FindFirstChild("HumanoidRootPart") then
        -- si ya tiene aura, evitar duplicados
        if not character:FindFirstChild("AuraHighlight") then
            local aura = Instance.new("Highlight")
            aura.Name = "AuraHighlight"
            aura.Adornee = character
            aura.FillColor = Color3.fromRGB(0, 120, 255) -- azul
            aura.OutlineColor = Color3.fromRGB(255, 255, 255)
            aura.FillTransparency = 0.7
            aura.OutlineTransparency = 0
            aura.Parent = character
        end
    end
end

-- poner aura a todos los jugadores menos a ti
local function setupPlayer(plr)
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function(char)
            task.wait(1) -- esperar a que cargue el modelo
            applyAura(char)
        end)
        if plr.Character then
            applyAura(plr.Character)
        end
    end
end

-- inicial
for _, plr in ipairs(Players:GetPlayers()) do
    setupPlayer(plr)
end

-- nuevos jugadores
Players.PlayerAdded:Connect(setupPlayer)

-------------------------------------------------
-- 🔘 BOTÓN ON/OFF (movible)
-------------------------------------------------
local function createButton()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AuraToggleUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0, 80, 0, 30)
    Button.Position = UDim2.new(0.05, 0, 0.1, 0)
    Button.Text = "Aura: ON"
    Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Font = Enum.Font.SourceSansBold
    Button.TextSize = 18
    Button.Parent = ScreenGui
    Button.Active = true
    Button.Draggable = true -- se puede mover el botón

    -- acción del botón
    Button.MouseButton1Click:Connect(function()
        auraEnabled = not auraEnabled
        if auraEnabled then
            Button.Text = "Aura: ON"
            Button.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
            -- reactivar auras
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character then
                    applyAura(plr.Character)
                end
            end
        else
            Button.Text = "Aura: OFF"
            Button.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            -- borrar todas las auras
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("AuraHighlight") then
                    plr.Character.AuraHighlight:Destroy()
                end
            end
        end
    end)
end

-- asegurar que el PlayerGui cargue primero
if LocalPlayer:FindFirstChild("PlayerGui") then
    createButton()
else
    LocalPlayer.CharacterAdded:Wait()
    task.wait(1)
    createButton()
end
