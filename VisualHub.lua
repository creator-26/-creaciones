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
    frame.BackgroundTransparency = 0.24
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
    -- Label
    local label = Instance.new("TextLabel", frame)
    label.Text = lbltext
    label.Position = UDim2.new(0, 15, 0, ypos)
    label.Size = UDim2.new(0, 210, 0, 30)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16

    -- Switch
    local switch = Instance.new("Frame", frame)
    switch.Size = UDim2.new(0, 32, 0, 18)
    switch.Position = UDim2.new(0, 250, 0, ypos+8)
    switch.BackgroundTransparency = 0
    switch.BackgroundColor3 = Color3.fromRGB(180, 180, 188)
    switch.BorderSizePixel = 0
    switch.Name = "Switch"
    -- Make it rounded
    local corner = Instance.new("UICorner", switch)
    corner.CornerRadius = UDim.new(1,0)

    -- Thumb circle
    local thumb = Instance.new("Frame", switch)
    thumb.Size = UDim2.new(0, 12, 0, 12)
    thumb.Position = UDim2.new(0, 2, 0, 2)
    thumb.BackgroundColor3 = Color3.fromRGB(255,255,255)
    thumb.BorderSizePixel = 0
    thumb.Name = "Thumb"
    local thumbCorner = Instance.new("UICorner", thumb)
    thumbCorner.CornerRadius = UDim.new(1,0)
    -- Drop shadow effect
    local shadow = Instance.new("UIStroke", thumb)
    shadow.Color = Color3.fromRGB(180,180,180)
    shadow.Thickness = 1

    local active = false
    local function setState(state)
    active = state
    if active then
        -- VERDE cuando está activado
        switch.BackgroundColor3 = Color3.fromRGB(46, 204, 113)  -- Verde clásico
        thumb.Position = UDim2.new(0, 16, 0, 3)
    else
        -- ROJO cuando está desactivado
        switch.BackgroundColor3 = Color3.fromRGB(231, 76, 60)   -- Rojo clásico
        thumb.Position = UDim2.new(0, 3, 0, 3)
         end
    end
    setState(false)

    switch.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            setState(not active)
            if typeof(callback)=="function" then pcall(callback, active) end
        end
    end)
    thumb.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            setState(not active)
            if typeof(callback)=="function" then pcall(callback, active) end
        end
    end)
    return label, switch
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
