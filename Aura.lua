-- 🌌 Aura Azul Solo Visible para Ti con Botón ON/OFF
-- 📌 Pon este LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local auraEnabled = true -- por defecto el aura está activada

-- función para aplicar aura
local function applyAura(character)
    if not character or not auraEnabled then return end
    if character:FindFirstChild("HumanoidRootPart") then
        -- evitar duplicados
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

-- quitar aura
local function removeAura(character)
    if character and character:FindFirstChild("AuraHighlight") then
        character.AuraHighlight:Destroy()
    end
end

-- poner aura a todos los jugadores menos a ti
local function setupPlayer(plr)
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function(char)
            task.wait(1)
            if auraEnabled then
                applyAura(char)
            end
        end)
        if plr.Character then
            if auraEnabled then
                applyAura(plr.Character)
            end
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
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.ResetOnSpawn = false

local Button = Instance.new("TextButton")
Button.Size = UDim2.new(0, 80, 0, 30)
Button.Position = UDim2.new(0.05, 0, 0.1, 0)
Button.Text = "Aura: ON"
Button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
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
        Button.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
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
            if plr ~= LocalPlayer and plr.Character then
                removeAura(plr.Character)
            end
        end
    end
end)
