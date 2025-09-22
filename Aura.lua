-- 🌌 Aura Azul Solo Visible para Ti
-- 📌 Pon este LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- función para aplicar aura
local function applyAura(character)
    if not character then return end
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
