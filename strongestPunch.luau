-- ===================================================================
--  No-Limit Orb Farm 3.1  |  Anti-Ban + GUI ORIGINAL completa
-- ===================================================================
local Players, Tween, UIS = game:GetService("Players"), game:GetService("TweenService"), game:GetService("UserInputService")
local plr = Players.LocalPlayer
local RUNNING, STAGE = false, 1
local MAX_ORBS_CYCLE = 200
local ORB_COUNT = 0
local RESTING = false
local HOTKEY = Enum.KeyCode.P
local MAX_STAGE = 30

-- ===================================================================
--  GUI COMPLETA (igual que el original)
-- ===================================================================
local gui = Instance.new("ScreenGui")
gui.Name = "OrbFarmV3"
gui.Parent = game:GetService("CoreGui")
gui.ResetOnSpawn = false

local mframe = Instance.new("Frame")
mframe.Size = UDim2.new(0,220,0,130)
mframe.Position = UDim2.new(0.5,-110,0.5,-65)
mframe.BackgroundColor3 = Color3.fromRGB(20,20,20)
mframe.BackgroundTransparency = 0.1
local mcorner = Instance.new("UICorner",mframe)
mcorner.CornerRadius = UDim.new(0,6)
mframe.Parent = gui

local tbar = Instance.new("Frame",mframe)
tbar.Size = UDim2.new(1,0,0,28)
tbar.BackgroundColor3 = Color3.fromRGB(25,25,25)
tbar.BackgroundTransparency = 0.1
local tcorner = Instance.new("UICorner",tbar)
tcorner.CornerRadius = UDim.new(0,4)

local xbtn = Instance.new("TextButton",tbar)
xbtn.Size = UDim2.new(0,20,1,0)
xbtn.Position = UDim2.new(1,-20,0,0)
xbtn.Text = "×"
xbtn.Font = Enum.Font.Code
xbtn.TextColor3 = Color3.fromRGB(255,0,0)
xbtn.TextSize = 14
xbtn.BackgroundTransparency = 1
xbtn.MouseButton1Click:Connect(function() gui:Destroy() end)

local tlabel = Instance.new("TextLabel",tbar)
tlabel.Size = UDim2.new(1,-26,1,0)
tlabel.Position = UDim2.new(0,8,0,0)
tlabel.Text = "No Limit Orb Farm | Anti-Ban"
tlabel.Font = Enum.Font.Code
tlabel.TextSize = 13
tlabel.TextColor3 = Color3.white
tlabel.BackgroundTransparency = 1
tlabel.TextXAlignment = Enum.TextXAlignment.Left

local function drag(f,b)
    local uis = game:GetService("UserInputService")
    local dragging, startPos, dragStart, conn
    b.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = Vector2.new(f.AbsolutePosition.X,f.AbsolutePosition.Y)
            conn = uis.InputChanged:Connect(function(ch)
                if dragging and (ch.UserInputType==Enum.UserInputType.MouseMovement or ch.UserInputType==Enum.UserInputType.Touch) then
                    local delta = ch.Position-dragStart
                    local vs = workspace.CurrentCamera.ViewportSize
                    f.Position=UDim2.new(0,math.clamp(startPos.X+delta.X,0,vs.X-f.AbsoluteSize.X),0,math.clamp(startPos.Y+delta.Y,0,vs.Y-f.AbsoluteSize.Y))
                end
            end)
            local endConn
            endConn=uis.InputEnded:Connect(function(e)
                if e.UserInputType==Enum.UserInputType.MouseButton1 or e.UserInputType==Enum.UserInputType.Touch then
                    dragging=false
                    if conn then conn:Disconnect() conn=nil end
                    endConn:Disconnect()
                end
            end)
        end
    end)
end
drag(mframe,tbar)

local slabel=Instance.new("TextLabel",mframe)
slabel.Size=UDim2.new(0,70,0,18)
slabel.Position=UDim2.new(0,10,0,40)
slabel.BackgroundTransparency=1
slabel.Font=Enum.Font.Code
slabel.TextSize=13
slabel.TextColor3=Color3.fromRGB(255,255,255)
slabel.Text="Stage:"

local lbtn=Instance.new("TextButton",mframe)
lbtn.Size=UDim2.new(0,25,0,22)
lbtn.Position=UDim2.new(0,85,0,38)
lbtn.Text="<"
lbtn.Font=Enum.Font.Code
lbtn.TextColor3=Color3.fromRGB(255,255,255)
lbtn.TextSize=13
lbtn.BackgroundColor3=Color3.fromRGB(25,25,25)

local sbox=Instance.new("TextBox",mframe)
sbox.Size=UDim2.new(0,50,0,22)
sbox.Position=UDim2.new(0,115,0,38)
sbox.Text="1"
sbox.ClearTextOnFocus=false
sbox.BackgroundColor3=Color3.fromRGB(25,25,25)
sbox.TextColor3=Color3.fromRGB(255,255,255)
sbox.Font=Enum.Font.Code
sbox.TextSize=13

local rbtn=lbtn:Clone()
rbtn.Text=">"
rbtn.Position=UDim2.new(0,175,0,38)
rbtn.Parent=mframe

local toggle_btn=Instance.new("TextButton",mframe)
toggle_btn.Size=UDim2.new(0,200,0,25)
toggle_btn.Position=UDim2.new(0,10,0,85)
toggle_btn.Text="Start"
toggle_btn.Font=Enum.Font.Code
toggle_btn.TextSize=13
toggle_btn.TextColor3=Color3.fromRGB(255,255,255)
toggle_btn.BackgroundColor3=Color3.fromRGB(0,170,0)

sbox.FocusLost:Connect(function()
    local v=tonumber(sbox.Text)
    if v and v>=1 and v<=MAX_STAGE then
        STAGE=v
        sbox.Text=tostring(STAGE)
    else
        sbox.Text=tostring(STAGE)
    end
end)

lbtn.MouseButton1Click:Connect(function()
    if STAGE>1 then
        STAGE=STAGE-1
        sbox.Text=tostring(STAGE)
    end
end)

rbtn.MouseButton1Click:Connect(function()
    if STAGE<MAX_STAGE then
        STAGE=STAGE+1
        sbox.Text=tostring(STAGE)
    end
end)

-- ===================================================================
--  Anti-Ban lógica
-- ===================================================================
local function rand(a,b) return math.random(a*100,b*100)/100 end
local function getRoot()
    local c = plr.Character or plr.CharacterAdded:Wait()
    return c:WaitForChild("HumanoidRootPart")
end
local function smallJump()
    local hum = (plr.Character or plr.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end

local ORB_COUNT = 0
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
        -- Toque real (sin TP): pequeño salto + pausa aleatoria
        smallJump()
        task.wait(rand(0.08,0.15))
        ORB_COUNT = ORB_COUNT + 1
    end
end

local function restCycle()
    toggle_btn.Text = "REST"
    toggle_btn.BackgroundColor3 = Color3.fromRGB(255,170,0)
    local rest = rand(120,180)
    for i = rest,1,-1 do
        if not RUNNING then break end
        toggle_btn.Text = "REST " .. i .. "s"
        task.wait(1)
    end
    ORB_COUNT = 0
    toggle_btn.Text = "Start"
    toggle_btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
end

local function toggle()
    RUNNING = not RUNNING
    if RUNNING then
        toggle_btn.Text = "Stop"
        toggle_btn.BackgroundColor3 = Color3.fromRGB(170,0,0)
        task.spawn(function()
            while RUNNING do
                if ORB_COUNT >= MAX_ORBS_CYCLE then
                    restCycle()
                end
                if RUNNING and ORB_COUNT < MAX_ORBS_CYCLE then
                    collectLoop()
                end
                task.wait(0.2)
            end
            toggle_btn.Text = "Start"
            toggle_btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
        end)
    else
        toggle_btn.Text = "Start"
        toggle_btn.BackgroundColor3 = Color3.fromRGB(0,170,0)
    end
end

toggle_btn.MouseButton1Click:Connect(toggle)
UIS.InputBegan:Connect(function(i,gp)
    if gp then return end
    if i.KeyCode == HOTKEY then toggle() end
end)

game:GetService("StarterGui"):SetCore("SendNotification",{
    Title="OrbFarm V3.1",
    Text="GUI restaurada. " .. string.upper(tostring(HOTKEY)) .. " → Start/Stop",
    Duration=5
})
