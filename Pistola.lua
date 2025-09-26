local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Cargar y configurar pistola con disparos
local function crearPistolaFuncional()
    local success, pistola = pcall(function()
        return game:GetObjects('rbxassetid://6880366374')[1]
    end)
    
    if success and pistola then
        print("✅ Pistola cargada - añadiendo disparos...")
        
        pistola.Name = "PistolaQueDispara"
        pistola.CanBeDropped = false
        
        -- Añadir funcionalidad de disparo
        local scriptDisparo = Instance.new("Script")
        scriptDisparo.Name = "ControlDisparo"
        scriptDisparo.Parent = pistola
        
        -- Script de disparo optimizado para móvil
        scriptDisparo.Source = [[
            local tool = script.Parent
            local player = game.Players.LocalPlayer
            local debris = game:GetService("Debris")
            
            -- Función para crear efecto de bala
            function disparar()
                print("🔫 ¡PUM! Disparando...")
                
                -- Crear efecto visual de disparo
                local efecto = Instance.new("Part")
                efecto.Size = Vector3.new(0.2, 0.2, 3)
                efecto.BrickColor = BrickColor.new("Bright yellow")
                efecto.Material = Enum.Material.Neon
                efecto.Anchored = true
                efecto.CanCollide = false
                
                -- Posicionar frente al cañón
                local handle = tool:FindFirstChild("Handle")
                if handle then
                    efecto.CFrame = handle.CFrame * CFrame.new(0, 0, -2)
                else
                    efecto.CFrame = tool.Parent.Character.Head.CFrame * CFrame.new(0, 0, -3)
                end
                
                efecto.Parent = workspace
                
                -- Destruir después de un tiempo
                debris:AddItem(efecto, 0.2)
                
                -- Sonido de disparo (opcional)
                local sonido = Instance.new("Sound")
                sonido.SoundId = "rbxassetid://131147735"  -- Sonido de disparo genérico
                sonido.Volume = 0.5
                sonido.Parent = tool.Parent.Character.Head
                sonido:Play()
                debris:AddItem(sonido, 2)
            end
            
            -- Disparar al activar (toque en móvil)
            tool.Activated:Connect(function()
                disparar()
            end)
            
            -- Disparo automático cada 0.5 segundos si se mantiene presionado
            tool.Equipped:Connect(function()
                print("🎯 Pistola equipada - Toca la pantalla para disparar")
            end)
            
            tool.Unequipped:Connect(function()
                print("🔻 Pistola guardada")
            end)
        ]]
        
        pistola.Parent = LocalPlayer.Backpack
        print("✅ ¡Pistola lista para disparar!")
        return pistola
        
    else
        print("❌ Error cargando pistola")
        return nil
    end
end

-- Cargar cuando el jugador esté listo
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(2)
    crearPistolaFuncional()
end)

if LocalPlayer.Character then
    crearPistolaFuncional()
end

print("📱 Pistola con disparos cargada - Toca la pantalla para disparar!")
