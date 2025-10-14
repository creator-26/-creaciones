-- =========================================================
--  FARMEO GENERAL  |  Hub 2 botones
--  Recolecta cualquier objeto en el suelo (Orb, Coin, Gem...)
--  Sin mover al jugador → firetouchinterest
-- =========================================================
local Players = game:GetService("Players")
local plr = Players.LocalPlayer
local RUNNING = false
local CLAVE = "Orb"   -- palabra clave (cámbiala en GUI)

-- =========================================================
--  Hub 2 botones (mínimo)
-- =========================================================
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "GeneralFarm"

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(180,90)
frame.Position = UDim2.new(0.5,-90,0.5,-45)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
Instance.new("UICorner",frame).CornerRadius = UDim.new(0,6)
frame.Parent = gui

local tit = Instance.new("TextLabel",frame)
tit.Size = UDim2.new(1,0,0,25)
tit.Text = "General Farm"
tit.Font = Enum.Font.Code
tit.TextSize = 14
tit.TextColor3 = Color3.white
tit.BackgroundTransparency = 1

local claveBox = Instance.new("TextBox",frame)
claveBox.Size = UDim2.new(0,100,0,20)
claveBox.Position = UDim2.new(0.5,-50,0,30)
claveBox.Text = CLAVE
claveBox.ClearTextOnFocus = false
claveBox.Font = Enum.Font.Code
claveBox.TextSize = 13
claveBox.BackgroundColor3 = Color3.fromRGB(50,50,50)
claveBox.TextColor3 = Color3.white

local btn = Instance.new("TextButton",frame)
btn.Size = UDim2.new(0,80,0,25)
btn.Position = UDim2.new(0.5,-40,0,60)
btn.Text = "Iniciar"
btn.Font = Enum.Font.Code
btn.TextSize = 13
btn.TextColor3 = Color3.white
btn.BackgroundColor3 = Color3.fromRGB(0,170,0)

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
            if dist <= 25 then  -- radio 25 studs
                firetouchinterest(root, obj, 0)
                firetouchinterest(root, obj, 1)
                task.wait(rand(0.08,0.18)) -- pausa aleatoria
            end
        end
    end
end

local function toggle()
    RUNNING = not RUNNING
    btn.Text = RUNNING and "Parar" or "Iniciar"
    btn.BackgroundColor3 = RUNNING and Color3.fromRGB(170,0,0) or Color3.fromRGB(0,170,0)
    if RUNNING then
        task.spawn(function()
            while RUNNING do
                farm()
                task.wait(0.2)
            end
        end)
    end
end

btn.MouseButton1Click:Connect(toggle)

-- Hot-key P
game:GetService("UserInputService").InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == Enum.KeyCode.P then toggle() end
end)

-- Notificación
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="General Farm",
    Text="Inicia y farmea cualquier objeto. P → Start/Stop",
    Duration=5
})
