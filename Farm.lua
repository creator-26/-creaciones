-- =========================================================
--  HUB NUEVO  |  2 botones  |  Farmeo General
--  Objetos: Orb, Coin, Gem... (palabra clave editable)
--  Sin mover al jugador → firetouchinterest
-- =========================================================
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local RUNNING = false
local CLAVE = "Orb" -- editable en GUI

-- =========================================================
--  HUB NUEVO (cuadro visible, 2 botones, arrastrable)
-- =========================================================
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "HubFarm"

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(200,120)
frame.Position = UDim2.new(0.5,-100,0.5,-60)
frame.BackgroundColor3 = Color3.fromRGB(40,40,40)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Visible = true
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,8)
frame.Parent = gui

-- Título
local tit = Instance.new("TextLabel",frame)
tit.Size = UDim2.new(1,0,0,25)
tit.Text = "Farm General"
tit.Font = Enum.Font.Code
tit.TextSize = 16
tit.TextColor3 = Color3.white
tit.BackgroundTransparency = 1

-- Palabra clave
local claveBox = Instance.new("TextBox",frame)
claveBox.Size = UDim2.new(0,120,0,25)
claveBox.Position = UDim2.new(0.5,-60,0,35)
claveBox.Text = CLAVE
claveBox.ClearTextOnFocus = false
claveBox.Font = Enum.Font.Code
claveBox.TextSize = 13
claveBox.BackgroundColor3 = Color3.fromRGB(60,60,60)
claveBox.TextColor3 = Color3.white
claveBox.PlaceholderText = "Palabra"

-- Botón INICIAR
local btnInic = Instance.new("TextButton",frame)
btnInic.Size = UDim2.new(0,80,0,30)
btnInic.Position = UDim2.new(0.5,-85,0,70)
btnInic.Text = "Iniciar"
btnInic.Font = Enum.Font.Code
btnInic.TextSize = 14
btnInic.TextColor3 = Color3.white
btnInic.BackgroundColor3 = Color3.fromRGB(0,170,0)

-- Botón PARAR
local btnParar = Instance.new("TextButton",frame)
btnParar.Size = UDim2.new(0,80,0,30)
btnParar.Position = UDim2.new(0.5,5,0,70)
btnParar.Text = "Parar"
btnParar.Font = Enum.Font.Code
btnParar.TextSize = 14
btnParar.TextColor3 = Color3.white
btnParar.BackgroundColor3 = Color3.fromRGB(170,0,0)

-- =========================================================
--  Lógica de farmeo
-- =========================================================
local function rand(a,b) return math.random(a*100,b*100)/100 end

local function farm()
    local clave = claveBox.Text
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _,obj in ipairs(workspace:GetDescendants()) do
        if not RUNNING then break end
        if obj:IsA("BasePart") and obj.Name:lower():find(clave:lower()) then
            local dist = (obj.Position - root.Position).Magnitude
            if dist <= 30 then  -- radio 30 studs
                firetouchinterest(root, obj, 0)
                firetouchinterest(root, obj, 1)
                task.wait(rand(0.08,0.16)) -- anti-ban
            end
        end
    end
end

-- =========================================================
--  Botones
-- =========================================================
btnInic.MouseButton1Click:Connect(function()
    if RUNNING then return end
    RUNNING = true
    task.spawn(function()
        while RUNNING do
            farm()
            task.wait(0.2)
        end
    end)
end)

btnParar.MouseButton1Click:Connect(function()
    RUNNING = false
end)

-- Hot-key P
game:GetService("UserInputService").InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.P then
        if RUNNING then
            RUNNING = false
        else
            RUNNING = true
            task.spawn(function()
                while RUNNING do
                    farm()
                    task.wait(0.2)
                end
            end)
        end
    end
end)

-- Notificación
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="Hub Farm",
    Text="Inicia y farmea cualquier objeto. P → Start/Stop",
    Duration=5
})
