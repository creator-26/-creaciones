-- ===== PARTE 1: ServerScript (va en ServerScriptService) =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Crear RemoteEvents
local swapPositionEvent = Instance.new("RemoteEvent")
swapPositionEvent.Name = "SwapPositionEvent"
swapPositionEvent.Parent = ReplicatedStorage

local getNearbyPlayersEvent = Instance.new("RemoteFunction")
getNearbyPlayersEvent.Name = "GetNearbyPlayersEvent"
getNearbyPlayersEvent.Parent = ReplicatedStorage

-- Función para intercambiar posiciones
local function swapPositions(player1, player2)
    local char1 = player1.Character
    local char2 = player2.Character
    
    if char1 and char2 and char1:FindFirstChild("HumanoidRootPart") and char2:FindFirstChild("HumanoidRootPart") then
        -- Guardar posiciones originales
        local pos1 = char1.HumanoidRootPart.CFrame
        local pos2 = char2.HumanoidRootPart.CFrame
        
        -- Intercambiar posiciones
        char1.HumanoidRootPart.CFrame = pos2
        char2.HumanoidRootPart.CFrame = pos1
        
        print(player1.Name .. " <--> " .. player2.Name .. " ¡Posiciones intercambiadas!")
        return true
    end
    return false
end

-- Función para obtener jugadores cercanos
local function getNearbyPlayers(requestingPlayer, maxDistance)
    local character = requestingPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return {}
    end
    
    local myPosition = character.HumanoidRootPart.Position
    local nearbyPlayers = {}
    
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= requestingPlayer and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (otherPlayer.Character.HumanoidRootPart.Position - myPosition).Magnitude
            if distance <= maxDistance then
                table.insert(nearbyPlayers, {
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

-- Manejar intercambio de posiciones
swapPositionEvent.OnServerEvent:Connect(function(player, targetPlayerName)
    local targetPlayer = Players:FindFirstChild(targetPlayerName)
    
    if targetPlayer and targetPlayer ~= player then
        -- Verificar distancia antes del intercambio
        local char1 = player.Character
        local char2 = targetPlayer.Character
        
        if char1 and char2 and char1:FindFirstChild("HumanoidRootPart") and char2:FindFirstChild("HumanoidRootPart") then
            local distance = (char1.HumanoidRootPart.Position - char2.HumanoidRootPart.Position).Magnitude
            if distance <= 100 then -- Máximo 100 studs
                swapPositions(player, targetPlayer)
            else
                print("Jugador demasiado lejos para intercambiar")
            end
        end
    end
end)

-- Manejar solicitud de jugadores cercanos
getNearbyPlayersEvent.OnServerInvoke = function(player, maxDistance)
    return getNearbyPlayers(player, maxDistance or 100)
end

-- ===== PARTE 2: LocalScript (va en StarterPlayer > StarterPlayerScripts) =====
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar a los RemoteEvents
local swapPositionEvent = ReplicatedStorage:WaitForChild("SwapPositionEvent")
local getNearbyPlayersEvent = ReplicatedStorage:WaitForChild("GetNearbyPlayersEvent")

-- Variables para la GUI
local screenGui
local mainFrame
local playerListFrame
local selectedPlayer = nil
local maxDistance = 100

-- Función para crear la interfaz
local function createGUI()
    -- ScreenGui principal
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PositionSwapGUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    -- Frame principal
    mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 400)
    mainFrame.Position = UDim2.new(0, 10, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Esquinas redondeadas
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.Position = UDim2.new(0, 0, 0, 0)
    titleLabel.BackgroundColor3 = Color3.new(0.2, 0.4, 0.8)
    titleLabel.Text = "🔄 INTERCAMBIO DE POSICIÓN"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleLabel
    
    -- Botón Refresh
    local refreshButton = Instance.new("TextButton")
    refreshButton.Name = "RefreshButton"
    refreshButton.Size = UDim2.new(0.8, 0, 0, 35)
    refreshButton.Position = UDim2.new(0.1, 0, 0, 50)
    refreshButton.BackgroundColor3 = Color3.new(0.3, 0.6, 0.3)
    refreshButton.Text = "🔄 ACTUALIZAR JUGADORES"
    refreshButton.TextColor3 = Color3.new(1, 1, 1)
    refreshButton.TextScaled = true
    refreshButton.Font = Enum.Font.Gotham
    refreshButton.Parent = mainFrame
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 8)
    refreshCorner.Parent = refreshButton
    
    -- Frame para lista de jugadores
    playerListFrame = Instance.new("ScrollingFrame")
    playerListFrame.Name = "PlayerListFrame"
    playerListFrame.Size = UDim2.new(0.9, 0, 0, 250)
    playerListFrame.Position = UDim2.new(0.05, 0, 0, 95)
    playerListFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    playerListFrame.BorderSizePixel = 0
    playerListFrame.ScrollBarThickness = 8
    playerListFrame.Parent = mainFrame
    
    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 8)
    listCorner.Parent = playerListFrame
    
    local listLayout = Instance.new("UIListLayout")
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Padding = UDim.new(0, 5)
    listLayout.Parent = playerListFrame
    
    -- Botón de Intercambio
    local swapButton = Instance.new("TextButton")
    swapButton.Name = "SwapButton"
    swapButton.Size = UDim2.new(0.8, 0, 0, 40)
    swapButton.Position = UDim2.new(0.1, 0, 0, 355)
    swapButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2)
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
    
    swapButton.MouseButton1Click:Connect(function()
        if selectedPlayer then
            swapPositionEvent:FireServer(selectedPlayer)
        end
    end)
    
    -- Efectos hover para botones
    local function addHoverEffect(button, normalColor, hoverColor)
        button.MouseEnter:Connect(function()
            if button.Active then
                TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
            end
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = normalColor}):Play()
        end)
    end
    
    addHoverEffect(refreshButton, Color3.new(0.3, 0.6, 0.3), Color3.new(0.4, 0.7, 0.4))
    addHoverEffect(swapButton, Color3.new(0.8, 0.4, 0.1), Color3.new(0.9, 0.5, 0.2))
end

-- Función para actualizar lista de jugadores
function refreshPlayerList()
    -- Limpiar lista actual
    for _, child in pairs(playerListFrame:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Obtener jugadores cercanos
    local nearbyPlayers = getNearbyPlayersEvent:InvokeServer(maxDistance)
    
    -- Actualizar tamaño del canvas
    playerListFrame.CanvasSize = UDim2.new(0, 0, 0, #nearbyPlayers * 55)
    
    if #nearbyPlayers == 0 then
        local noPlayersLabel = Instance.new("TextLabel")
        noPlayersLabel.Size = UDim2.new(1, 0, 0, 50)
        noPlayersLabel.BackgroundTransparency = 1
        noPlayersLabel.Text = "😔 No hay jugadores cerca"
        noPlayersLabel.TextColor3 = Color3.new(0.7, 0.7, 0.7)
        noPlayersLabel.TextScaled = true
        noPlayersLabel.Font = Enum.Font.Gotham
        noPlayersLabel.Parent = playerListFrame
        return
    end
    
    -- Crear botones para cada jugador
    for i, playerData in ipairs(nearbyPlayers) do
        local playerFrame = Instance.new("Frame")
        playerFrame.Name = "PlayerFrame_" .. playerData.Name
        playerFrame.Size = UDim2.new(1, -10, 0, 50)
        playerFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
        playerFrame.Parent = playerListFrame
        
        local frameCorner = Instance.new("UICorner")
        frameCorner.CornerRadius = UDim.new(0, 6)
        frameCorner.Parent = playerFrame
        
        local playerButton = Instance.new("TextButton")
        playerButton.Size = UDim2.new(1, 0, 1, 0)
        playerButton.BackgroundTransparency = 1
        playerButton.Text = ""
        playerButton.Parent = playerFrame
        
        local playerLabel = Instance.new("TextLabel")
        playerLabel.Size = UDim2.new(0.7, 0, 1, 0)
        playerLabel.Position = UDim2.new(0.05, 0, 0, 0)
        playerLabel.BackgroundTransparency = 1
        playerLabel.Text = "👤 " .. playerData.DisplayName .. " (@" .. playerData.Name .. ")"
        playerLabel.TextColor3 = Color3.new(1, 1, 1)
        playerLabel.TextScaled = true
        playerLabel.Font = Enum.Font.Gotham
        playerLabel.TextXAlignment = Enum.TextXAlignment.Left
        playerLabel.Parent = playerFrame
        
        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(0.25, 0, 1, 0)
        distanceLabel.Position = UDim2.new(0.75, 0, 0, 0)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = playerData.Distance .. "m"
        distanceLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
        distanceLabel.TextScaled = true
        distanceLabel.Font = Enum.Font.GothamBold
        distanceLabel.Parent = playerFrame
        
        -- Evento de selección
        playerButton.MouseButton1Click:Connect(function()
            -- Deseleccionar otros
            for _, otherFrame in pairs(playerListFrame:GetChildren()) do
                if otherFrame:IsA("Frame") and otherFrame.Name:find("PlayerFrame_") then
                    otherFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
                end
            end
            
            -- Seleccionar actual
            playerFrame.BackgroundColor3 = Color3.new(0.2, 0.4, 0.8)
            selectedPlayer = playerData.Name
            
            -- Actualizar botón de intercambio
            local swapButton = mainFrame:FindFirstChild("SwapButton")
            swapButton.Text = "🔄 INTERCAMBIAR CON " .. playerData.DisplayName
            swapButton.BackgroundColor3 = Color3.new(0.8, 0.4, 0.1)
            swapButton.Active = true
        end)
        
        -- Efecto hover
        playerButton.MouseEnter:Connect(function()
            if selectedPlayer ~= playerData.Name then
                playerFrame.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
            end
        end)
        
        playerButton.MouseLeave:Connect(function()
            if selectedPlayer ~= playerData.Name then
                playerFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
            end
        end)
    end
end

-- Inicializar GUI
createGUI()
refreshPlayerList()

-- Auto-refresh cada 5 segundos
spawn(function()
    while wait(5) do
        if screenGui and screenGui.Parent then
            refreshPlayerList()
        else
            break
        end
    end
end)
