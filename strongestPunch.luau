-- ======================================================================
--  No-Limit Orb Farm 2.0  |  Delta-Executor Ready
--  Copiar → Pegar en Delta → Inject → Execute → Listo
-- ======================================================================
local gui = Instance.new("ScreenGui")
gui.Name = "OrbFarmV2"
gui.Parent = game:GetService("CoreGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

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
local claimed = {}
local CPS_MAX = 6
local lastAfk = tick()

-- ===================================================================
--  GUI rápida (compacta)
-- ===================================================================
local mframe = Instance.new("Frame")
mframe.Size = UDim2.fromOffset(220,130)
mframe.Position = UDim2.new(0.5,-110,0.5,-65)
mframe.BackgroundColor3 = Color3.fromRGB(20,20,20)
mframe.Parent = gui
Instance.new("UICorner",mframe).CornerRadius = UDim.new(0,6)

local tbar = Instance.new("Frame")
tbar.Size = UDim2.new(1,0,0,28)
tbar.BackgroundColor3 = Color3.fromRGB(25,25,25)
tbar.Parent = mframe
Instance.new("UICorner",tbar).CornerRadius = UDim.new(0,4)

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

local tlb = Instance.new("TextLabel")
tlb.Size = UDim2.new(1,-26,1,0)
tlb.Position = UDim2.new(0,8,0,0)
tlb.Text = "No-Limit Orb Farm 2.0"
tlb.TextColor3 = Color3.white
tlb.Font = Enum.Font.Code
tlb.TextSize = 13
tlb.BackgroundTransparency = 1
tlb.TextXAlignment = Enum.TextXAlignment.Left
tlb.Parent = tbar

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

local stageBox = Instance.new("TextBox")
stageBox.Size = UDim2.fromOffset(50,22)
stageBox.Position = UDim2.new(0.5,-25,0,40)
stageBox.Text = tostring(stage)
stageBox.ClearTextOnFocus = false
stageBox.BackgroundColor3 = Color3.fromRGB(25,25,25)
stageBox.TextColor3 = Color3.white
stageBox.Font = Enum.Font.Code
stageBox.TextSize = 13
stageBox.Parent = mframe

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0,200,0,25)
toggleBtn.Position = UDim2.new(0.5,-100,0,85)
toggleBtn.Text = "Start"
toggleBtn.Font = Enum.Font.Code
toggleBtn.TextSize = 13
toggleBtn.TextColor3 = Color3.white
toggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,0)
toggleBtn.Parent = mframe

stageBox.FocusLost:Connect(function()
    local v = tonumber(stageBox.Text)
    if v and v>=1 and v<=MAX_STAGE then stage = v else stageBox.Text = tostring(stage) end
end)

-- ===================================================================
--  Utilidades
-- ===================================================================
local function getRoot()
    local c = plr.Character or plr.CharacterAdded:Wait()
    return c:WaitForChild("HumanoidRootPart")
end

local function tweenTo(cf,time)
    local root = getRoot()
    local goal = {CFrame = cf}
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

-- ===================================================================
--  Recolección
-- ===================================================================
local function collectLoop()
    local boosts = workspace:FindFirstChild("Map")
        and workspace.Map:FindFirstChild("Stages")
        and workspace.Map.Stages:FindFirstChild("Boosts")
    if not boosts then return end
    local stageFolder = boosts:FindFirstChild(tostring(stage))
    if not stageFolder then return end

    local orbes = {}
    for _,model in ipairs(stageFolder:GetChildren()) do
        for _,p in ipairs(model:GetDescendants()) do
            if p:IsA("BasePart") and p.Transparency<1 and p.CanTouch and not claimed[p] then
                table.insert(orbes,p)
                claimed[p] = true
            end
        end
    end

    while #orbes>0 and running do
        local rootPos = getRoot().Position
        local closest,dist = nil,math.huge
        for i,o in ipairs(orbes) do
            if o.Parent then
                local d = (o.Position-rootPos).Magnitude
                if d<dist then closest,dist = o,d end
            end
        end
        if not closest then break end
        -- Fly si hace falta
        local fly
        if dist>20 or math.abs(closest.Position.Y-rootPos.Y)>6 then
            fly = enableFly()
            fly.Position = closest.Position+Vector3.new(0,3,0)
        end
        tweenTo(closest.CFrame)
        local t = tick()
        while tick()-t<0.15 do task.wait() end
        if fly then disableFly(fly) end
        table.remove(orbes,table.find(orbes,closest))
        task.wait(1/CPS_MAX)
    end
end

-- ===================================================================
--  Toggle + Keybind
-- ===================================================================
local function toggle()
    running = not running
    if running then
        toggleBtn.Text = "Stop"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(170,0,0)
        claimed = {}
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

-- ===================================================================
--  Anti-AFK
-- ===================================================================
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

-- ===================================================================
--  Notificación
-- ===================================================================
game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="OrbFarm V2",
    Text="P → Start/Stop  |  Muévelo arrastrando",
    Duration=5
})
