-- ======================================================================
--  No-Limit Orb Farm 2.0  (mejorado)
--  - Paralelización, anti-repetición, tween suave, fly, anti-afk, keybind
-- ======================================================================
local svcs = {
    Players = game:GetService("Players"),
    Tween   = game:GetService("TweenService"),
    UIS     = game:GetService("UserInputService"),
    Run     = game:GetService("RunService")
}

local plr     = svcs.Players.LocalPlayer
local stage   = 1
local MAX_STAGE = 30
local running = false
local claimed = {}       -- orbes ya recolectados en este ciclo
local CPS_MAX = 6        -- collects por segundo
local lastAfk = tick()

-- ======================================================================
--  GUI (misma que antes, pero con UIScale)
-- ======================================================================
local gui = Instance.new("ScreenGui")
gui.Name = "OrbFarmV2"
gui.Parent = game:GetService("CoreGui")
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.ResetOnSpawn   = false

local mframe, tbar, toggleBtn, stageBox do
    -- Marco general
    mframe = Instance.new("Frame")
    mframe.Size            = UDim2.fromOffset(220,130)
    mframe.Position        = UDim2.new(0.5,-110,0.5,-65)
    mframe.BackgroundColor3 = Color3.fromRGB(20,20,20)
    Instance.new("UICorner",mframe).CornerRadius = UDim.new(0,6)

    -- UIScale para adaptarse a móviles
    local scale = Instance.new("UIScale",mframe)
    scale.Scale = 1

    -- Barra de título
    tbar = Instance.new("Frame")
    tbar.Size = UDim2.new(1,0,0,28)
    tbar.BackgroundColor3 = Color3.fromRGB(25,25,25)
    Instance.new("UICorner",tbar).CornerRadius = UDim.new(0,4)
    tbar.Parent = mframe

    local xb = Instance.new("TextButton")
    xb.Size = UDim2.new(0,20,1,0)
    xb.Position = UDim2.new(1,-20,0,0)
    xb.Text = "×"
    xb.TextColor3 = Color3.fromRGB(255,0,0)
    xb.BackgroundTransparency = 1
    xb.Font = Enum.Font.Code
    xb.TextSize = 14
    xb.Parent = tbar
    xb.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- Label etapa
    Instance.new("TextLabel",mframe).Text = "Stage:"
    local sl = mframe:FindFirstChildOfClass("TextLabel")
    sl.Size = UDim2.fromOffset(70,18)
    sl.Position = UDim2.new(0,10,0,40)
    sl.TextColor3 = Color3.white
    sl.Font = Enum.Font.Code
    sl.TextSize = 13
    sl.BackgroundTransparency = 1

    -- Botones < etapa >
    local l = Instance.new("TextButton")
    l.Size = UDim2.fromOffset(25,22)
    l.Position = UDim2.new(0,85,0,38)
    l.Text = "<"
    l.Font = Enum.Font.Code
    l.TextSize = 13
    l.BackgroundColor3 = Color3.fromRGB(25,25,25)
    l.TextColor3 = Color3.white
    l.Parent = mframe

    stageBox = Instance.new("TextBox")
    stageBox.Size = UDim2.fromOffset(50,22)
    stageBox.Position = UDim2.new(0,115,0,38)
    stageBox.Text = tostring(stage)
    stageBox.ClearTextOnFocus = false
    stageBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
    stageBox.TextColor3 = Color3.white
    stageBox.Font = Enum.Font.Code
    stageBox.TextSize = 13
    stageBox.Parent = mframe

    local r = l:Clone()
    r.Text = ">"
    r.Position = UDim2.new(0,175,0,38)
    r.Parent = mframe

    toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0,200,0,25)
    toggleBtn.Position = UDim2.new(0,10,0,85)
    toggleBtn.Text = "Start"
    toggleBtn.Font = Enum.Font.Code
    toggleBtn.TextSize = 13
    toggleBtn.TextColor3 = Color3.white
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    toggleBtn.Parent = mframe

    -- Drag
    local function drag(f,b)
        local uis,conn,dragging,startPos,dragStart = svcs.UIS
        b.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dragging = true
                dragStart = i.Position
                startPos = f.AbsolutePosition
                conn = uis.InputChanged:Connect(function(ch)
                    if dragging then
                        local delta = ch.Position-dragStart
                        local vs = workspace.CurrentCamera.ViewportSize
                        f.Position=UDim2.new(0,math.clamp(startPos.X+delta.X,0,vs.X-f.AbsoluteSize.X),0,math.clamp(startPos.Y+delta.Y,0,vs.Y-f.AbsoluteSize.Y))
                    end
                end)
                uis.InputEnded:Connect(function(e)
                    if e.UserInputType==Enum.UserInputType.MouseButton1 or e.UserInputType==Enum.UserInputType.Touch then
                        dragging=false
                        if conn then conn:Disconnect() conn=nil end
                    end
                end)
            end
        end)
    end
    drag(mframe,tbar)

    -- Stage logic
    local function setStage(v)
        v = math.clamp(math.floor(v),1,MAX_STAGE)
        stage = v
        stageBox.Text = tostring(v)
    end
    l.MouseButton1Click:Connect(function() setStage(stage-1) end)
    r.MouseButton1Click:Connect(function() setStage(stage+1) end)
    stageBox.FocusLost:Connect(function() setStage(tonumber(stageBox.Text) or stage) end)
end

-- ======================================================================
--  Utilidades
-- ======================================================================
local function getRoot()
    local c = plr.Character or plr.CharacterAdded:Wait()
    return c:WaitForChild("HumanoidRootPart")
end

local function tweenTo(cf,time)
    local root = getRoot()
    local goal = {}
    goal.CFrame = cf
    local ti = TweenInfo.new(time or 0.12,Enum.EasingStyle.Linear)
    svcs.Tween:Create(root,ti,goal):Play()
end

local function enableFly()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum  = char:WaitForChild("Humanoid")
    hum.PlatformStand = true
    local bp = Instance.new("BodyPosition")
    bp.MaxForce = Vector3.new(0,math.huge,0)
    bp.Parent = getRoot()
    return bp
end

local function disableFly(bp)
    if bp then bp:Destroy() end
    local hum = (plr.Character or plr.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
end

-- ======================================================================
--  Recolección inteligente
-- ======================================================================
local function collectLoop()
    local boosts = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Stages")
        and workspace.Map.Stages:FindFirstChild("Boosts")
    if not boosts then return end

    local stageFolder = boosts:FindFirstChild(tostring(stage))
    if not stageFolder then return end

    -- Agrupar orbes válidos
    local orbes = {}
    for _,model in ipairs(stageFolder:GetChildren()) do
        for _,p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") and p.Transparency<1 and p.CanTouch and not claimed[p] then
                table.insert(orbes,p)
                claimed[p] = true
            end
        end
    end

    -- Clustering: si hay muchos cerca, ir al centro
    while #orbes>0 and running do
        local closest = nil
        local minDist = math.huge
        local rootPos = getRoot().Position
        for _,o in ipairs(orbes) do
            if o.Parent then
                local d = (o.Position-rootPos).Magnitude
                if d<minDist then
                    minDist=d
                    closest=o
                end
            end
        end
        if not closest then break end

        -- Si está lejos o elevado, vuela
        local fly
        if minDist>20 or math.abs(closest.Position.Y-rootPos.Y)>6 then
            fly = enableFly()
            fly.Position = closest.Position+Vector3.new(0,3,0)
        end

        -- Tween suave
        tweenTo(closest.CFrame*CFrame.new(0,0,0))
        local t = tick()
        while tick()-t<0.15 do task.wait() end

        -- Recolectado
        if fly then disableFly(fly) end
        table.remove(orbes,table.find(orbes,closest))

        -- Respetar CPS máximo
        task.wait(1/CPS_MAX)
    end
end

-- ======================================================================
--  Toggle + Keybind
-- ======================================================================
local function toggle()
    running = not running
    if running then
        toggleBtn.Text = "Stop"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
        claimed = {} -- limpiar blacklist
        task.spawn(function()
            while running do
                collectLoop()
                task.wait(0.2)
            end
        end)
    else
        toggleBtn.Text = "Start"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    end
end

toggleBtn.MouseButton1Click:Connect(toggle)
svcs.UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode==Enum.KeyCode.P then toggle() end
end)

-- ======================================================================
--  Anti-AFK
-- ======================================================================
task.spawn(function()
    while true do
        if running and tick()-lastAfk>45 then
            local hum = (plr.Character or plr.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            lastAfk = tick()
        end
        task.wait(1)
    end
end)

-- Notificación
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="OrbFarm V2",
    Text="Presiona P para empezar/parar. Recuerda estar en tu mundo.",
    Duration=5
})
