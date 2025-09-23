-- 🤖 Clon avanzado: imita caminar, correr y saltar
-- 📌 LocalScript en StarterPlayerScripts

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- 🟩 Botón en pantalla
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
local Boton = Instance.new("TextButton", ScreenGui)
Boton.Size = UDim2.new(0, 100, 0, 40)
Boton.Position = UDim2.new(0, 20, 0, 200)
Boton.Text = "Clon OFF"
Boton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
Boton.TextColor3 = Color3.fromRGB(255,255,255)
Boton.TextScaled = true
Boton.Draggable = true

local clonActivo = false
local clonObj = nil
local humanoidClone = nil

-- 🔹 Crear clon idéntico
local function crearClon()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    if not char then return end

    -- eliminar clon previo
    if clonObj then
        clonObj:Destroy()
        clonObj = nil
    end

    -- clonar jugador completo
    clonObj = char:Clone()
    clonObj.Name = "MiClon"
    clonObj.Parent = workspace

    humanoidClone = clonObj:FindFirstChildOfClass("Humanoid")

    -- quitar nombre flotante
    if humanoidClone then
        humanoidClone.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end

    -- seguir al jugador con path simple
    task.spawn(function()
        while clonObj and clonObj.Parent do
            local root = clonObj:FindFirstChild("HumanoidRootPart")
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            if root and myRoot and humanoidClone then
                humanoidClone:MoveTo(myRoot.Position + Vector3.new(3,0,0)) -- sigue al lado tuyo
            end
            task.wait(0.2)
        end
    end)

    -- imitar SALTO
    local humanoidPlayer = char:FindFirstChildOfClass("Humanoid")
    if humanoidPlayer and humanoidClone then
        humanoidPlayer.Jumping:Connect(function(isJumping)
            if isJumping and humanoidClone then
                humanoidClone.Jump = true
            end
        end)

        -- imitar VELOCIDAD (caminar/correr)
        humanoidPlayer.Running:Connect(function(speed)
            if humanoidClone then
                humanoidClone:Move(Vector3.new(speed,0,0), true)
            end
        end)
    end
end

-- 🟢 Botón ON/OFF
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
