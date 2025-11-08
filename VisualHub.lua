-- VisualHub.lua adaptado a móvil: botón hide/show y dragTouch
local VisualHub = {}
local CoreGui = game:GetService("CoreGui")
local UIS = game:GetService("UserInputService")

function VisualHub:Create(title)
    local gui = Instance.new("ScreenGui")
    gui.Name = "VisualHub" .. tostring(math.random(1,10000))
    gui.Parent = CoreGui
    local frame = Instance.new("Frame", gui)
    frame.Position = UDim2.new(0.1, 0, 0.12, 0)
    frame.Size = UDim2.new(0, 380, 0, 480)
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    frame.BorderSizePixel = 2
    frame.Name = "MainFrame"

    local titleLbl = Instance.new("TextLabel", frame)
    titleLbl.Text = title or "Visual Hub"
    titleLbl.Size = UDim2.new(1, 0, 0, 40)
    titleLbl.TextSize = 23
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextColor3 = Color3.new(1,1,1)
    titleLbl.BackgroundTransparency = 0.3
    titleLbl.BackgroundColor3 = Color3.fromRGB(25,25,35)
    titleLbl.Name = "TitleBar"

    -- Hide button (always visible, top right)
    local hideBtn = Instance.new("TextButton", gui)
    hideBtn.Text = "Hide"
    hideBtn.Size = UDim2.new(0, 60, 0, 32)
    hideBtn.Position = UDim2.new(1, -65, 0, 5)
    hideBtn.BackgroundColor3 = Color3.fromRGB(60,60,110)
    hideBtn.TextColor3 = Color3.new(1,1,1)
    hideBtn.Font = Enum.Font.GothamSemibold
    hideBtn.TextSize = 16
    hideBtn.ZIndex = 15
    hideBtn.AutoButtonColor = true
    hideBtn.MouseButton1Click:Connect(function()
        frame.Visible = not frame.Visible
        -- Show a "Mostrar" button if oculto
        if not frame.Visible then
            hideBtn.Text = "Show"
        else
            hideBtn.Text = "Hide"
        end
    end)

    -- Touch drag for mobile (drag on title)
    local dragging = false
local dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

    return frame
end

function VisualHub:AddButton(frame, btntext, callback, ypos)
    local btn = Instance.new("TextButton", frame)
    btn.Text = btntext or "Botón"
    btn.Position = UDim2.new(0, 15, 0, ypos)
    btn.Size = UDim2.new(0, 250, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(65, 113, 175)
    btn.TextSize = 15
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.MouseButton1Click:Connect(function()
        if typeof(callback)=="function" then pcall(callback) end
    end)
    return btn
end
function VisualHub:AddSwitch(frame, lbltext, callback, ypos)
    local anchoBack = 344   -- Ancho total del label azul/gris, lo suficiente para cubrir casi todo el menú
    local anchoSw = 57     -- Ancho del botón ON/OFF (igual o apenas menor que el de la imagen)
    local alturaLabel = 34  -- Ajusta para igualar visualmente tu diseño (alto del label)
    local alturaSwitch = 26 -- Más bajo que el label para que quede en el centro
    local ajuste = math.floor((alturaLabel - alturaSwitch)/2)
    -- Label grande de color (fondo)
    local back = Instance.new("TextLabel", frame)
    back.Text = lbltext
    back.Font = Enum.Font.Gotham
    back.TextSize = 15
    back.TextColor3 = Color3.new(1,1,1)
    back.BackgroundColor3 = Color3.fromRGB(70,70,80)
    back.Position = UDim2.new(0, 15, 0, ypos)
    back.Size = UDim2.new(0, anchoBack, 0, alturaLabel)
    back.BackgroundTransparency = 0
    -- Botón ON/OFF justo pegado al extremo derecho, dentro del área coloreada
    local sw = Instance.new("TextButton", frame)
    sw.Text = "OFF"
    -- Pega el botón ON/OFF al borde derecho del label (offset negativo)
    sw.Position = UDim2.new(0, 15 + anchoBack - anchoSw - 6, 0, ypos + ajuste)
    sw.Size = UDim2.new(0, anchoSw, 0, alturaSwitch)
    sw.BackgroundColor3 = Color3.fromRGB(100,30,30)
    sw.TextColor3 = Color3.new(1,1,1)
    sw.Font = Enum.Font.GothamBold
    sw.BorderSizePixel = 0
    local active = false
    sw.MouseButton1Click:Connect(function()
        active = not active
        sw.Text = active and "ON" or "OFF"
        sw.BackgroundColor3 = active and Color3.fromRGB(30, 130, 30) or Color3.fromRGB(100,30,30)
        if typeof(callback)=="function" then pcall(callback, active) end
    end)
    return back, sw
end

function VisualHub:AddLabel(frame, text, ypos)
    local label = Instance.new("TextLabel", frame)
    label.Text = text or "Label"
    label.Position = UDim2.new(0,20,0,ypos)
    label.Size = UDim2.new(0, 335, 0, 24)
    label.TextSize = 17
    label.Font = Enum.Font.GothamSemibold
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    return label
end

return VisualHub
