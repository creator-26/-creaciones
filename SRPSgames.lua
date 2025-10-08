-- troleo_gifs.lua | Troleo: hub «Mostrar / No Mostrar» con imágenes/gifs
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local pg = lp:WaitForChild("PlayerGui")
local TS = game:GetService("TweenService")

-- URLs de imágenes/gifs (cámbialas por las que quieras)
local URL_MOSTRAR = "https://i.postimg.cc/tJ83q2z3/m-ldpwiqacxt-E-Ai-mh-Ayjfw4-caj-TC2-BM3-31702901b.gif"  -- Rick Roll gif
local URL_NOMOSTRAR = "https://i.postimg.cc/J7SY4qtw/4402.gif" -- Otro gif

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TroleoGui"
gui.ResetOnSpawn = false
gui.Parent = pg

-- Hub pequeño centrado
local hub = Instance.new("Frame")
hub.Size = UDim2.new(0, 180, 0, 50)
hub.Position = UDim2.new(0.5, -90, 0.5, -25)
hub.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
hub.BackgroundTransparency = 0.2
hub.BorderSizePixel = 0
hub.Active = true
hub.Draggable = true
hub.Parent = gui

-- Botón Mostrar
local btnMostrar = Instance.new("TextButton")
btnMostrar.Size = UDim2.new(0, 80, 1, -10)
btnMostrar.Position = UDim2.new(0, 5, 0, 5)
btnMostrar.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
btnMostrar.Text = "Mostrar"
btnMostrar.TextColor3 = Color3.new(1, 1, 1)
btnMostrar.TextScaled = true
btnMostrar.Font = Enum.Font.GothamBold
btnMostrar.Parent = hub

-- Botón No Mostrar
local btnNoMostrar = Instance.new("TextButton")
btnNoMostrar.Size = UDim2.new(0, 80, 1, -10)
btnNoMostrar.Position = UDim2.new(1, -85, 0, 5)
btnNoMostrar.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
btnNoMostrar.Text = "No Mostrar"
btnNoMostrar.TextColor3 = Color3.new(1, 1, 1)
btnNoMostrar.TextScaled = true
btnNoMostrar.Font = Enum.Font.GothamBold
btnNoMostrar.Parent = hub

-- Imagen central (inicialmente vacía)
local imagen = Instance.new("ImageLabel")
imagen.Size = UDim2.new(0, 0, 0, 0)
imagen.Position = UDim2.new(0.5, 0, 0.5, 0)
imagen.BackgroundTransparency = 1
imagen.Visible = false
imagen.Parent = gui

-- Tween de aparición
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- Lógica
btnMostrar.MouseButton1Click:Connect(function()
	imagen.Visible = true
	imagen.Image = URL_MOSTRAR
	imagen.Size = UDim2.new(0, 0, 0, 0)
	TS:Create(imagen, tweenInfo, {Size = UDim2.new(0, 300, 0, 300), Position = UDim2.new(0.5, -150, 0.5, -150)}):Play()
end)

btnNoMostrar.MouseButton1Click:Connect(function()
	imagen.Image = URL_NOMOSTRAR
	imagen.Visible = true
	imagen.Size = UDim2.new(0, 0, 0, 0)
	TS:Create(imagen, tweenInfo, {Size = UDim2.new(0, 300, 0, 300), Position = UDim2.new(0.5, -150, 0.5, -150)}):Play()
end)

print("Troleo Gif activado – presiona Mostrar / No Mostrar.")
