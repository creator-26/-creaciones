-- ===================================================================
--  No-Limit Orb Farm 2.2  |  GUI idéntica al original
--  Solo más rápido y sin congelos
-- ===================================================================
local gui = Instance.new("ScreenGui")
gui.Name = "OrbFarmV2"
gui.Parent = game:GetService("CoreGui")
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local svcs = {
    pls = game:GetService("Players"),
    sg = game:GetService("StarterGui"),
    Tween = game:GetService("TweenService")
}

local plr = svcs.pls.LocalPlayer
local stage, running = 1, false
local max = 30
local claimed = {}

-- GUI exactamente igual que el original (no se toca nada)
local mframe = Instance.new("Frame")
mframe.BackgroundColor3 = Color3.fromRGB(20,20,20)
mframe.BackgroundTransparency = 0.1
mframe.Size = UDim2.new(0,220,0,130)
mframe.Position = UDim2.new(0.5,-110,0.5,-65)
local mcorner = Instance.new("UICorner",mframe)
mcorner.CornerRadius = UDim.new(0,6)
mframe.Parent = gui

local tbar = Instance.new("Frame",mframe)
tbar.BackgroundColor3 = Color3.fromRGB(25,25,25)
tbar.BackgroundTransparency = 0.1
tbar.Size = UDim2.new(1,0,0,28)
local tcorner = Instance.new("UICorner",tbar)
tcorner.CornerRadius = UDim.new(0,4)

local xbtn = Instance.new("TextButton",tbar)
xbtn.BackgroundTransparency = 1
xbtn.Position = UDim2.new(1,-20,0,0)
xbtn.Size = UDim2.new(0,20,1,0)
xbtn.Font = Enum.Font.Code
xbtn.Text = "×"
xbtn.TextColor3 = Color3.fromRGB(255,0,0)
xbtn.TextSize = 14
xbtn.AutoButtonColor = false
xbtn.MouseButton1Click:Connect(function() gui:Destroy() end)
xbtn.TouchTap:Connect(function() gui:Destroy() end)

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
    if v and v>=1 and v<=max then
        stage=v
    else
        sbox.Text=tostring(stage)
    end
end)

lbtn.MouseButton1Click:Connect(function()
    if stage>1 then
        stage=stage-1
        sbox.Text=tostring(stage)
    end
end)

rbtn.MouseButton1Click:Connect(function()
    if stage<max then
        stage=stage+1
        sbox.Text=tostring(stage)
    end
end)

-- ===================================================================
--  Utilidades (mismas que original, solo añadimos tween y antiFreeze)
-- ===================================================================
local function hrp()
    local char=plr.Character or plr.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

local function antiFreeze()
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum  = char:WaitForChild("Humanoid")
    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
    hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
    hum:ChangeState(Enum.HumanoidStateType.Running)
end

local function tp(cf)
    local root=hrp()
    antiFreeze()
    -- Tween suave en lugar de teleport brusco
    local goal = {CFrame = cf}
    local ti = TweenInfo.new((root.Position-cf.Position).Magnitude/120, Enum.EasingStyle.Linear)
    game:GetService("TweenService"):Create(root,ti,goal):Play()
end

-- ===================================================================
--  Recolección rápida (mismo recorrido, solo más rápido y sin congelos)
-- ===================================================================
local function collect()
    local boosts=workspace:WaitForChild("Map"):WaitForChild("Stages"):WaitForChild("Boosts")
    local stage_folder=boosts:FindFirstChild(tostring(stage))
    if not stage_folder then return end
    for _,model in ipairs(stage_folder:GetChildren()) do
        for _,orb in ipairs(model:GetDescendants()) do
            if not running then return end
            if orb:IsA("BasePart") then
                -- Hitbox gorda: si ya estamos cerca, solo esperamos a que desaparezca
                local dist = (hrp().Position - orb.Position).Magnitude
                if dist <= 8 then
                    repeat task.wait(0.05) until not orb.Parent or not running
                    continue
                end
                tp(orb.CFrame)
                task.wait(0.15)
            end
        end
    end
end

toggle_btn.MouseButton1Click:Connect(function()
    running=not running
    if running then
        toggle_btn.Text="Stop"
        toggle_btn.BackgroundColor3=Color3.fromRGB(170,0,0)
        task.spawn(function()
            while running do
                collect()
                task.wait(0.25)
            end
        end)
    else
        toggle_btn.Text="Start"
        toggle_btn.BackgroundColor3=Color3.fromRGB(0,170,0)
    end
end)

svcs.sg:SetCore("SendNotification",{
    Title="Tip",
    Text="teleport to your world, then input your stage",
    Duration=5
})
