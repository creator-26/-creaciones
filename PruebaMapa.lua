-- SUPER MAPA PROFESIONAL PARA ROBLOX
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

-- Configuración del mapa
local MAP_CONFIG = {
    Size = UDim2.new(0, 220, 0, 220),
    Position = UDim2.new(0, 25, 0, 25),
    BackgroundColor = Color3.fromRGB(20, 20, 30),
    BorderColor = Color3.fromRGB(0, 200, 255),
    BorderSize = 3,
    CornerRadius = 1,
    MaxDistance = 150,
    PulseEffect = true,
    DynamicLighting = true,
    ZoomLevels = {0.5, 0.8, 1.0, 1.5, 2.0},
    CurrentZoom = 1
}

-- Colores profesionales
local COLORS = {
    Player = Color3.fromRGB(0, 255, 150),        -- Verde neón para ti
    Allies = Color3.fromRGB(0, 180, 255),        -- Azul para aliados
    Enemies = Color3.fromRGB(255, 80, 80),       -- Rojo para enemigos
    Neutral = Color3.fromRGB(255, 200, 0),       -- Amarillo para neutrales
    Objectives = Color3.fromRGB(255, 0, 200),    -- Rosa para objetivos
    Background = Color3.fromRGB(20, 20, 30),     -- Fondo oscuro
    Border = Color3.fromRGB(0, 200, 255),        -- Borde azul neón
    Grid = Color3.fromRGB(40, 40, 60),          -- Líneas de grid
    Text = Color3.fromRGB(255, 255, 255)         -- Texto blanco
}

-- Crear efecto de pulso
local function createPulseEffect(frame)
    local pulse = Instance.new("UIGradient")
    pulse.Rotation = 90
    pulse.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 0.4),
        NumberSequenceKeypoint.new(1, 0.8)
    })
    pulse.Parent = frame
    
    local pulseTween = TweenService:Create(pulse, TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {
        Rotation = 450
    })
    pulseTween:Play()
    
    return pulse
end

-- Crear efecto de brillo
local function createGlowEffect(frame, color)
    local glow = Instance.new("UIStroke")
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Color = color
    glow.Thickness = 2
    glow.Transparency = 0.7
    glow.Parent = frame
    
    local glowTween = TweenService:Create(glow, TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1), {
        Transparency = 0.3
    })
    glowTween:Play()
    
    return glow
end

-- Crear marcador profesional
local function createProfessionalMarker(markerType, size)
    local marker = Instance.new("Frame")
    marker.Size = UDim2.new(0, size, 0, size)
    marker.AnchorPoint = Vector2.new(0.5, 0.5)
    marker.BackgroundTransparency = 1
    marker.BorderSizePixel = 0
    
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.BorderSizePixel = 0
    icon.Parent = marker
    
    local glow = createGlowEffect(marker, COLORS[markerType])
    
    -- Asignar color según tipo
    if markerType == "Player" then
        icon.Image = "rbxassetid://10734994525" -- Triángulo verde
        glow.Color = COLORS.Player
    elseif markerType == "Allies" then
        icon.Image = "rbxassetid://10734992743" -- Círculo azul
        glow.Color = COLORS.Allies
    elseif markerType == "Enemies" then
        icon.Image = "rbxassetid://10734993314" -- Rombo rojo
        glow.Color = COLORS.Enemies
    elseif markerType == "Neutral" then
        icon.Image = "rbxassetid://10734993978" -- Cuadrado amarillo
        glow.Color = COLORS.Neutral
    elseif markerType == "Objectives" then
        icon.Image = "rbxassetid://10734995189" -- Estrella rosa
        glow.Color = COLORS.Objectives
    end
    
    return marker
end

-- Crear el minimapa profesional
local function createProfessionalMinimap()
    -- Crear ScreenGui principal
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ProMinimapGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Contenedor principal del minimapa
    local mainContainer = Instance.new("Frame")
    mainContainer.Name = "MainContainer"
    mainContainer.Size = MAP_CONFIG.Size
    mainContainer.Position = MAP_CONFIG.Position
    mainContainer.BackgroundTransparency = 1
    mainContainer.Parent = screenGui
    
    -- Fondo del minimapa con efecto de vidrio esmerilado
    local minimapBackground = Instance.new("Frame")
    minimapBackground.Name = "MinimapBackground"
    minimapBackground.Size = UDim2.new(1, 0, 1, 0)
    minimapBackground.BackgroundColor3 = COLORS.Background
    minimapBackground.BorderSizePixel = 0
    
    -- Efecto de vidrio esmerilado
    local blur = Instance.new("UIGradient")
    blur.Rotation = 45
    blur.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.3),
        NumberSequenceKeypoint.new(0.5, 0.1),
        NumberSequenceKeypoint.new(1, 0.3)
    })
    blur.Parent = minimapBackground
    
    -- Borde con efecto neón
    local border = Instance.new("UIStroke")
    border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    border.Color = COLORS.Border
    border.Thickness = MAP_CONFIG.BorderSize
    border.Transparency = 0.2
    border.Parent = minimapBackground
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = minimapBackground
    
    minimapBackground.Parent = mainContainer
    
    -- Efecto de pulso en el borde
    if MAP_CONFIG.PulseEffect then
        createPulseEffect(minimapBackground)
    end
    
    -- Grid de referencia
    local gridContainer = Instance.new("Frame")
    gridContainer.Name = "GridContainer"
    gridContainer.Size = UDim2.new(1, -10, 1, -10)
    gridContainer.Position = UDim2.new(0, 5, 0, 5)
    gridContainer.BackgroundTransparency = 1
    gridContainer.Parent = minimapBackground
    
    -- Líneas de grid
    for i = 1, 3 do
        local horizontalLine = Instance.new("Frame")
        horizontalLine.Size = UDim2.new(1, 0, 0, 1)
        horizontalLine.Position = UDim2.new(0, 0, (i-1)/3, 0)
        horizontalLine.BackgroundColor3 = COLORS.Grid
        horizontalLine.BorderSizePixel = 0
        horizontalLine.Parent = gridContainer
        
        local verticalLine = Instance.new("Frame")
        verticalLine.Size = UDim2.new(0, 1, 1, 0)
        verticalLine.Position = UDim2.new((i-1)/3, 0, 0, 0)
        verticalLine.BackgroundColor3 = COLORS.Grid
        verticalLine.BorderSizePixel = 0
        verticalLine.Parent = gridContainer
    end
    
    -- Marcador del jugador (triángulo verde con efecto)
    local playerMarker = createProfessionalMarker("Player", 16)
    playerMarker.Name = "PlayerMarker"
    playerMarker.Position = UDim2.new(0.5, 0, 0.5, 0)
    playerMarker.Parent = minimapBackground
    
    -- Indicador de dirección
    local directionIndicator = Instance.new("Frame")
    directionIndicator.Name = "DirectionIndicator"
    directionIndicator.Size = UDim2.new(0, 4, 0, 8)
    directionIndicator.Position = UDim2.new(0.5, 0, 0.5, -20)
    directionIndicator.AnchorPoint = Vector2.new(0.5, 1)
    directionIndicator.BackgroundColor3 = COLORS.Player
    directionIndicator.BorderSizePixel = 0
    directionIndicator.Parent = playerMarker
    
    -- Controles de UI
    local controlsFrame = Instance.new("Frame")
    controlsFrame.Name = "Controls"
    controlsFrame.Size = UDim2.new(1, 0, 0, 30)
    controlsFrame.Position = UDim2.new(0, 0, 1, 5)
    controlsFrame.BackgroundTransparency = 1
    controlsFrame.Parent = mainContainer
    
    -- Botón de zoom out
    local zoomOutButton = Instance.new("TextButton")
    zoomOutButton.Name = "ZoomOut"
    zoomOutButton.Size = UDim2.new(0, 30, 1, 0)
    zoomOutButton.Position = UDim2.new(0, 0, 0, 0)
    zoomOutButton.Text = "-"
    zoomOutButton.TextColor3 = COLORS.Text
    zoomOutButton.BackgroundColor3 = COLORS.Border
    zoomOutButton.BorderSizePixel = 0
    zoomOutButton.Parent = controlsFrame
    
    -- Indicador de zoom
    local zoomLabel = Instance.new("TextLabel")
    zoomLabel.Name = "ZoomLabel"
    zoomLabel.Size = UDim2.new(0, 60, 1, 0)
    zoomLabel.Position = UDim2.new(0.5, -30, 0, 0)
    zoomLabel.Text = "Zoom: 1.0x"
    zoomLabel.TextColor3 = COLORS.Text
    zoomLabel.BackgroundTransparency = 1
    zoomLabel.Parent = controlsFrame
    
    -- Botón de zoom in
    local zoomInButton = Instance.new("TextButton")
    zoomInButton.Name = "ZoomIn"
    zoomInButton.Size = UDim2.new(0, 30, 1, 0)
    zoomInButton.Position = UDim2.new(1, -30, 0, 0)
    zoomInButton.Text = "+"
    zoomInButton.TextColor3 = COLORS.Text
    zoomInButton.BackgroundColor3 = COLORS.Border
    zoomInButton.BorderSizePixel = 0
    zoomInButton.Parent = controlsFrame
    
    -- Hacer los botones redondos
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = zoomOutButton
    buttonCorner:Clone().Parent = zoomInButton
    
    -- Función para hacer el minimapa arrastrable
    local isDragging = false
    local dragStartPosition = Vector2.new(0, 0)
    local mapStartPosition = UDim2.new(0, 0, 0, 0)
    
    local function onInputBegan(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local mapPos = Vector2.new(mainContainer.AbsolutePosition.X, mainContainer.AbsolutePosition.Y)
            local mapSize = Vector2.new(mainContainer.AbsoluteSize.X, mainContainer.AbsoluteSize.Y)
            
            if mousePos.X >= mapPos.X and mousePos.X <= mapPos.X + mapSize.X and
               mousePos.Y >= mapPos.Y and mousePos.Y <= mapPos.Y + mapSize.Y then
                isDragging = true
                dragStartPosition = mousePos
                mapStartPosition = mainContainer.Position
            end
        end
    end
    
    local function onInputChanged(input, gameProcessed)
        if isDragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local mousePos = Vector2.new(input.Position.X, input.Position.Y)
            local delta = mousePos - dragStartPosition
            
            local newX = math.clamp(mapStartPosition.X.Offset + delta.X, 0, screenGui.AbsoluteSize.X - mainContainer.AbsoluteSize.X)
            local newY = math.clamp(mapStartPosition.Y.Offset + delta.Y, 0, screenGui.AbsoluteSize.Y - mainContainer.AbsoluteSize.Y)
            
            mainContainer.Position = UDim2.new(0, newX, 0, newY)
        end
    end
    
    local function onInputEnded(input, gameProcessed)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            isDragging = false
        end
    end
    
    UserInputService.InputBegan:Connect(onInputBegan)
    UserInputService.InputChanged:Connect(onInputChanged)
    UserInputService.InputEnded:Connect(onInputEnded)
    
    -- Funcionalidad de zoom
    zoomInButton.MouseButton1Click:Connect(function()
        MAP_CONFIG.CurrentZoom = math.min(MAP_CONFIG.CurrentZoom + 1, #MAP_CONFIG.ZoomLevels)
        zoomLabel.Text = "Zoom: " .. MAP_CONFIG.ZoomLevels[MAP_CONFIG.CurrentZoom] .. "x"
    end)
    
    zoomOutButton.MouseButton1Click:Connect(function()
        MAP_CONFIG.CurrentZoom = math.max(MAP_CONFIG.CurrentZoom - 1, 1)
        zoomLabel.Text = "Zoom: " .. MAP_CONFIG.ZoomLevels[MAP_CONFIG.CurrentZoom] .. "x"
    end)
    
    return mainContainer, screenGui
end

-- Sistema de marcadores profesionales
local function setupProfessionalMinimap()
    local mainContainer, screenGui = createProfessionalMinimap()
    local minimapBackground = mainContainer:FindFirstChild("MinimapBackground")
    local localPlayer = Players.LocalPlayer
    local markers = {}
    
    -- Crear marcadores para todos los jugadores
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer then
            local markerType = math.random() > 0.5 and "Enemies" or "Allies" -- Ejemplo: 50% aliados, 50% enemigos
            local marker = createProfessionalMarker(markerType, 12)
            marker.Name = player.Name
            marker.Parent = minimapBackground
            markers[player.Name] = {marker = marker, type = markerType}
        end
    end
    
    -- Eventos para jugadores
    Players.PlayerAdded:Connect(function(player)
        if player ~= localPlayer then
            local markerType = math.random() > 0.5 and "Enemies" or "Allies"
            local marker = createProfessionalMarker(markerType, 12)
            marker.Name = player.Name
            marker.Parent = minimapBackground
            markers[player.Name] = {marker = marker, type = markerType}
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if markers[player.Name] then
            markers[player.Name].marker:Destroy()
            markers[player.Name] = nil
        end
    end)
    
    -- Función de actualización principal
    local function updateProfessionalMinimap()
        local localCharacter = localPlayer.Character
        if not localCharacter then return end
        
        local localHumanoidRootPart = localCharacter:FindFirstChild("HumanoidRootPart")
        if not localHumanoidRootPart then return end
        
        local localPosition = localHumanoidRootPart.Position
        local mapRadius = minimapBackground.AbsoluteSize.X / 2
        local currentZoom = MAP_CONFIG.ZoomLevels[MAP_CONFIG.CurrentZoom]
        local maxDistance = MAP_CONFIG.MaxDistance / currentZoom
        
        -- Actualizar rotación del jugador según la cámara
        local playerMarker = minimapBackground:FindFirstChild("PlayerMarker")
        if playerMarker then
            local camera = workspace.CurrentCamera
            if camera then
                local cameraCFrame = camera.CFrame
                local lookVector = cameraCFrame.LookVector
                local angle = math.atan2(lookVector.X, lookVector.Z) * (180 / math.pi)
                playerMarker.Rotation = angle
                
                -- Actualizar indicador de dirección
                local directionIndicator = playerMarker:FindFirstChild("DirectionIndicator")
                if directionIndicator then
                    directionIndicator.Rotation = angle
                end
            end
        end
        
        -- Actualizar todos los marcadores
        for playerName, markerData in pairs(markers) do
            local player = Players:FindFirstChild(playerName)
            if player then
                local character = player.Character
                if character then
                    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                    if humanoidRootPart then
                        local playerPosition = humanoidRootPart.Position
                        local offset = playerPosition - localPosition
                        
                        local distance = offset.Magnitude
                        local direction = offset.Unit
                        
                        -- Aplicar zoom
                        local displayDistance = math.min(distance, maxDistance)
                        local xPos = (direction.X * displayDistance / maxDistance) * mapRadius
                        local zPos = (direction.Z * displayDistance / maxDistance) * mapRadius
                        
                        markerData.marker.Position = UDim2.new(0.5, xPos, 0.5, zPos)
                        markerData.marker.Visible = true
                        
                        -- Efecto de parpadeo para enemigos lejanos
                        if markerData.type == "Enemies" and distance > maxDistance * 0.8 then
                            markerData.marker.UIStroke.Transparency = 0.5 + 0.5 * math.sin(os.clock() * 3)
                        else
                            markerData.marker.UIStroke.Transparency = 0.3
                        end
                    else
                        markerData.marker.Visible = false
                    end
                else
                    markerData.marker.Visible = false
                end
            else
                markerData.marker.Visible = false
            end
        end
        
        -- Efectos de iluminación dinámica
        if MAP_CONFIG.DynamicLighting then
            local timeOfDay = Lighting:GetMinutesAfterMidnight() / 60
            local brightness = 0.5 + 0.5 * math.sin(timeOfDay * math.pi / 12)
            minimapBackground.BackgroundColor3 = COLORS.Background:Lerp(Color3.new(0.1, 0.1, 0.2), brightness)
        end
    end
    
    -- Bucle de actualización
    RunService.RenderStepped:Connect(updateProfessionalMinimap)
    
    return mainContainer
end

-- Inicialización
Players.LocalPlayer:WaitForChild("PlayerGui")
setupProfessionalMinimap()

print("✅ Super Mapa Profesional cargado exitosamente!")
print("🎮 Características activadas:")
print("   • Efectos visuales avanzados")
print("   • Sistema de zoom (5 niveles)")
print("   • Marcadores profesionales")
print("   • Iluminación dinámica")
print("   • Arrrastre táctil/mouse")
print("   • Efectos de pulso y brillo")
print("   • Interfaz de usuario pro")
