-- ===================================================================
--  No-Limit Orb Farm 3.0  |  ANTI-BAN  (Delta / PC)
--  - Sin firetouchinterest  |  - Velocidad humana
--  - Pausas aleatorias      |  - Micro-movimientos
--  - Límite 200/ciclo       |  - Descanso largo
-- ===================================================================
local Players, Tween = game:GetService("Players"), game:GetService("TweenService")
local plr = Players.LocalPlayer
local RUNNING, STAGE = false, 1
local MAX_ORBS_CYCLE = 200    -- orbes por ciclo
local ORB_COUNT = 0           -- contador actual
local RESTING = false         -- descansando

-- ===================================================================
--  CONFIG RÁPIDA (cámbiala cuando quieras)
-- ===================================================================
local HOTKEY = Enum.KeyCode.P -- letra de start/stop
local MAX_STAGE = 30
local MAX_CPS = 6             -- 6 orbes/seg max (humano)

-- ===================================================================
--  GUI invisible mientras farmeas (solo barra pequeña)
-- ===================================================================
local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
gui.Name = "OrbFarmV3"
gui.ResetOnSpawn = false

local mframe = Instance.new("Frame")
mframe.Size = UDim2.fromOffset(180,26)
mframe.Position = UDim2.new(1,-190,1,-36)
mframe.BackgroundColor3 = Color3.fromRGB(0,0,0)
mframe.BackgroundTransparency = 0.4
mframe.Visible = false -- invisible al farmear
Instance.new("UICorner",mframe).CornerRadius = UDim.new(0,4)
mframe.Parent = gui

local status = Instance.new("TextLabel",mframe)
status.Size = UDim2.new(1,0,1,0)
status.Text = "OFF"
status.TextColor3 = Color3.fromRGB(255,255,255)
status.Font = Enum.Font.Code
status.TextSize = 13
status.BackgroundTransparency = 1

-- ===================================================================
--  Utilidades
-- ===================================================================
local function rand(a,b) return math.random(a*100,b*100)/100 end
local function getRoot()
    local c = plr.Character or plr.CharacterAdded:Wait()
    return c:WaitForChild("HumanoidRootPart")
end
local function antiFreeze()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum  = char:WaitForChild("Humanoid")
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    hum:ChangeState(Enum.HumanoidStateType.Running)
end
local function microWalk()
    -- Camina 1-3 studs en dirección aleatoria
    local root = getRoot()
    local dir = Vector3.new(rand(-1,1), 0, rand(-1,1)).Unit
    local goal = root.CFrame + dir * rand(1,3)
    local ti = TweenInfo.new(rand(0.3,0.6), Enum.EasingStyle.Linear)
    Tween:Create(root, ti, {CFrame = goal}):Play()
end
local function smallJump()
    local hum = (plr.Character or plr.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end

-- ===================================================================
--  Recolección REAL (tu cuerpo toca el orbe)
-- ===================================================================
local function collectLoop()
    local boosts = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Stages") and workspace.Map.Stages:FindFirstChild("Boosts")
    if not boosts then return end
    local stageFolder = boosts:FindFirstChild(tostring(STAGE))
    if not stageFolder then return end

    local orbes = {}
    for _,model in ipairs(stageFolder:GetChildren()) do
        for _,p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") and p.Transparency<1 and p.CanTouch then
                table.insert(orbes,p)
            end
        end
    end

    for _,orb in ipairs(orbes) do
        if not RUNNING or ORB_COUNT >= MAX_ORBS_CYCLE then break end
        local root = getRoot()
        -- Micro-movimiento hacia el orbe (3-6 studs)
        local dir = (orb.Position - root.Position).Unit
        local nearCF = orb.CFrame - dir * rand(3,6)
        antiFreeze()
        root.CFrame = nearCF
        -- Pequeño salto para "tocar" el orbe
        smallJump()
        task.wait(rand(0.08,0.18)) -- pausa aleatoria
        ORB_COUNT = ORB_COUNT + 1
    end
end

-- ===================================================================
--  Descanso largo entre ciclos (evita flag por farmeo excesivo)
-- ===================================================================
local function restCycle()
    RESTING = true
    local rest = rand(120,180) -- 2-3 min
    status.Text = "REST " .. math.floor(rest) .. "s"
    for i = rest,1,-1 do
        if not RUNNING then break end
        status.Text = "REST " .. i .. "s"
        task.wait(1)
    end
    ORB_COUNT = 0
    RESTING = false
end

-- ===================================================================
--  Toggle
-- ===================================================================
local function toggle()
    RUNNING = not RUNNING
    if RUNNING then
        status.Text = "ON"
        mframe.Visible = true
        task.spawn(function()
            while RUNNING do
                if ORB_COUNT >= MAX_ORBS_CYCLE and not RESTING then
                    restCycle()
                end
                if not RESTING then collectLoop() end
                task.wait(0.2)
            end
            status.Text = "OFF"
            mframe.Visible = false
        end)
    else
        status.Text = "OFF"
        mframe.Visible = false
    end
end

-- Hotkey
game:GetService("UserInputService").InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == HOTKEY then toggle() end
end)

-- Notificación inicial
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="OrbFarm V3",
    Text="Anti-Ban activado. Límite 200 orbes/ciclo. " .. string.upper(tostring(HOTKEY)) .. " → Start/Stop",
    Duration=5
})
