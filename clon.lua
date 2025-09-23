-- 👥 Clon directo del personaje
-- 📌 LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🟩 Botón
local gui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
gui.Name = "ClonGui"

local boton = Instance.new("TextButton")
boton.Size = UDim2.new(0, 100, 0, 40)
boton.Position = UDim2.new(0, 20, 0, 200)
boton.Text = "Clon OFF"
boton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
boton.TextColor3 = Color3.new(1,1,1)
boton.TextScaled = true
boton.Draggable = true
boton.Parent = gui

local clonActivo = false
local clonObj = nil

local function crearClon()
    if clonObj then clonObj:Destroy() end
    local char = LocalPlayer.Character
    if not char then return end

    local clon = char:Clone()
    clon.Name = "MiClon"
    clon.Parent = workspace

    -- lo movemos un poco al costado tuyo
    local root = clon:FindFirstChild("HumanoidRootPart")
    local myRoot = char:FindFirstChild("HumanoidRootPart")
    if root and myRoot then
        root.CFrame = myRoot.CFrame * CFrame.new(3,0,0)
    end

    -- por si acaso, quitar scripts internos que a veces buguean
    for _, v in pairs(clon:GetDescendants()) do
        if v:IsA("LocalScript") or v:IsA("Script") then
            v:Destroy()
        end
    end

    clonObj = clon
end

boton.MouseButton1Click:Connect(function()
    clonActivo = not clonActivo
    if clonActivo then
        boton.Text = "Clon ON"
        boton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        crearClon()
    else
        boton.Text = "Clon OFF"
        boton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if clonObj then clonObj:Destroy() end
    end
end)
