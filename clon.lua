-- 🤖 Clon igual a tu personaje
-- 📌 LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Crear botón
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Boton = Instance.new("TextButton", ScreenGui)
Boton.Size = UDim2.new(0, 100, 0, 40)
Boton.Position = UDim2.new(0, 20, 0, 200)
Boton.Text = "Clon OFF"
Boton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Boton.TextColor3 = Color3.fromRGB(255,255,255)
Boton.TextScaled = true
Boton.AutoButtonColor = true
Boton.Active = true
Boton.Draggable = true

local clonActivo = false
local clonObj = nil

local function crearClon()
    local char = LocalPlayer.Character
    if not char then return end

    -- borrar clon anterior
    if clonObj then
        clonObj:Destroy()
        clonObj = nil
    end

    -- clonar personaje completo
    local clon = char:Clone()
    clon.Name = "MiClon"
    clon.Parent = workspace
    clonObj = clon

    -- darle humanoid para que se mueva
    local humanoid = clon:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None -- sin nombre flotante
    end

    -- seguir al jugador
    task.spawn(function()
        while clonObj and clonObj.Parent do
            local root = clonObj:FindFirstChild("HumanoidRootPart")
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            local hum = clonObj:FindFirstChildOfClass("Humanoid")
            if root and myRoot and hum then
                hum:MoveTo(myRoot.Position + Vector3.new(2,0,2))
            end
            task.wait(0.5)
        end
    end)
end

-- botón ON/OFF
Boton.MouseButton1Click:Connect(function()
    clonActivo = not clonActivo
    if clonActivo then
        Boton.Text = "Clon ON"
        Boton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        crearClon()
    else
        Boton.Text = "Clon OFF"
        Boton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        if clonObj then
            clonObj:Destroy()
            clonObj = nil
        end
    end
end)
