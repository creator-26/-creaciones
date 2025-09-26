-- ===== SCRIPT DE INTERCAMBIO DE POSICIONES PARA EXPLOIT =====
-- Compatible con cualquier executor (Synapse, KRNL, etc.)

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables globales
local screenGui
local mainFrame
local playerListFrame
local selectedPlayer = nil
local selectedPlayerObj = nil
local maxDistance = 100
local isGuiVisible = true

-- Función para intercambiar posiciones (lado cliente) - ARREGLADA
local function swapPositions(targetPlayer)
    local myCharacter = player.Character
    local targetCharacter = targetPlayer.Character
    
    if myCharacter and targetCharacter and 
       myCharacter:FindFirstChild("HumanoidRootPart") and 
       targetCharacter:FindFirstChild("HumanoidRootPart") then
        
        -- Guardar posiciones originales COMPLETAS
        local myPosition = myCharacter.HumanoidRootPart.CFrame
        local targetPosition = targetCharacter.HumanoidRootPart.CFrame
        
        -- Verificar distancia
        local distance = (myPosition.Position - targetPosition.Position).Magnitude
        if distance > maxDistance then
            game.StarterGui:SetCore("ChatMakeSystemMessage", {
                Text = "[SWAP] ❌ Jugador demasiado lejos (" .. math.floor(distance) .. "m)";
                Color = Color3.new(1, 0.3, 0.3);
                Font = Enum.Font.GothamBold;
                FontSize = Enum.FontSize.Size18;
            })
            return false
        end
        
        -- INTERCAMBIO REAL - Usamos un pequeño delay para asegurar sincronización
        local tempPosition = myPosition
        
        -- Mover al jugador objetivo a una posición temporal primero
        targetCharacter.HumanoidRootPart.CFrame = CFrame.new(myPosition.Position + Vector3.new(0, 100, 0))
        wait(0.1)
        
        -- Ahora moverme a la posición del objetivo
        myCharacter.HumanoidRootPart.CFrame = targetPosition
        wait(0.1)
        
        -- Finalmente mover al objetivo a mi posición original
        targetCharacter.HumanoidRootPart.CFrame = tempPosition
        
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[SWAP] ✅ Posición intercambiada con " .. targetPlayer.DisplayName;
            Color = Color3.new(0.3, 1, 0.3);
            Font = Enum.Font.GothamBold;
            FontSize = Enum.FontSize.Size18;
        })
        
        return true
    end
    return false
end

-- Función para obtener jugadores cercanos
local function getNearbyPlayers()
    local myCharacter = player.Character
    if not myCharacter or not myCharacter:FindFirstChild("HumanoidRootPart") then
        return {}
    end
    
    local myPosition = myCharacter.HumanoidRootPart.Position
    local nearbyPlayers = {}
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (otherPlayer.Character.HumanoidRootPart.Position - myPosition).Magnitude
            if distance <= maxDistance then
                table.insert(nearbyPlayers, {
                    Player = otherPlayer,
                    Name = otherPlayer.Name,
                    DisplayName = otherPlayer.DisplayName,
                    Distance = math.floor(distance)
                })
            end
        end
    end
    
    -- Ordenar por distancia
    table.sort(nearbyPlayers, function(a, b) return a.Distance < b.Distance end)
    
    return nearbyPlayers
end

-- Función para crear la interfaz
local function createGUI()
    -- Eliminar GUI existente si existe
    if playerGui:FindFirstChild("PositionSwapGUI") then
        playerGui:FindFirstChild("PositionSwapGUI"):Destroy()
    end
    
    -- ScreenGui principal
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PositionSwapGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal - TAMAÑO REDUCIDO
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 280, 0, 380)
    mainFrame.Position = UDim2.new(0, 10, 0.5, -190)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Borde brillante
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 162, 255)
    stroke.Thickness = 2
    stroke.Parent = mainFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 45)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    titleLabel.Text = "🔄 INTERCAMBIO DE POSICIÓN"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleLabel
    
    -- Botón cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 7.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.new(1, 1, 1)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleLabel
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 15)
    closeCorner.Parent = closeButton
    
    -- Botón minimizar
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -70, 0, 7.5)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    minimizeButton.Text = "−"
    minimizeButton.TextColor3 = Color3.new(1, 1, 1)
    minimizeButton.TextScaled = true
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = titleLabel
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 15)
    minimizeCorner.Parent = minimizeButton
    
    -- Info de distancia
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -10, 0, 25)
    infoLabel.Position = UDim2.new(0, 5, 0, 50)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "📏 Distancia máxima: " .. maxDistance .. " metros"
    infoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.Parent = mainFrame
    
    -- Botón Refresh
    local refreshButton = Instance.new("TextButton")
    refreshButton.Name = "RefreshButton"
    refreshButton.Size = UDim2.new(0.45, 0, 0, 35)
    refreshButton.Position = UDim2.new(0.025, 0, 0, 80)
    refreshButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    refreshButton.Text = "🔄 ACTUALIZAR"
    refreshButton.TextColor3 = Color3.new(1, 1, 1)
    refreshButton.TextScaled = true
    refreshButton.Font = Enum.Font.GothamBold
    refreshButton.Parent = mainFrame
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 8)
    refreshCorner.Parent = refreshButton
    
    -- Botón de configuración
    local configButton = Instance.new("TextButton")
    configButton.Size = UDim2.new(0.45, 0, 0, 35)
    configButton.Position = UDim2.new(0.525, 0, 0, 80)
    configButton.BackgroundColor3 = Color3.fromRGB(155, 89, 182)
    configButton.Text = "⚙️ DISTANCIA"
    configButton.TextColor3 = Color3.new(1, 1, 1)
    configButton.TextScaled = true
    configButton.Font = Enum.Font.GothamBold
    configButton.Parent = mainFrame
    
    local configCorner = Instance.new("UICorner")
    configCorner.CornerRadius = UDim.new(0, 8)
    configCorner.Parent = configButton
    
    -- Frame para lista de jugadores - TAMAÑO AJUSTADO
    playerListFrame = Instance.new("ScrollingFrame")
    playerListFrame.Name = "PlayerListFrame"
    playerListFrame.Size = UDim2.new(0.95, 0, 0, 220)
    playerListFrame.Position = UDim2.new(0.025, 0, 0, 125)
    playerListFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    playerListFrame.BorderSizePixel = 0
    playerListFrame.ScrollBarThickness = 8
    playerListFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
    playerListFrame.Parent = mainFrame
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 8)
    listCorner.Parent = playerListFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 3)
    listLayout.Parent = playerListFrame
    
    -- Botón de Intercambio - POSICIÓN AJUSTADA
    local swapButton = Instance.new("TextButton")
    swapButton.Name = "SwapButton"
    swapButton.Size = UDim2.new(0.95, 0, 0, 35)
    swapButton.Position = UDim2.new(0.025, 0, 0, 350)
    swapButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
    swapButton.Text = "❌ SELECCIONA UN JUGADOR"
    swapButton.TextColor3 = Color3.new(1, 1, 1)
    swapButton.TextScaled = true
    swapButton.Font = Enum.Font.GothamBold
    swapButton.Active = false
    swapButton.Parent = mainFrame
    
    local swapCorner = Instance.new("UICorner")
    swapCorner.CornerRadius = UDim.new(0, 8)
    swapCorner.Parent = swapButton
    
    -- Eventos de botones
    refreshButton.MouseButton1Click:Connect(refreshPlayerList)
    
    configButton.MouseButton1Click:Connect(function()
        -- Cambiar distancia (cicla entre valores)
        local distances = {50, 100, 150, 200, 300, 500}
        local currentIndex = 1
        for i, dist in ipairs(distances) do
            if dist == maxDistance then
                currentIndex = i
                break
            end
        end
        
        local nextIndex = (currentIndex % #distances) + 1
        maxDistance = distances[nextIndex]
        infoLabel.Text = "📏 Distancia máxima: " .. maxDistance .. " metros"
        
        game.StarterGui:SetCore("ChatMakeSystemMessage", {
            Text = "[SWAP] 📏 Distancia cambiada a " .. maxDistance .. "m";
            Color = Color3.fromRGB(155, 89, 182);
            Font = Enum.Font.Gotham;
        })
        
        refreshPlayerList()
    end)
    
    swapButton.MouseButton1Click:Connect(function()
        if selectedPlayerObj then
            swapPositions(selectedPlayerObj)
            selectedPlayer = nil
            selectedPlayerObj = nil
            swapButton.Text = "❌ SELECCIONA UN JUGADOR"
            swapButton.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
            swapButton.Active = false
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        isGuiVisible = not isGuiVisible
        mainFrame.Size = isGuiVisible and UDim2.new(0, 320, 0, 450) or UDim2.new(0, 320, 0, 45)
        minimizeButton.Text = isGuiVisible and "−" or "+"
    end)
    
    -- Efectos hover
    local function addHoverEffect(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
        end)
    end
    
    addHoverEffect(refreshButton, Color3.fromRGB(46, 204, 113), Color3.fromRGB(60, 220, 130))
    addHoverEffect(configButton, Color3.fromRGB(155, 89, 182), Color3.fromRGB(170, 110, 200))
    addHoverEffect(closeButton, Color3.fromRGB(255, 60, 60), Color3.fromRGB(255, 80, 80))
    addHoverEffect(minimizeButton, Color3.fromRGB(255, 165, 0), Color3.fromRGB(255, 180, 30))
end

-- Función para actualizar lista de jugadores
function refreshPlayerList()
    if not playerListFrame then return end
    
    -- Limpiar lista actual
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
    
    -- Obtener jugadores cercanos
    local nearbyPlayers = getNearbyPlayers()
    
    -- Actualizar tamaño del canvas
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, math.max(#nearbyPlayers * 58, playerListFrame.AbsoluteSize.Y))
    
    if #nearbyPlayers == 0 then
        local noPlayersLabel = Instance.new("TextLabel")
        noPlayersLabel.Size = UDim2.new(1, 0, 0, 60)
        noPlayersLabel.BackgroundTransparency = 1
        noPlayersLabel.Text = "😔 No hay jugadores cerca\n(Distancia: " .. maxDistance .. "m)"
        noPlayersLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
        noPlayersLabel.TextScaled = true
        noPlayersLabel.Font = Enum.Font.Gotham
        noPlayersLabel.Parent = playerListFrame
        return
    end
    
    -- Crear botones para cada jugador
    for i, playerData in ipairs(nearbyPlayers) do
        local playerFrame = Instance.new("Frame")
        playerFrame.Name = "PlayerFrame_" .. playerData.Name
        playerFrame.Size = UDim2.new(1, -5, 0, 55)
        playerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        playerFrame.Parent = playerListFrame
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 6)
        frameCorner.Parent = playerFrame
        
        local frameStroke = Instance.new("UIStroke")
        frameStroke.Color = Color3.fromRGB(80, 80, 80)
        frameStroke.Thickness = 1
        frameStroke.Parent = playerFrame
        
        local playerButton = Instance.new("TextButton")
        playerButton.Size = UDim2.new(1, 0, 1, 0)
        playerButton.BackgroundTransparency = 1
        playerButton.Text = ""
        playerButton.Parent = playerFrame
        
        local playerLabel = Instance.new("TextLabel")
        playerLabel.Size = UDim2.new(0.65, 0, 0.6, 0)
        playerLabel.Position = UDim2.new(0.05, 0, 0.1, 0)
        playerLabel.BackgroundTransparency = 1
        playerLabel.Text = "👤 " .. playerData.DisplayName
        playerLabel.TextColor3 = Color3.new(1, 1, 1)
        playerLabel.TextScaled = true
        playerLabel.Font = Enum.Font.GothamBold
        playerLabel.TextXAlignment = Enum.TextXAlignment.Left
        playerLabel.Parent = playerFrame
        
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(0.65, 0, 0.3, 0)
        nameLabel.Position = UDim2.new(0.05, 0, 0.6, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = "@" .. playerData.Name
        nameLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.Gotham
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = playerFrame
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(0.25, 0, 1, 0)
        distanceLabel.Position = UDim2.new(0.72, 0, 0, 0)
        distanceLabel.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        distanceLabel.Text = playerData.Distance .. "m"
        distanceLabel.TextColor3 = Color3.new(1, 1, 1)
        distanceLabel.TextScaled = true
        distanceLabel.Font = Enum.Font.GothamBold
        distanceLabel.Parent = playerFrame
        
        local distanceCorner = Instance.new("UICorner")
        distanceCorner.CornerRadius = UDim.new(0, 4)
        distanceCorner.Parent = distanceLabel
        
        -- Evento de selección
        playerButton.MouseButton1Click:Connect(function()
            -- Deseleccionar otros
            for _, otherFrame in pairs(playerListFrame:GetChildren()) do
                if otherFrame:IsA("Frame") and otherFrame.Name:find("PlayerFrame_") then
                    otherFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    local stroke = otherFrame:FindFirstChild("UIStroke")
                    if stroke then stroke.Color = Color3.fromRGB(80, 80, 80) end
                end
            end
            
            -- Seleccionar actual
            playerFrame.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            frameStroke.Color = Color3.fromRGB(0, 200, 255)
            selectedPlayer = playerData.Name
            selectedPlayerObj = playerData.Player
            
            -- Actualizar botón de intercambio
            local swapButton = mainFrame:FindFirstChild("SwapButton")
            swapButton.Text = "🔄 INTERCAMBIAR CON " .. playerData.DisplayName
            swapButton.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
            swapButton.Active = true
            
            addHoverEffect(swapButton, Color3.fromRGB(46, 204, 113), Color3.fromRGB(60, 220, 130))
        end)
        
        -- Efecto hover
        playerButton.MouseEnter:Connect(function()
            if selectedPlayer ~= playerData.Name then
                playerFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            end
        end)
        
        playerButton.MouseLeave:Connect(function()
            if selectedPlayer ~= playerData.Name then
                playerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
        end)
    end
end

-- Función principal
local function main()
    createGUI()
    wait(0.5)
    refreshPlayerList()
    
    game.StarterGui:SetCore("ChatMakeSystemMessage", {
        Text = "[SWAP] ✅ Script cargado exitosamente";
        Color = Color3.fromRGB(46, 204, 113);
        Font = Enum.Font.GothamBold;
        FontSize = Enum.FontSize.Size18;
    })
    
    -- Auto-refresh cada 3 segundos
    spawn(function()
        while screenGui and screenGui.Parent do
            wait(3)
            if isGuiVisible and selectedPlayer == nil then
                refreshPlayerList()
            end
        end
    end)
end

-- Tecla de acceso rápido (Insert para mostrar/ocultar)
UserInputService.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.Insert then
        if screenGui and screenGui.Parent then
            screenGui:Destroy()
        else
            main()
        end
    end
end)

-- Ejecutar script
main()
