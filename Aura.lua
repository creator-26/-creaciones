-- Script de Aura con Highlight (se ve como un borde alrededor del personaje)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Función para poner aura a un personaje
local function addAuraToCharacter(character)
    -- Si ya tiene un highlight viejo, lo borra
    if character:FindFirstChild("Aura") then
        character.Aura:Destroy()
    end

    -- Crea el highlight
    local highlight = Instance.new("Highlight")
    highlight.Name = "Aura"
    highlight.FillTransparency = 1 -- el centro transparente (no bola)
    highlight.OutlineTransparency = 0 -- borde visible
    highlight.OutlineColor = Color3.fromRGB(0, 170, 255) -- azul clarito
    highlight.Adornee = character
    highlight.Parent = character
end

-- Detecta cuando entra un jugador nuevo
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if player ~= LocalPlayer then -- no aplicárselo a uno mismo
            addAuraToCharacter(character)
        end
    end)
end)

-- Aplica aura a los que ya están dentro del juego
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        addAuraToCharacter(player.Character)
    end
end
