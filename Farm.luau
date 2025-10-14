-- ===================================================================
--  Auto-Farm por Proximidad  |  GENERICO
--  Recolecta cualquier objeto que contenga la palabra clave en el nombre
--  Sin teletransportarte → usa firetouchinterest
-- ===================================================================
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local RUNNING = false
local RADIO = 25        -- studs de alcance
local CLAVE = "Orb"     -- cambia aquí o en la GUI

-- ===================================================================
--  GUI rápida
-- ===================================================================
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "ProximityFarm"

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(200,120)
frame.Position = UDim2.new(0.5,-100,0.5,-60)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,6)
frame.Parent = gui

local tit = Instance.new("TextLabel",frame)
tit.Size = UDim2.new(1,0,0,25)
tit.Text = "Proximity Farm"
tit.Font = Enum.Font.Code
tit.TextSize = 14
tit.TextColor3 = Color3.white
tit.BackgroundTransparency = 1

local clabel = Instance.new("TextLabel",frame)
clabel.Size = UDim2.new(0,60,0,20)
clabel.Position = UDim2.new(0,10,0,30)
clabel.Text = "Clave:"
clabel.Font = Enum.Font.Code
clabel.TextSize = 13
clabel.TextColor3 = Color3.white
clabel.BackgroundTransparency = 1

local claveBox = Instance.new("TextBox",frame)
claveBox.Size = UDim2.new(0,100,0,20)
claveBox.Position = UDim2.new(0,70,0,30)
claveBox.Text = CLAVE
claveBox.ClearTextOnFocus = false
claveBox.Font = Enum.Font.Code
claveBox.TextSize = 13
claveBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
claveBox.TextColor3 = Color3.white

local rlabel = clabel:Clone()
rlabel.Text = "Radio:"
rlabel.Position = UDim2.new(0,10,0,55)
rlabel.Parent = frame

local radioBox = claveBox:Clone()
radioBox.Text = tostring(RADIO)
radioBox.Position = UDim2.new(0,70,0,55)
radioBox.Parent = frame

local startBtn = Instance.new("TextButton",frame)
startBtn.Size = UDim2.new(0,180,0,25)
startBtn.Position = UDim2.new(0.5,-90,0,85)
startBtn.Text = "Start"
startBtn.Font = Enum.Font.Code
startBtn.TextSize = 13
startBtn.TextColor3 = Color3.white
startBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)

-- ===================================================================
--  Lógica
-- ===================================================================
local function rand(a,b) return math.random(a*100,b*100)/100 end

local function recolectar()
    local clave = claveBox.Text
    local radio = tonumber(radioBox.Text) or 25
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- buscar objetos
    local objetos = {}
    for _,obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name:lower():find(clave:lower()) then
            local dist = (obj.Position - root.Position).Magnitude
            if dist <= radio then
                table.insert(objetos,obj)
            end
        end
    end

    for _,obj in ipairs(objetos) do
        if not RUNNING then break end
        -- toque simulado sin mover al jugador
        firetouchinterest(root, obj, 0)
        firetouchinterest(root, obj, 1)
        task.wait(rand(0.08,0.18)) -- pausa aleatoria anti-ban
    end
end

local function toggle()
    RUNNING = not RUNNING
    startBtn.Text = RUNNING and "Stop" or "Start"
    startBtn.BackgroundColor3 = RUNNING and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
    if RUNNING then
        task.spawn(function()
            while RUNNING do
                recolectar()
                task.wait(0.2)
            end
        end)
    end
end

startBtn.MouseButton1Click:Connect(toggle)

-- Hot-key
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.P then toggle() end
end)

-- Notificación
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="Proximity Farm",
    Text="P → Start/Stop  |  Cambia clave/radio en GUI",
    Duration=5
})
