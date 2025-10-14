-- =========================================================
--  GUI-VISOR MÍNIMO  |  Test rápido
--  Solo comprueba que tu exploit pinta en pantalla
-- =========================================================
local gui = Instance.new("ScreenGui")
gui.Name = "TestGUI"
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(200,100)
frame.Position = UDim2.new(0.5,-100,0.5,-50)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.BorderSizePixel = 0
frame.Visible = true
frame.Parent = gui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1,0,1,0)
label.Text = "¡GUI funcional!"
label.Font = Enum.Font.SourceSans
label.TextSize = 24
label.TextColor3 = Color3.white
label.BackgroundTransparency = 1
label.Parent = frame

-- =========================================================
--  Cerrar con clic derecho sobre el cuadro
-- =========================================================
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        gui:Destroy()
    end
end)

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="Test",
    Text="Cuadro visible. Clic derecho para cerrar.",
    Duration=3
})
