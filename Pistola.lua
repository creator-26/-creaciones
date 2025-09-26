local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Cargar pistola optimizada para móvil
local function cargarPistolaMobile()
    local success, pistola = pcall(function()
        return game:GetObjects('rbxassetid://6880366374')[1]
    end)
    
    if success and pistola then
        print("✅ Pistola lista para móvil")
        
        pistola.Name = "PistolaMobile"
        pistola.Parent = LocalPlayer.Backpack
        
        -- Funcionalidad simple para touch
        if pistola:IsA("Tool") then
            pistola.Activated:Connect(function()
                print("📱 ¡Disparo desde celular!")
                -- Aquí irían efectos de disparo simples
            end)
        end
        
        return pistola
    else
        print("❌ Error cargando pistola")
        return nil
    end
end

-- Cargar cuando el jugador esté listo
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(3)  -- Esperar más tiempo en móvil
    cargarPistolaMobile()
end)

if LocalPlayer.Character then
    cargarPistolaMobile()
end

print("📱 Pistola cargada para celular - Revisa tu inventario")
