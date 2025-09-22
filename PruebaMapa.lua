-- Mapa minimapa para Roblox con triángulo y desplazamiento táctil
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Crear el minimapa
local function createMinimap()
    -- Crear ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "MinimapGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Contenedor principal del minimapa (círculo más pequeño)
    local minimapFrame = Instance.new("Frame")
    minimapFrame.Name = "Minimap"
    minimapFrame.Size = UDim2.new(0, 150, 0, 150) -- Más pequeño
    minimapFrame.Position = UDim2.new(0, 20, 0, 20)
    minimapFrame.BackgroundColor3 = Color3.new(0, 0, 0) -- Fondo negro
    minimapFrame.BorderSizePixel = 2
    minimapFrame.BorderColor3 = Color3.new(1, 1, 1)
    minimapFrame.Parent = screenGui
    
    -- Hacer el frame circular
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0)
    corner.Parent = minimapFrame
    
    -- Punto central como triángulo (jugador local)
    local playerTriangle = Instance.new("Frame")
    playerTriangle.Name = "PlayerTriangle"
    playerTriangle.Size = UDim2.new(0, 12, 0, 12)
    playerTriangle.AnchorPoint = Vector2.new(0.5, 0.5)
    playerTriangle.Position = UDim2.new(0.5, 0, 0.5, 0)
    playerTriangle.BackgroundColor3 = Color3.new(0, 1, 0) -- Verde
    playerTriangle.BorderSizePixel = 0
    playerTriangle.Parent = minimapFrame
    
    -- Crear forma de triángulo usando UIStroke y rotación
    local triangleCorner = Instance.new("UICorner")
    triangleCorner.CornerRadius = UDim.new(0, 0)
    triangleCorner.Parent = playerTriangle
    
    -- Rotar para forma triangular
    playerTriangle.Rotation = 45
    
    -- Hacer que el triángulo apunte hacia arriba
    local trianglePointer = Instance.new("Frame")
    trianglePointer.Name = "TrianglePointer"
    trianglePointer.Size = UDim2.new(0, 6, 0, 6)
    trianglePointer.Position = UDim2.new(0.5, 0, 0.5, 0)
    trianglePointer.AnchorPoint = Vector2.new(0.5, 0.5)
    trianglePointer.BackgroundColor3 = Color3.new(0, 1, 0)
    trianglePointer.BorderSizePixel = 0
    trianglePointer.Parent = playerTriangle
    
    local pointerCorner = Instance.new("UICorner")
    pointerCorner.CornerRadius = UDim.new(0, 0)
    pointerCorner.Parent = trianglePointer
    
    -- Hacer el minimapa arrastrable
    local isDragging = false
    local dragStartPosition = Vector2.new(0, 0)
    local mapStartPosition = UDim2.new(0, 0, 0, 0)
    
    -- Función para manejar el inicio del arrastre
    local function onInputBegan(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local mapPos = Vector2.new(minimapFrame.AbsolutePosition.X, minimapFrame.AbsolutePosition.Y)
            local mapSize = Vector2.new(minimapFrame.AbsoluteSize.X, minimapFrame.AbsoluteSize.Y)
            
            -- Verificar si el clic está dentro del minimapa
            if mousePos.X >= mapPos.X and mousePos.X <= mapPos.X + mapSize.X and
               mousePos.Y >= mapPos.Y and mousePos.Y <= mapPos.Y + mapSize.Y then
                isDragging = true
                dragStartPosition = mousePos
                mapStartPosition = minimapFrame.Position
            end
        end
    end
    
    -- Función para manejar el arrastre
    local function onInputChanged(input, gameProcessed)
        if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local delta = mousePos - dragStartPosition
            
            -- Calcular nueva posición manteniéndolo dentro de la pantalla
            local newX = math.clamp(mapStartPosition.X.Offset + delta.X, 0, screenGui.AbsoluteSize.X - minimapFrame.AbsoluteSize.X)
            local newY = math.clamp(mapStartPosition.Y.Offset + delta.Y, 0, screenGui.AbsoluteSize.Y - minimapFrame.AbsoluteSize.Y)
            
            minimapFrame.Position = UDim2.new(0, newX, 0, newY)
        end
    end
    
    -- Función para manejar el fin del arrastre
    local function onInputEnded(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end
    
    -- Conectar eventos de input
    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
    UserInputService.InputEnded:Connect(onInputEnded)
    
    return minimapFrame, screenGui
end

-- Función para crear puntos de otros jugadores (círculos rojos)
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
        
        -- Actualizar rotación del triángulo según la dirección del jugador
        local playerTriangle = minimapFrame:FindFirstChild("PlayerTriangle")
        if playerTriangle then
            local camera = workspace.CurrentCamera
            if camera then
                -- Calcular ángulo de rotación basado en la cámara
                local cameraCFrame = camera.CFrame
                local lookVector = cameraCFrame.LookVector
                local angle = math.atan2(lookVector.X, lookVector.Z) * (180 / math.pi)
                playerTriangle.Rotation = angle + 45 -- Ajustar para que apunte correctamente
            end
        end
        
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
