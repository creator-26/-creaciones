-- Mapa minimapa para Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Crear el minimapa
local function createMinimap()
    -- Crear ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MinimapGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Contenedor principal del minimapa (círculo)
    local minimapFrame = Instance.new("Frame")
    minimapFrame.Name = "Minimap"
    minimapFrame.Size = UDim2.new(0, 200, 0, 200)
    minimapFrame.Position = UDim2.new(0, 20, 0, 20)
    minimapFrame.BackgroundColor3 = Color3.new(0, 0, 0) -- Fondo negro
    minimapFrame.BorderSizePixel = 2
    minimapFrame.BorderColor3 = Color3.new(1, 1, 1)
    minimapFrame.Parent = screenGui
    
    -- Hacer el frame circular
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0) -- Hace el frame completamente circular
    corner.Parent = minimapFrame
    
    -- Punto central (jugador local)
    local playerDot = Instance.new("Frame")
    playerDot.Name = "PlayerDot"
    playerDot.Size = UDim2.new(0, 8, 0, 8)
    playerDot.AnchorPoint = Vector2.new(0.5, 0.5)
    playerDot.Position = UDim2.new(0.5, 0, 0.5, 0)
    playerDot.BackgroundColor3 = Color3.new(0, 1, 0) -- Verde para el jugador local
    playerDot.BorderSizePixel = 0
    playerDot.Parent = minimapFrame
    
    -- Hacer el punto circular
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = playerDot
    
    return minimapFrame, screenGui
end

-- Función para crear puntos de otros jugadores
local function createPlayerDot(playerName)
    local dot = Instance.new("Frame")
    dot.Name = playerName
    dot.Size = UDim2.new(0, 6, 0, 6)
    dot.AnchorPoint = Vector2.new(0.5, 0.5)
    dot.BackgroundColor3 = Color3.new(1, 0, 0) -- Rojo para otros jugadores
    dot.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = dot
    
    return dot
end

-- Función principal para actualizar el minimapa
local function setupMinimap()
    local minimapFrame, screenGui = createMinimap()
    local localPlayer = Players.LocalPlayer
    local playerDots = {}
    
    -- Crear puntos para todos los jugadores existentes
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local dot = createPlayerDot(player.Name)
            dot.Parent = minimapFrame
            playerDots[player.Name] = dot
        end
    end
    
    -- Conectar evento para nuevos jugadores
    Players.PlayerAdded:Connect(function(player)
        if player ~= localPlayer then
            local dot = createPlayerDot(player.Name)
            dot.Parent = minimapFrame
            playerDots[player.Name] = dot
        end
    end)
    
    -- Conectar evento para jugadores que salen
    Players.PlayerRemoving:Connect(function(player)
        if playerDots[player.Name] then
            playerDots[player.Name]:Destroy()
            playerDots[player.Name] = nil
        end
    end)
    
    -- Función para actualizar posiciones
    local function updateMinimap()
        local localCharacter = localPlayer.Character
        if not localCharacter then return end
        
        local localHumanoidRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
        if not localHumanoidRootPart then return end
        
        local localPosition = localHumanoidRootPart.Position
        local mapRadius = minimapFrame.AbsoluteSize.X / 2
        local maxDistance = 100 -- Distancia máxima para mostrar jugadores completos
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= localPlayer and playerDots[player.Name] then
                local character = player.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local playerPosition = humanoidRootPart.Position
                        local offset = playerPosition - localPosition
                        
                        -- Calcular distancia y dirección
                        local distance = offset.Magnitude
                        local direction = offset.Unit
                        
                        -- Si está dentro del rango máximo, mostrar en posición relativa
                        if distance <= maxDistance then
                            local xPos = (direction.X * distance / maxDistance) * mapRadius
                            local zPos = (direction.Z * distance / maxDistance) * mapRadius
                            playerDots[player.Name].Position = UDim2.new(0.5, xPos, 0.5, zPos)
                            playerDots[player.Name].Visible = true
                        else
                            -- Si está fuera del rango, mostrar en el borde
                            local edgeX = direction.X * mapRadius
                            local edgeZ = direction.Z * mapRadius
                            playerDots[player.Name].Position = UDim2.new(0.5, edgeX, 0.5, edgeZ)
                            playerDots[player.Name].Visible = true
                        end
                    end
                else
                    playerDots[player.Name].Visible = false
                end
            end
        end
    end
    
    -- Conectar al bucle de renderizado
    RunService.RenderStepped:Connect(updateMinimap)
end

-- Inicializar el minimapa cuando el jugador se une
Players.LocalPlayer:WaitForChild("PlayerGui")
setupMinimap()